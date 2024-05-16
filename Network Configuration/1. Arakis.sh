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