rm /et/resolv.conf
echo 'nameserver 10.70.3.2' > /etc/resolv.conf

apt-get update
apt-get install network-manager -y
apt-get install isc-dhcp-client -y
apt-get install udhcpc -y