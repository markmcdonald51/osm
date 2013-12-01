bash "apt-get-update" do
  action :nothing
  code <<-EOH
    apt-get -y update
  EOH
end

bash "add-apt-repository:mapnik/boost" do
  code <<-EOH
    add-apt-repository ppa:mapnik/boost
  EOH
  notifies :run, "bash[apt-get-update]", :immediately
end

%w[
libboost-dev
libboost-filesystem-dev
libboost-program-options-dev
libboost-python-dev
libboost-regex-dev
libboost-system-dev
libboost-thread-dev
subversion
git-core
tar
unzip
wget
bzip2
build-essential
autoconf
libtool
libxml2-dev
libgeos-dev
libpq-dev
libbz2-dev
proj
munin-node
munin
libprotobuf-c0-dev
protobuf-c-compiler
libfreetype6-dev
libpng12-dev
libtiff4-dev
libicu-dev
libgdal-dev
libcairo-dev
libcairomm-1.0-dev
apache2
apache2-dev
libagg-dev
liblua5.2-dev
ttf-unifont
postgresql-9.1-postgis
postgresql-contrib
postgresql-server-dev-9.1
].each do |pkg_name|
  package pkg_name
end

bash "remove-libgeos-dev" do
  code <<-EOH
    sudo apt-get -y remove libgeos-dev
    sudo apt-get -y autoremove
  EOH
end

bash "libgeos-install" do
  code <<-EOH
    rm -Rf /tmp/libgeos
    mkdir /tmp/libgeos && cd /tmp/libgeos
    git clone https://github.com/libgeos/libgeos.git
    cd libgeos
    ./autogen.sh
    ./configure
    make
    make check
    sudo make install # as root
    sudo ldconfig
  EOH
end