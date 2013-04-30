echo "Include /etc/apache2/mod_mono.conf" >> /etc/apache2/apache2.conf
cp files/mod_mono.load /etc/apache2/mods-available/mod_mono.load
cp files/mod_mono.conf /etc/apache2/mods-available/mod_mono.conf
cp files/mono-server2-hosts.conf /usr/local/lib/mono/2.0/mono-server2-hosts.conf

/etc/init.d/apache2 restart

