# Lapres Praktikum Jaringan Komputer Modul-3 IT13
**Anggota Kelompok**

| Nama                   | NRP          |
| ---------------------- | ------------ |
| Muhammad Faishal Rizqy | `5027221026` |
| Rafif Dhimaz Ardhana   | `5027221066` |

## Membuat rancangan topologi
**Topologi:**
![Topology](https://github.com/ishal24/Jarkom-Modul-3-IT13-2024/blob/main/img/Topology.png)

## Konfigurasi Node
- #### Arakis (DHCP Relay)
```bash
# NAT1
auto eth0
iface eth0 inet dhcp

# Harkonen
auto eth1
iface eth1 inet static
    address 10.70.1.0
    netmask 255.255.255.0

# Atreides
auto eth2
iface eth2 inet static
    address 10.70.2.0
    netmask 255.255.255.0

# Corrino
auto eth3
iface eth3 inet static
    address 10.70.3.0
    netmask 255.255.255.0

# Fremen
auto eth4
iface eth4 inet static
    address 10.70.4.0
    netmask 255.255.255.0
```

- #### Mohiam (DHCP Server)
```bash
auto eth0
iface eth0 inet static
    address 10.70.3.2
    netmask 255.255.255.0
    gateway 10.70.3.0
```

- #### Irulan (DNS Server)
```bash
auto eth0
iface eth0 inet static
    address 10.70.3.1
    netmask 255.255.255.0
    gateway 10.70.3.0
```

- #### Chani (Database Sever)
```bash
auto eth0
iface eth0 inet static
    address 10.70.4.2
    netmask 255.255.255.0
    gateway 10.70.4.0
```

- #### Stilgar (Load Balancer)
```bash
auto eth0
iface eth0 inet static
    address 10.70.4.1
    netmask 255.255.255.0
    gateway 10.70.4.0
```

- #### Leto (Laravel Worker)
```bash
auto eth0
iface eth0 inet static
    address 10.70.2.2
    netmask 255.255.255.0
    gateway 10.70.2.0
```

- #### Duncan (Laravel Worker)
```bash
auto eth0
iface eth0 inet static
    address 10.70.2.3
    netmask 255.255.255.0
    gateway 10.70.2.0
```

- #### Jessica (Laravel Worker)
```bash
auto eth0
iface eth0 inet static
    address 10.70.2.4
    netmask 255.255.255.0
    gateway 10.70.2.0
```

- #### Vladimir (PHP Worker)
```bash
auto eth0
iface eth0 inet static
    address 10.70.1.2
    netmask 255.255.255.0
    gateway 10.70.1.0
```

- #### Rabban (PHP Worker)
```bash
auto eth0
iface eth0 inet static
    address 10.70.1.3
    netmask 255.255.255.0
    gateway 10.70.1.0
```

- #### Feyd (PHP Worker)
```bash
auto eth0
iface eth0 inet static
    address 10.70.1.4
    netmask 255.255.255.0
    gateway 10.70.1.0
```

- #### Dmitri (Client)
```bash
auto eth0
iface eth0 inet dhcp
```

- #### Paul (Client)
```bash
auto eth0
iface eth0 inet dhcp
```
## *Bagian 0*
### **(Soal 0)** Registrasi Domain [0]
> Register domain ```atreides.it13.com``` untuk worker Laravel yang mengarah pada Leto & register domain ```harkonen.it13.com``` untuk worker PHP yang mengarah pada Vladimir.

- #### Setup Irulan agar domain terdaftar
```bash
echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y  

mkdir -p /etc/bind/dune

cat <<EOF > /etc/bind/named.conf.local
zone "harkonen.it13.com" {
        type master;
        file "/etc/bind/dune/harkonen.it13.com";
};

zone "atreides.it13.com" {
        type master;
        file "/etc/bind/dune/atreides.it13.com";
};
EOF

cat <<EOF > /etc/bind/dune/harkonen.it13.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     harkonen.it13.com. root.harkonen.it13.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      harkonen.it13.com.
@       IN      A       10.70.1.2     ; IP Vladimir
www     IN      CNAME   harkonen.it13.com.
EOF

cat <<EOF > /etc/bind/dune/atreides.it13.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     atreides.it13.com. root.atreides.it13.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      atreides.it13.com.
@       IN      A       10.70.2.2     ; IP Leto
www     IN      CNAME   atreides.it13.com.
EOF
```


### **(Soal 1)** Lakukan konfigurasi sesuai dengan peta
- #### Setup Arakis sebagai DHCP Relay
```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.70.0.0/16

apt-get update

echo "isc-dhcp-relay isc-dhcp-relay/servers string 10.70.3.3" | debconf-set-selections
echo "isc-dhcp-relay isc-dhcp-relay/interfaces string eth1 eth2 eth3 eth4" | debconf-set-selections
echo "isc-dhcp-relay isc-dhcp-relay/options string" | debconf-set-selections

apt-get install isc-dhcp-relay -y

cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

service isc-dhcp-relay restart
```

- ### Setup Mohiam sebagai DHCP Server
```bash
echo 'nameserver 10.70.3.2' > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y

rm /etc/default/isc-dhcp-server

cat <<EOF > /etc/default/isc-dhcp-server
# Defaults for isc-dhcp-server initscript
# sourced by /etc/init.d/isc-dhcp-server
# installed at /etc/default/isc-dhcp-server by the maintainer scripts

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
# Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="eth0"  
# INTERFACESv6=""
EOF

rm -f /var/run/dhcpd.pid

service isc-dhcp-server restart
```
- ### Setup Clients (Paul & Dmitri)
```bash
echo 'nameserver 10.70.3.2' > /etc/resolv.conf

apt-get update
apt-get install network-manager -y
apt-get install isc-dhcp-client -y
apt-get install udhcpc -y
```

## *Bagian 1*

### **(Soal 1)** [1]
> Semua CLIENT harus menggunakan konfigurasi dari DHCP Server
- #### Tambahkan line script agar setiap node terkoneksi dengan DHCP
```bash
echo 'nameserver 10.70.3.2' > /etc/resolv.conf
```

### **(Soal 2)** [2]
> Client yang melalui **House Harkonen** mendapatkan range IP dari [prefix IP].1.14 - [prefix IP].1.28 dan [prefix IP].1.49 - [prefix IP].1.70
- #### Menambahkan IP range untuk Harkonen
```bash
subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.14 10.70.1.28;
    range 10.70.1.49 10.70.1.70;
    option routers 10.70.1.0;
    option domain-name-servers 10.70.3.2;
}

subnet 10.70.3.0 netmask 255.255.255.0 {

}
```
Script snippet tersebut akan disematkan pada file script node Mohiam. Tidak lupa juga ditambahkan untuk switchnya (Atreides).

#### Results
**[INSERT RESULTS]**

### **(Soal 3)** [3]
> Client yang melalui **House Atreides** mendapatkan range IP dari [prefix IP].2.15 - [prefix IP].2.25 dan [prefix IP].2 .200 - [prefix IP].2.210

- #### Menambahkan IP range untuk Atreides
```bash
subnet 10.70.2.0 netmask 255.255.255.0 {
    range 10.70.2.15 10.70.2.25;
    range 10.70.2.200 10.70.2.210;
    option routers 10.70.2.0;
    option domain-name-servers 10.70.3.2;
}

subnet 10.70.4.0 netmask 255.255.255.0 {

}
```
Sama seperti nomor sebelumnya, script snippet tersebut akan disematkan pada file script node Mohiam. Tidak lupa juga ditambahkan untuk switchnya (Harkonen).

#### Results
**[INSERT RESULTS]**

### **(Soal 4)** [4]
> Client mendapatkan DNS dari Princess Irulan dan dapat terhubung dengan internet melalui DNS tersebut

- #### Menambahkan Forwarder pada script Irulan
```bash
cat <<EOF > /etc/bind/named.conf.options
options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      allow-query{any;};
      auth-nxdomain no;
      listen-on-v6 { any; };
};
EOF

service bind9 restart
```
Forwarder tersebut ditambahkan agar setiap request yang masuk dapat ditujukan ke Irulan yang berlaku sebagai DNS Server dan terhubung ke internet. Tidak lupa untuk melakukan restart pada bind9 agar perubahan yang kita buat dapat dijalankan dengan benar.\

#### Results
![Soal 4](https://github.com/ishal24/Jarkom-Modul-3-IT13-2024/blob/main/img/ping_web.png)

### **(Soal 5)** [5]
> Durasi DHCP server meminjamkan alamat IP kepada Client yang melalui House Harkonen selama 5 menit sedangkan pada client yang melalui House Atreides selama 20 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 87 menit

- #### Menambahkan Lease Time configuration pada kedua House
```bash
# Subnet for House Harkonen
subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.14 10.70.1.28;
    range 10.70.1.49 10.70.1.70;
    option routers 10.70.1.0;
    option domain-name-servers 10.70.3.2;
    default-lease-time 300;  # Lease time for clients in Harkonen
    max-lease-time 5220;    # Max lease time
}
```

```bash
# Subnet for House Atreides
subnet 10.70.2.0 netmask 255.255.255.0 {
    range 10.70.2.15 10.70.2.25;
    range 10.70.2.200 10.70.2.210;
    option routers 10.70.2.0;
    option domain-name-servers 10.70.3.2;
    default-lease-time 1200;  # Lease time for clients in Atreides
    max-lease-time 5220;     # Max lease time
}
```

#### Results
- Lease Time Dmitri
![LT Dmitri](https://github.com/ishal24/Jarkom-Modul-3-IT13-2024/blob/main/img/lease_time_dmitri.png)

- Lease Time Paul
![LT Paul](https://github.com/ishal24/Jarkom-Modul-3-IT13-2024/blob/main/img/lease_time_paul.png)

## *Bagian 2*
### **(Soal 1)** [6]
> Vladimir Harkonen memerintahkan setiap worker(harkonen) PHP, untuk melakukan konfigurasi virtual host untuk website *dari soal* dengan menggunakan php 7.3

- #### Script Worker PHP (Vladimir, Rabban, Feyd)
```bash
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
```

#### Results
**[INSERT RESULTS]**

### **(Soal 2)** [7]
> Aturlah agar Stilgar dari fremen dapat dapat bekerja sama dengan maksimal, lalu lakukan testing dengan 5000 request dan 150 request/second.

- #### Script Stilgar sebagai Load Balancer
```bash
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
```

- #### Command Client
Masukkan command ini pada salah satu client, dalam kasus ini dicoba pada Dmitri
```bash
ab -n 5000 -c 50 http://www.harkonen.it13.com/ 
```

#### Results
- Request
![Request 7](https://github.com/ishal24/Jarkom-Modul-3-IT13-2024/blob/main/img/no_7_request.png)
- Result
![Result 7](https://github.com/ishal24/Jarkom-Modul-3-IT13-2024/blob/main/img/no_7_result.png)

### **(Soal 3)** [8]
> Karena diminta untuk menuliskan peta tercepat menuju spice, buatlah analisis hasil testing dengan 500 request dan 50 request/second masing-masing algoritma Load Balancer

Algoritma yang akan digunakan untuk melakukan analisis jaringan kali ini adalah Round-Robin, Least Connection, IP Hash, Generic Hash

Untuk penjelasan detail mengenai network analisis ini telah tercantum pada file [```IT13.Spice.pdf```]()