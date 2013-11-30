bash "mapnik-style-install" do
  action :nothing
  code <<-EOH
    cd #{node[:osm][:install_dir]}/mapnik_style
    svn co #{node[:osm][:mapnik_style][:repo]} .
    sudo ./get-coastlines.sh /usr/local/share
  EOH
end

directory "#{node[:osm][:install_dir]}/mapnik_style" do
  recursive true
  notifies :run, "bash[mapnik-style-install]", :immediately
end