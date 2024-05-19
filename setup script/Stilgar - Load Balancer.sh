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

        # soal 12
        location / {
                allow 10.70.1.37;
                allow 10.70.1.67;
                allow 10.70.2.203;
                allow 10.70.2.207;
                deny all;
                proxy_pass http://worker;
        }

        location / {
                proxy_pass http://worker;
        
        # Soal 11
        location /dune {
                proxy_pass https://www.dunemovie.com.au/;
                proxy_set_header Host www.dunemovie.com.au;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}' > /etc/nginx/sites-available/lb-stilgar

ln -s /etc/nginx/sites-available/lb-stilgar /etc/nginx/sites-enabled

rm /etc/nginx/sites-enabled/default

echo 'upstream worker {
        10.70.2.2:8001; # Leto
        10.70.2.3:8002; # Duncan
        10.70.2.4:8003; # Jessica
}

server {
        listen 80;
        server_name atreides.it13.com www.atreides.it13.com;

        location / {
                proxy_pass http://worker;
        }
} 
' > /etc/nginx/sites-available/laravel-worker

ln -s /etc/nginx/sites-available/laravel-worker /etc/nginx/sites-enabled/laravel-worker

service nginx start

service php7.3-fpm restart