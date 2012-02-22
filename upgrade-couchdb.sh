#!/bin/bash

CVER=$1

echo "Upgrading to "$CVER

couchdb -d
echo "Press any key to continue"
read

rm -R /usr/local/lib/couchdb
rm -R /usr/local/share/couchdb
rm -R /etc/couchdb
# rm -R /usr/local/etc/couchdb
rm -R /usr/local/var/run/couchdb
rm -R /usr/lib/couchdb/

# make sure it's dead
# pkill -f couchdb
apt-get update
apt-get install xulrunner-dev libicu-dev libcurl4-gnutls-dev libtool
cd /src; mkdir couchdb; cd couchdb
wget http://apache.is.co.za//couchdb/$CVER/apache-couchdb-$CVER.tar.gz
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

