bash "modtile-install" do
  code <<-EOH
    mkdir #{node[:osm][:install_dir]}/mod-tile && cd #{node[:osm][:install_dir]}/mod-tile
    git clone #{node[:osm][:modtile][:repo]}
    cd mod_tile
    ./autogen.sh
    ./configure
    make
    sudo make install
    sudo make install-mod_tile
    sudo ldconfig
  EOH
  only_if { `find /usr/lib/apache2 2>/dev/null -name 'mod_tile.so' | grep 'mod_tile'`.chomp == "" }
end