# Load Balancer
# Stilgar - Load Balancer
auto eth0
iface eth0 inet static
    address 10.70.4.1
    netmask 255.255.255.0
    gateway 10.70.4.0

# Server
# Mohiam - DHCP Server
auto eth0
iface eth0 inet static
    address 10.70.3.2
    netmask 255.255.255.0
    gateway 10.70.3.0

# Irulan - DNS Server
auto eth0
iface eth0 inet static
    address 10.70.3.1
    netmask 255.255.255.0
    gateway 10.70.3.0

# Chani - Database Server
auto eth0
iface eth0 inet static
    address 10.70.4.2
    netmask 255.255.255.0
    gateway 10.70.4.0