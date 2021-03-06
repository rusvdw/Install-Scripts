#!/bin/bash

CVER="1.0.4"

# first, install the packaged version to get all the requirements
apt-get install couchdb -y
/etc/init.d/couchdb stop

apt-get remove couchdb -y
apt-get build-dep couchdb -y
apt-get install xulrunner-dev libicu-dev libcurl4-gnutls-dev libtool erlang-os-mon -y
cd /src; mkdir couchdb; cd couchdb

wget http://kt01.net/deploy/files/apache-couchdb-$CVER.tar.gz
#wget http://apache.is.co.za/couchdb/source/$CVER/apache-couchdb-$CVER.tar.gz
tar -zxvf apache-couchdb-$CVER.tar.gz; cd apache-couchdb-$CVER/

# now get the xul runner version that was installed
XULVER=`ls /usr/lib | grep  xulrunner-devel- | sed -n 's/^xulrunner-devel-//p'`

echo "/usr/lib/xulrunner-"$XULVER >> /etc/ld.so.conf.d/xulrunner.conf
echo "/usr/lib/xulrunner-devel-"$XULVER >> /etc/ld.so.conf.d/xulrunner.conf
/sbin/ldconfig

./configure --with-js-lib=/usr/lib/xulrunner-devel-$XULVER/lib --with-js-include=/usr/lib/xulrunner-devel-$XULVER/include
make
make install
adduser --home /usr/local/var/lib/couchdb couchdb
cp /usr/local/etc/init.d/couchdb /etc/init.d/couchdb
chown -R couchdb:root /usr/local/var/run/couchdb;
chown -R couchdb:root /usr/local/var/log/couchdb;
chown -R couchdb:root /usr/local/lib/couchdb;
chmod -R 0777 /usr/local/var/run/couchdb;
chmod -R 0777 /usr/local/var/log/couchdb;
chmod -R 0777 /usr/local/lib/couchdb;
update-rc.d couchdb defaults

# make sure it's dead
pkill -9 -f couchdb
