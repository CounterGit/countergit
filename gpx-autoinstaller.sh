#!/bin/sh
export HOME=$HOME
my_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}') &&
mysql_password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16) &&
sudo yum install httpd zip php unzip php-mysql php-bcmath php-posix php-common mysql mysql-server glibc.i686 libstdc++.i686 libgcc.i686 unzip wget -y &&
service mysqld start &&
echo -e "\ny\nspvb7494\nspvb7494\ny\nn\ny\ny" | /usr/bin/mysql_secure_installation &&
mysql -h"localhost" -u"root" -p""$mysql_password"" -e "CREATE DATABASE gamepanelx;" &&
mysql -h"localhost" -u"root" -p""$mysql_password"" -e "CREATE USER 'gpx'@localhost IDENTIFIED BY '$mysql_password';" &&
mysql -h"localhost" -u"root" -p""$mysql_password"" -e "GRANT ALL PRIVILEGES ON gamepanelx.* TO 'gpx'@localhost;" &&
mysql -h"localhost" -u"root" -p""$mysql_password"" -e "use gamepanelx;" &&
cd /var/www/html &&
wget https://github.com/devryan/GamePanelX-V3/archive/master.zip &&
unzip master.zip &&
rm -rf master.zip &&
cd &&
sudo sed -i 's/SELINUX=enabled/SELINUX=disabled/g' /etc/selinux/config &&
sudo setenforce 0 &&
sudo selinuxenabled 0 &&
cd /var/www/html/GamePanelX-V3-master &&
mv * .. &&
cd .. &&
if [ -f configuration.new.php ]; then sudo mv configuration.new.php configuration.php; fi &&
sudo chown apache: . -R &&
sudo chmod ug+rw configuration.php _SERVERS/* &&
sudo chmod ug+x _SERVERS/scripts/* &&
chkconfig httpd on &&
chkconfig mysqld on &&
service httpd restart &&
service mysqld restart &&
echo '

* Last step setup the game panel from here:

URL: '$my_ip'/install

MYSQL Details:
Host: localhost
User: gpx
Database: gamepanelx
Password: '$mysql_password'';
