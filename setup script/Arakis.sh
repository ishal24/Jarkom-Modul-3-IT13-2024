#!/bin/bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.70.0.0/16

# Update package lists
apt-get update

# Pre-configure the answers for isc-dhcp-relay
echo "isc-dhcp-relay isc-dhcp-relay/servers string 10.70.3.3" | debconf-set-selections
echo "isc-dhcp-relay isc-dhcp-relay/interfaces string eth1 eth2 eth3 eth4" | debconf-set-selections
echo "isc-dhcp-relay isc-dhcp-relay/options string" | debconf-set-selections

# Install isc-dhcp-relay
apt-get install isc-dhcp-relay -y

cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

# Restart the relay service to apply configurations
service isc-dhcp-relay restart