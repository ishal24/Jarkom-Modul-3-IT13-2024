echo 'nameserver 10.70.3.2' > /etc/resolv.conf
apt-get update
apt-get install mariadb-server -y
service mysql start

rm /etc/mysql/mariadb.conf.d/50-server.cnf

cat <<EOF > /etc/mysql/mariadb.conf.d/50-server.cnf
[server]
[mysqld]

#
# * Basic Settings
#
user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
#port                   = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
#skip-external-locking

bind-address            = 0.0.0.0

query_cache_size        = 16M

log_error = /var/log/mysql/error.log

expire_logs_days        = 10

character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

[embedded]

[mariadb]

[mariadb-10.3]
EOF

cat <<EOF > /etc/mysql/my.cnf
# Options affecting the MySQL server (mysqld)
[mysqld]
skip-networking=0
skip-bind-address
EOF