
Install PHP 8.2
```bash
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
apt update
apt install -y php8.2
apt install -y php-bz2 php-curl php-intl php-mbstring php-xdebug php-zip unzip


```

Install Composer
```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/bin --filename=composer
php -r "unlink('composer-setup.php');"

printf "export COMPOSER_ALLOW_SUPERUSER=1" >> ~/.bashrc && source ~/.bashrc

```

Configure Apache2
```bash
a2enmod rewrite
a2enmod actions

sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
systemctl restart apache2

```

After initial file sync
```bash
cd /var/www
find html -type f -exec chmod 664 {} + -o -type d -exec chmod 775 {} +
usermod -a -G www-data root

```

After composer install/update (or as needed)
```bash
chown -R www-data:www-data /var/www/html
```


