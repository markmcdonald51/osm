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

    nohup sudo -u postgres osm2pgsql -d gis -C 25000 --number-processes 10 /mnt2/planet/planet-131113.osm.pbf > /mnt2/nohup.out &

No `--slim` required but `swap` is necessary. This cookbook assumes that the instance comes up with 2 drives (instance storage), both SSD. You will need a lot of storage and `c3.8xlarge` is not enough.

The weird thing is, on `h1.4xlarge` `osm2pgsql` is going to eat up all virtual and physical memory so swap is required. I've noticed that `-C` argument has no effect. All these arguments work fine on `c3.8xlarge`. I have no clue why this is but swap on SSDs fixes it.

To see the progress:

    tail -F /mnt2/nohup.out

## Target import numbers (4th of December 2013, h1.4xlarge on EC2)

    osm2pgsql SVN version 0.85.0 (64bit id space)
    
    Using projection SRS 900913 (Spherical Mercator)
    Setting up table: planet_osm_point
    NOTICE:  table "planet_osm_point" does not exist, skipping
    NOTICE:  table "planet_osm_point_tmp" does not exist, skipping
    Setting up table: planet_osm_line
    NOTICE:  table "planet_osm_line" does not exist, skipping
    NOTICE:  table "planet_osm_line_tmp" does not exist, skipping
    Setting up table: planet_osm_polygon
    NOTICE:  table "planet_osm_polygon" does not exist, skipping
    NOTICE:  table "planet_osm_polygon_tmp" does not exist, skipping
    Setting up table: planet_osm_roads
    NOTICE:  table "planet_osm_roads" does not exist, skipping
    NOTICE:  table "planet_osm_roads_tmp" does not exist, skipping
    Using built-in tag processing pipeline
    Allocating memory for dense node cache
    Allocating dense node cache in one big chunk
    Allocating memory for sparse node cache
    Sharing dense sparse
    Node-cache: cache=25000MB, maxblocks=3200000*8192, allocation method=3
    Mid: Ram, scale=100
    
    Reading in file: /mnt2/planet/planet-131113.osm.pbf
    Processing: Node(2084251k 1217.4k/s) Way(204149k 16.27k/s) Relation(2234510 251.78/s)  parse time: 23134s
    
    Node stats: total(2084251660), max(2530028096) in 1712s
    Way stats: total(204149024), max(245905425) in 12547s
    Relation stats: total(2234511), max(3322905) in 8875s
    Committing transaction for planet_osm_point
    Committing transaction for planet_osm_line
    Committing transaction for planet_osm_polygon
    Committing transaction for planet_osm_roads
    
    Writing way (204149k)
    Committing transaction for planet_osm_point
    Committing transaction for planet_osm_line
    Committing transaction for planet_osm_polygon
    Committing transaction for planet_osm_roads
    
    Writing relation (2230896)
    Sorting data and creating indexes for planet_osm_point
    Sorting data and creating indexes for planet_osm_line
    Sorting data and creating indexes for planet_osm_roads
    Sorting data and creating indexes for planet_osm_polygon
    node cache: stored: 2084251660(100.00%), storage efficiency: 86.72% (dense blocks: 2199604, sparse nodes: 75448717), hit rate: 100.00%
    Analyzing planet_osm_point finished
    Analyzing planet_osm_roads finished
    Analyzing planet_osm_line finished
    Analyzing planet_osm_polygon finished
    Copying planet_osm_point to cluster by geometry finished
    Creating geometry index on  planet_osm_point
    Copying planet_osm_roads to cluster by geometry finished
    Creating geometry index on  planet_osm_roads
    Creating indexes on  planet_osm_roads finished
    All indexes on  planet_osm_roads created  in 1707s
    Completed planet_osm_roads
    Creating indexes on  planet_osm_point finished
    All indexes on  planet_osm_point created  in 3246s
    Completed planet_osm_point
    Copying planet_osm_line to cluster by geometry finished
    Creating geometry index on  planet_osm_line
    Creating indexes on  planet_osm_line finished
    All indexes on  planet_osm_line created  in 9793s
    Completed planet_osm_line
    Copying planet_osm_polygon to cluster by geometry finished
    Creating geometry index on  planet_osm_polygon
    Creating indexes on  planet_osm_polygon finished
    All indexes on  planet_osm_polygon created  in 14150s
    Completed planet_osm_polygon
    
    Osm2pgsql took 66078s overall

# Do yourself a favor

Once the import is completed take a dump, `pg_dump` that is. You are running on SSDs which are ephemerals. If the instance is stopped, the data is lost.

    mkdir /mnt2/pgdump && chmod 0777 /mnt2/pgdump
    sudo -u postgres pg_dump -U root -f /mnt2/pgdump/gis.sql gis

And store it somehwere.

# License

Author: Radek Gruchalski : radek@gruchalski.com

Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.