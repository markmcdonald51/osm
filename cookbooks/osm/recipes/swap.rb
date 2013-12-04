bash "configure-swap" do
  code <<-EOH
    sudo dd if=/dev/zero of=#{node[:osm][:config][:swap][:location]} bs=1M count=#{node[:osm][:config][:swap][:size]}
    sudo mkswap #{node[:osm][:config][:swap][:location]}
    sudo swapon #{node[:osm][:config][:swap][:location]}
    echo "#{node[:osm][:config][:swap][:location]}  swap  swap  defaults   0   0" >> /etc/fstab
  EOH
end