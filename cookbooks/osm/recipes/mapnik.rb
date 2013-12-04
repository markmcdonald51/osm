bash "mapnik-install" do
  code <<-EOH
    mkdir #{node[:osm][:install_dir]}/mapnik && cd #{node[:osm][:install_dir]}/mapnik
    git clone #{node[:osm][:mapnik][:repo]} .
    git branch #{node[:osm][:mapnik][:revision]} origin/#{node[:osm][:mapnik][:revision]}
    git checkout #{node[:osm][:mapnik][:revision]}

    python scons/scons.py configure INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/truetype/
    python scons/scons.py
    sudo python scons/scons.py install
    sudo ldconfig
  EOH
  only_if { `python -c 'import mapnik'`.chomp != "" }
end