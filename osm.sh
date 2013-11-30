WORKING_DIR=/etc/osm
rm -Rf /etc/osm
apt-get -y update
apt-get -y dist-upgrade
apt-get -y install git-core
curl -L https://www.opscode.com/chef/install.sh | bash
mkdir -p $WORKING_DIR/sources && cd $WORKING_DIR/sources
git clone https://github.com/radekg/osm.git .
chef-solo -c $WORKING_DIR/sources/solo.rb -j $WORKING_DIR/sources/solo.json