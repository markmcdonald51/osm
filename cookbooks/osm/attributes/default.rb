default[:osm][:install_dir] = "/etc/osm"

default[:osm][:postgre_username] = "postgres"
default[:osm][:superuser_name] = "osm"
default[:osm][:gis_database_name] = "gis"
default[:osm][:postgis_sql] = "/usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql"

default[:osm][:osm2pgsql][:repo] = "git://github.com/openstreetmap/osm2pgsql.git"

default[:osm][:mapnik][:repo] = "git://github.com/mapnik/mapnik"
default[:osm][:mapnik][:revision] = "2.3.x"
default[:osm][:mapnik_style][:repo] = "http://svn.openstreetmap.org/applications/rendering/mapnik"

default[:osm][:modtile][:repo] = "git://github.com/openstreetmap/mod_tile.git"

default[:osm][:config][:symbols] = "symbols"
default[:osm][:config][:projection] = "900913"
default[:osm][:config][:width_node_way] = "900913"
default[:osm][:config][:world_boundaries] = "/usr/local/share/world_boundaries"
default[:osm][:config][:prefix] = "planet_osm"
default[:osm][:config][:estimate_extent] = "false"
default[:osm][:config][:extent] = "-20037508,-19929239,20037508,19929239"

default[:osm][:config][:psql][:password] = nil
default[:osm][:config][:psql][:host] = "localhost"
default[:osm][:config][:psql][:port] = 5432
default[:osm][:config][:psql][:user] = nil
default[:osm][:config][:psql][:data_directory] = "/var/lib/postgresql/9.1/main"
default[:osm][:config][:psql][:dbname] = "gis"
default[:osm][:config][:psql][:shared_buffers] = "24MB"
default[:osm][:config][:psql][:shared_buffers_desired] = "128MB"
default[:osm][:config][:psql][:checkpoint_segments] = 20
default[:osm][:config][:psql][:maintenance_work_mem] = "256MB"
default[:osm][:config][:psql][:autovacuum] = "off"

default[:osm][:config][:renderd][:socketname] = "/var/run/renderd/renderd.sock"
default[:osm][:config][:renderd][:tile_dir] = "/var/lib/mod_tile"
default[:osm][:config][:renderd][:plugins_dir] = "/usr/local/lib/mapnik/input"
default[:osm][:config][:renderd][:font_dir] = "/usr/share/fonts/truetype/ttf-dejavu"
default[:osm][:config][:renderd][:host] = "localhost"