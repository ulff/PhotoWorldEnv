#!/usr/bin/env bash

#general
apt-get update
apt-get install -y mc
apt-get install -y tree
sed -i -e"s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc

# apache2
apt-get install -y apache2
sed -i -e"s/\/var\/www\/html/\/var\/www/" /etc/apache2/sites-available/000-default.conf
rm -rf /var/www/html

#mysql
apt-get install -y mysql-client-core-5.5
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y mysql-server

#php
apt-get install -y php5
apt-get install -y php5-cli
apt-get install -y libapache2-mod-php5
apt-get install -y php5-gd
apt-get install -y php5-mysql
sed -i -e"s/max_execution_time = 30/max_execution_time = 300/" /etc/php5/apache2/php.ini
sed -i -e"s/memory_limit = 128M/memory_limit = 512M/" /etc/php5/apache2/php.ini
sed -i -e"s/display_errors = Off/display_errors = On/" /etc/php5/apache2/php.ini
sed -i -e"s/post_max_size = 8M/post_max_size = 256M/" /etc/php5/apache2/php.ini
sed -i -e"s/upload_max_filesize = 2M/upload_max_filesize = 250M/" /etc/php5/apache2/php.ini
/etc/init.d/apache2 restart

# install app
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
cd /var/www
composer install
php app/console doctrine:database:create
php app/console doctrine:schema:update --force


