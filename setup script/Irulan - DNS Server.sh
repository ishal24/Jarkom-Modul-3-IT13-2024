echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y  

mkdir -p /etc/bind/dune
echo <<EOF > /etc/bind/named.conf.local
zone "harkonen.it13.com" {
        type master;
        file "/etc/bind/dune/harkonen.it13.com";
};

zone "atreides.it13.com" {
        type master;
        file "/etc/bind/dune/atreides.it13.com";
};
EOF

echo <<EOF > /etc/bind/dune/harkonen.it13.com
;
; BIND data file for local loopback interface
;
$TTL    604800
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

echo <<EOF > /etc/bind/dune/atreides.it13.com
;
; BIND data file for local loopback interface
;
$TTL    604800
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

echo <<EOF > /etc/bind/named.conf.options
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