#!/bin/bash

#instructions adapted from http://blog.mackerron.com/2012/06/01/postgis-2-ubuntu-12-04/

GEOSVER='3.3.7'
GDALVER='1.9.2'
POSTGISVER='2.0.2'

sudo /etc/init.d/postgresql-8.4 stop

# Remove existing PostGIS and dependancies
sudo aptitude remove postgis postgresql-8.4-postgis libgdal1-dev libgdal1-1.6.0 gdal-bin python-gdal libspatialite2 libspatialite3 libgeos-dev libgeos-c1

# install any missing prerequisites
sudo aptitude install build-essential checkinstall postgresql postgresql-server-dev-8.4 libjson0-dev libxml2-dev libproj-dev python2.6-dev swig

mkdir /src
cd /src

# kill the script on any errors from here
set -e

# download and compile geos in /opt/geos

wget http://download.osgeo.org/geos/geos-3.3.7.tar.bz2
tar xvjf geos-3.3.7.tar.bz2
cd geos-3.3.7/
./configure --prefix=/opt/geos --enable-python
make -j2
make install

# download and compile gdal in /opt/gdal
cd /src/
wget http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz
tar xvzf gdal-1.9.2.tar.gz
cd gdal-1.9.2/
./configure --prefix=/opt/gdal --with-geos=/opt/geos/bin/geos-config --with-pg=/usr/lib/postgresql/8.4/bin/pg_config --with-python
make -j2
make install

# download and compile postgis 2 in default location
cd /src/
wget http://www.postgis.org/download/postgis-2.0.2.tar.gz
tar xvzf postgis-2.0.2.tar.gz
cd postgis-2.0.2/
./configure --with-geosconfig=/opt/geos/bin/geos-config --with-gdalconfig=/opt/gdal/bin/gdal-config
make -j2
make install

# for command-line tools, append this line to .profile/.bashrc/etc.
export PATH=$PATH:/opt/geos/bin:/opt/gdal/bin

# so libraries are found, create /etc/ld.so.conf.d/geolibs.conf  with these two lines:

echo '/opt/geos/lib' > /etc/ld.so.conf.d/geolibs.conf
echo '/opt/gdal/lib' >> /etc/ld.so.conf.d/geolibs.conf

# then
sudo ldconfig

sudo /etc/init.d/postgresql-8.4 start

cp /usr/lib/postgresql/8.4/bin/shp2pgsql /usr/bin/
cp /usr/lib/postgresql/8.4/bin/pgsql2shp /usr/bin/

