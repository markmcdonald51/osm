template "#{node[:osm][:install_dir]}/mapnik_style/inc/settings.xml.inc" do
  source "settings.xml.inc.erb"
  variables( :config => node[:osm][:config] )
end

template "#{node[:osm][:install_dir]}/mapnik_style/inc/datasource-settings.xml.inc" do
  source "datasource-settings.xml.inc.erb"
  variables( :config => node[:osm][:config] )
end

template "#{node[:osm][:install_dir]}/mapnik_style/inc/fontset-settings.xml.inc" do
  source "fontset-settings.xml.inc.erb"
  variables( :config => node[:osm][:config] )
end

template "/usr/local/etc/renderd.conf" do
  source "renderd.conf.erb"
  variables( :install_dir => node[:osm][:install_dir], :config => node[:osm][:config] )
end

directory File.dirname(node[:osm][:config][:renderd][:socketname])
directory node[:osm][:config][:renderd][:tile_dir]

template "/etc/apache2/conf.d/mod_tile" do
  source "mod_tile.erb"
end

template "/etc/apache2/sites-available/default" do
  source "apache2-site-default.erb"
  variables( :config => node[:osm][:config] )
end

template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
end