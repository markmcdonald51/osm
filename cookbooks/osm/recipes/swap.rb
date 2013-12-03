bash "configure-swap" do
  code <<-EOH
    sudo dd if=/dev/zero of=/mnt2/swapfile bs=1M count=102400
    sudo mkswap /mnt2/swapfile
    sudo swapon /mnt2/swapfile
  EOH
end