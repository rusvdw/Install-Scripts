#!/bin/bash

LIBVER="2.6.7"
MONOVER="2.6.7"
XSPVER="2.6.5"
MODVER="2.6.3"
URL="http://download.mono-project.com/sources"

apt-get remove mono-common
apt-get update
apt-get install build-essential pkg-config libglib2.0-dev bison libcairo2-dev libungif4-dev libjpeg62-dev libtiff4-dev gettext apache2-threaded-dev

mkdir /src
mkdir /src/monoscript$MONOVER
cd /src/monoscript$MONOVER

echo "Creating uninstall script..."
echo "#!/bin/bash" > uninstall.sh
echo "cd /src/monoscript"$MONOVER"/mod_mono-"$MODVER >> uninstall.sh
echo "make uninstall" >> uninstall.sh
echo "cd /src/monoscript"$MONOVER"/xsp-"$XSPVER >> uninstall.sh
echo "make uninstall" >> uninstall.sh
echo "cd /src/monoscript"$MONOVER"/mono-"$MONOVER >> uninstall.sh
echo "make uninstall" >> uninstall.sh
echo "cd /src/monoscript"$MONOVER"/libgdiplus-"$LIBVER >> uninstall.sh
echo "make uninstall" >> uninstall.sh

chmod +x uninstall.sh

wget $URL/libgdiplus/libgdiplus-$LIBVER.tar.bz2
wget $URL/mono/mono-$MONOVER.tar.bz2
wget $URL/xsp/xsp-$XSPVER.tar.bz2
wget $URL/mod_mono/mod_mono-$MODVER.tar.bz2

tar -xvf libgdiplus-$LIBVER.tar.bz2
tar -xvf mono-$MONOVER.tar.bz2
tar -xvf xsp-$XSPVER.tar.bz2
tar -xvf mod_mono-$MODVER.tar.bz2

# compile libgdipluss
cd libgdiplus-$LIBVER
./configure --prefix=/usr/local; make; make install
sh -c "echo /usr/local/lib >> /etc/ld.so.conf"
/sbin/ldconfig

# compile mono
cd ../mono-$MONOVER
./configure --prefix=/usr/local; make; make install

# compile xsp
cd ../xsp-$XSPVER
./configure --prefix=/usr/local; make; make install

# compile mod_mono
cd ../mod_mono-$MODVER
./configure --prefix=/usr/local; make; make install

/sbin/ldconfig

echo "Updating the browser capabilities file..."

cd /usr/local/etc/mono/
rm browscap.ini
wget -O browscap.ini http://browsers.garykeith.com/stream.asp?BrowsCapINI


echo "DONE!"
