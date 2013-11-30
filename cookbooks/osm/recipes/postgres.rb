bash "postgres-ensure-directory" do
  code <<-EOH
    mkdir -p #{node[:osm][:config][:psql][:data_directory]}
    chown -R #{node[:osm][:postgre_username]}:#{node[:osm][:postgre_username]} #{node[:osm][:config][:psql][:data_directory]}
    chmod 0700 #{node[:osm][:config][:psql][:data_directory]}
    if [ "$(ls -A #{node[:osm][:config][:psql][:data_directory]})" ]; then
      echo "Directory already exists, skipping..."
    else
      sudo -u #{node[:osm][:postgre_username]} /usr/lib/postgresql/9.1/bin/initdb -D #{node[:osm][:config][:psql][:data_directory]} -E UTF8
    fi
  EOH
end

bash "postgres-restart" do
  action :nothing
  code <<-EOH
    kill -9 $(head -n 1 /var/run/postgresql/9.1-main.pid)
    rm -Rf /var/run/postgresql
    /etc/init.d/postgresql stop
    /etc/init.d/postgresql start
  EOH
end

template "/etc/postgresql/9.1/main/postgresql.conf" do
  source "postgresql.conf.erb"
  variables( :config => node[:osm][:config] )
  notifies :run, "bash[postgres-restart]", :immediately
end

bash "postgres-create-superuser-#{node[:osm][:superuser_name]}" do
  code <<-EOH
    sudo -u #{node[:osm][:postgre_username]} -i createuser #{node[:osm][:superuser_name]} -s
  EOH
  only_if { `echo "\\du" | sudo -u #{node[:osm][:postgre_username]} psql | grep #{node[:osm][:superuser_name]}`.chomp == "" }
end

bash "postgres-create-database-#{node[:osm][:gis_database_name]}" do
  code <<-EOH
    sudo -u #{node[:osm][:postgre_username]} -i createdb -E UTF8 -O #{node[:osm][:superuser_name]} #{node[:osm][:gis_database_name]}
  EOH
  only_if { `echo "\\list" | sudo -u #{node[:osm][:postgre_username]} psql | grep #{node[:osm][:gis_database_name]}`.chomp == "" }
end

bash "postgres-setup-postgis" do
  code <<-EOH
    sudo -u #{node[:osm][:postgre_username]} -i psql -f #{node[:osm][:postgis_sql]} -d #{node[:osm][:gis_database_name]}
  EOH
  only_if { `echo "\\c #{node[:osm][:gis_database_name]}; \\dt" | sudo -u #{node[:osm][:postgre_username]} psql | grep geometry_columns`.chomp == "" }
end

bash "postgres-update-permissions" do
  code <<-EOH
    sudo -u #{node[:osm][:postgre_username]} -i psql -d #{node[:osm][:gis_database_name]} -c "ALTER TABLE geometry_columns OWNER TO #{node[:osm][:superuser_name]}; ALTER TABLE spatial_ref_sys OWNER TO #{node[:osm][:superuser_name]};"
  EOH
  only_if { `echo "\\c #{node[:osm][:gis_database_name]}; \\dt" | sudo -u #{node[:osm][:postgre_username]} psql | grep geometry_columns`.chomp == "" }
end