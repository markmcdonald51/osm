template "/etc/fstab" do
  source "fstab.erb"
end

ruby_block "mount_drives" do
  block do
    count = 1
    `blkid | grep ext3`.split("\n").each do |line|
      `mkdir -p /mnt#{count}`
      `echo "#{line.split(':').first} /mnt#{count}  auto  defaults,nobootwait,comment=cloudconfig 0 2" >> /etc/fstab`
      count = count + 1
    end
    `mount -a`
  end
end