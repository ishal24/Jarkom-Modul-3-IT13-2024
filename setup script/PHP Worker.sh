#!/bin/bash

echo 'nameserver 10.70.3.2' > /etc/resolv.conf

apt-get update
apt-get install -y nginx wget unzip lynx htop apache2-utils
apt-get install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip -y

service nginx start
service php7.3-fpm start

wget -O '/var/www/harkonen.zip' 'https://drive.usercontent.google.com/u/0/uc?id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30&export=download'
unzip -o '/var/www/harkonen.zip' -d '/var/www/'

rm /var/www/harkonen.zip
mv /var/www/modul-3/ /var/www/harkonen/

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/harkonen

cat <<EOF > /etc/nginx/sites-available/harkonen
server {
    listen 80;
    server_name _;

    root /var/www/harkonen;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;  # Sesuaikan versi PHP dan socket
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

rm /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/harkonen /etc/nginx/sites-enabled/

service nginx restart
