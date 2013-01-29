#!/bin/bash

#instructions adapted from http://blog.mackerron.com/2012/06/01/postgis-2-ubuntu-12-04/

GEOSVER='3.3.7'
GDALVER='1.9.2'
POSTGISVER='2.0.2'

sudo /etc/init.d/postgresql-9.1 stop

# Remove existing PostGIS and dependancies
sudo aptitude remove postgis postgresql-9.1-postgis \
  libgdal1-dev libgdal1-1.7.0 gdal-bin python-gdal \
  libspatialite2 libspatialite3 libgeos-dev libgeos-c1 libgeos-dev

# install any missing prerequisites
sudo aptitude install build-essential checkinstall postgresql \
  postgresql-server-dev-9.1 libjson0-dev libxml2-dev libproj-dev \
  python2.7-dev swig

mkdir /src
cd /src

# kill the script on any errors from here
set -e

# download and compile geos 

wget http://download.osgeo.org/geos/geos-3.3.7.tar.bz2
tar xvjf geos-3.3.7.tar.bz2
cd geos-3.3.7/
./configure --prefix=/usr/ --enable-python
make -j2
make install

# download and compile gdal in /opt/gdal
cd /src/
wget http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz
tar xvzf gdal-1.9.2.tar.gz
cd gdal-1.9.2/
./configure --prefix=/usr/ --with-geos=/usr/bin/geos-config --with-pg=/usr/lib/postgresql/9.1/bin/pg_config --with-python
make -j2
make install

# download and compile postgis 2 in default location
cd /src/
wget http://www.postgis.org/download/postgis-2.0.2.tar.gz
tar xvzf postgis-2.0.2.tar.gz
cd postgis-2.0.2/
./configure --with-geosconfig=/usr/bin/geos-config --with-gdalconfig=/usr/bin/gdal-config
make -j2
make install

# then
sudo ldconfig

sudo /etc/init.d/postgresql-9.1 start

cp /usr/lib/postgresql/9.1/bin/shp2pgsql /usr/bin/
cp /usr/lib/postgresql/9.1/bin/pgsql2shp /usr/bin/

