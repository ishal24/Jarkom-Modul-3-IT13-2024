echo nameserver 10.70.3.2 > /etc/resolv.conf

apt-get update
apt-get install lynx nginx apache2-utils php7.3 php-fpm -y

service php7.3-fpm start

echo '
upstream worker {
        # least_conn;
    # ip_hash;
    # hash $request_uri consistent;
        # random two least_conn;
        server 10.70.1.2; # IP Vladimir
        server 10.70.1.3; # IP Rabban
        server 10.70.1.4; # IP Feyd
}

server {
        listen 80;

        root /var/www/html;

        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                proxy_pass http://worker;
    }
}' > /etc/nginx/sites-available/lb-stilgar

ln -s /etc/nginx/sites-available/lb-stilgar /etc/nginx/sites-enabled

rm /etc/nginx/sites-enabled/default

service nginx start

service php7.3-fpm restart