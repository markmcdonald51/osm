bash "osm2pgsql-install" do
  code <<-EOH
    mkdir /tmp/osm2pgsl/src && cd /tmp/osm2pgsql/src
    git clone #{node[:osm][:osm2pgsql][:repo]}
    cd osm2pgsql
    ./autogen.sh
    ./configure
    make
    sudo make install
  EOH
  only_if { `osm2pgsql 2>&1 | grep help`.chomp == "" }
end

bash "osm2pgsl-load-script" do
  code <<-EOH
    sudo -u #{node[:osm][:postgre_username]} -i psql -f /usr/local/share/osm2pgsql/$(ls /usr/local/share/osm2pgsql | grep sql) -d #{node[:osm][:gis_database_name]}
  EOH
  only_if { `sudo -u #{node[:osm][:postgre_username]} -i psql -d #{node[:osm][:gis_database_name]} -c "select count(*) from spatial_ref_sys where srid=$(ls /usr/local/share/osm2pgsql | grep sql | awk -F "." '{print $1}');" | grep ' 1'`.chomp == "" }
end
