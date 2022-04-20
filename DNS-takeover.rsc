# This script sets up DNS (Port 53) takeover. Useful with things like Pi-hole.
/ip firewall nat

add chain=dstnat action=dst-nat to-addresses=192.168.69.2 protocol=udp src-address=!192.168.69.2 dst-address=!192.168.69.2 dst-port=53
add chain=dstnat action=dst-nat to-addresses=192.168.69.2 protocol=tcp src-address=!192.168.69.2 dst-address=!192.168.69.2 dst-port=53

add chain=srcnat action=masquerade protocol=udp src-address=192.168.69.0/24 dst-address=192.168.69.2 dst-port=53
add chain=srcnat action=masquerade protocol=tcp src-address=192.168.69.0/24 dst-address=192.168.69.2 dst-port=53
