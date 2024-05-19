#!/bin/bash

# Set the DNS server
echo 'nameserver 10.70.3.2' > /etc/resolv.conf

# Update the package list and install the ISC DHCP server
apt-get update
apt-get install isc-dhcp-server -y

# Configure the DHCP server
cat <<EOF > /etc/dhcp/dhcpd.conf
# Subnet for House Harkonen
subnet 10.70.1.0 netmask 255.255.255.0 {
    range 10.70.1.14 10.70.1.28;
    range 10.70.1.49 10.70.1.70;
    option routers 10.70.1.0;  # Gateway for this subnet
    option domain-name-servers 10.70.3.2;  # DNS server
    default-lease-time 300;  # Lease time for clients in Harkonen
    max-lease-time 5220;    # Max lease time
}

# Subnet for House Atreides
subnet 10.70.2.0 netmask 255.255.255.0 {
    range 10.70.2.15 10.70.2.25;
    range 10.70.2.200 10.70.2.210;
    option routers 10.70.2.0;  # Gateway for this subnet
    option domain-name-servers 10.70.3.2;  # DNS server
    default-lease-time 1200;  # Lease time for clients in Atreides
    max-lease-time 5220;     # Max lease time
}

subnet 10.70.3.0 netmask 255.255.255.0 {

}

subnet 10.70.4.0 netmask 255.255.255.0 {

}
EOF

rm /etc/default/isc-dhcp-server

cat <<EOF > /etc/default/isc-dhcp-server
# Defaults for isc-dhcp-server initscript
# sourced by /etc/init.d/isc-dhcp-server
# installed at /etc/default/isc-dhcp-server by the maintainer scripts

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
# Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="eth0"  # Replace with the actual interface connected to the network
# INTERFACESv6=""
EOF

rm -f /var/run/dhcpd.pid

# Restart the DHCP server to apply the configuration
service isc-dhcp-server restart

echo "DHCP server configuration is complete."