bash "update-postgres-shared_buffers" do
  code <<-EOH
    sed -i "s/shared_buffers = #{node[:osm][:config][:psql][:shared_buffers]}/shared_buffers = #{node[:osm][:config][:psql][:shared_buffers_desired]}/g" /etc/postgresql/9.1/main/postgresql.conf
  EOH
end