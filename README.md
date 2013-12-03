# Sets up OpenStreetMap PBF import environemnt

A `chef-solo` application for setting up the OpenStreetMap import environment.

## Installation

This software is baed on the installation instructions provided by [Switch2OSM](http://switch2osm.org/serving-tiles/manually-building-a-tile-server-12-04/). It is designed to work with Ubuntu 12.04.  
This software has been tested on EC2 `hi1.4xlarge` instances. It is very I/O intensive hence the instance type choice. `hi1.4xlarge` comes with 60GB of RAM and 2 SSD drives 1TB each. That's enough resources to finish the import in a reasonable time of ~16 hours.

Make sure you are running this software on a 64 bit system with 64 bit version of Ubuntu.

## What is happening here

OSM application

## Running

Upload `osm.sh` into some publicly available location. SSH into your `hi1.4xlarge` instance and run the following

    sudo bash
    curl -L your-uri-to-osm.sh | bash

When all required software is installed the instance is going to reboot. This is necessary, one of the requirements for PostgreSQL is the change some kernel settings (`sysctl.conf`, `kernel.shmmax=268435456`). Once the instance is back online SSH into it once again and do the following:

    mkdir /mnt2/planet && cd /mnt2/planet
    # you may want to change the link to a newer version of the PBF file
    wget ftp://ftp.spline.de/pub/openstreetmap/pbf/planet-131113.osm.pbf

Download should take about 7 minutes. After the file is downloaded execute the following:

    nohup sudo -u postgres osm2pgsql --slim -d gis -C 25000 --number-processes 10 /mnt2/planet/planet-131113.osm.pbf > /mnt2/nohup.out &

To see the progress:

    tail -F /mnt2/nohup.out

## Target import numbers

http://wiki.openstreetmap.org/wiki/Stats
Processing: Node(2084251k 210.8k/s) Way(204149k 25.38k/s) Relation(2234510 224.24/s)  parse time: 27895s

# License