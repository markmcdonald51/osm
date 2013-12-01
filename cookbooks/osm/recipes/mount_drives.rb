template "/etc/fstab" do
  source "fstab.erb"
end

ruby_block "mount_drives" do
  block do
    fstab = []
    count = 1
    desired_type = "ext4"
    `fdisk -l 2>&1 | grep doesn`.split("\n").each{|line|
            device = line.split(" ")[1]
            uuid = `blkid -o value -s UUID #{device}`.chomp
            type = `blkid -o value -s TYPE #{device}`.chomp
            label = `blkid -o value -s LABEL #{device}`.chomp
            puts "#{device} :: #{uuid} :: #{type} :: #{label}"
            if uuid.empty? and label.empty? and type.empty?
                    `sudo mkfs -t #{desired_type} #{device}`
                    `mkdir -p /mnt#{count}`
                    mount_point = "/mnt#{count}"
                    fstab << "#{device}     /mnt#{count}  #{desired_type} defaults,nobootwait,comment=cloudconfig      0       2"
            else
                    # get mount point
                    mount_point = `mount -l | grep #{device}`.chomp.split(" ")[1]
                    options = ( mount_point == "/" ? "defaults" : "defaults,nobootwait,comment=cloudconfig" )
                    fstab << "#{device}     #{mount_point}  #{type} #{options}      0       2"
            end
    }
    `rm -Rf /etc/fstab`
    fstab.each {|fstab_line|
            `echo "#{fstab_line}" >> /etc/fstab`
    }
    `mount -a`
  end
end