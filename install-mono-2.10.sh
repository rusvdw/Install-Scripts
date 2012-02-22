#!/bin/bash

LIBVER="2.10.8"
MONOVER="2.10.8"
XSPVER="2.10.2"
MODVER="2.10"

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

wget http://download.mono-project.com/sources/libgdiplus/libgdiplus-$LIBVER.tar.bz2
wget http://download.mono-project.com/sources/mono/mono-$MONOVER.tar.bz2
wget http://download.mono-project.com/sources/xsp/xsp-$XSPVER.tar.bz2
wget http://download.mono-project.com/sources/mod_mono/mod_mono-$MODVER.tar.bz2

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
