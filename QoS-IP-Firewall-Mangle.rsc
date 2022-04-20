# This script sets up QoS Mangle (tagging) rules.
# See also QoS-Queue-Tree.txt
# Before using these scripts, you need to disable the FastTrack rule in ip > firewall > filters and reboot

/ip firewall mangle

# Identify DNS on the network or coming from the Router itself
add chain=prerouting  action=mark-connection connection-state=new new-connection-mark=DNS port=53 protocol=udp passthrough=yes comment="DNS"
add chain=prerouting  action=mark-packet     connection-mark=DNS  new-packet-mark=DNS passthrough=no
add chain=postrouting action=mark-connection connection-state=new new-connection-mark=DNS port=53 protocol=udp passthrough=yes
add chain=postrouting action=mark-packet     connection-mark=DNS  new-packet-mark=DNS passthrough=no

# Identify MS Teams
add chain=prerouting  action=mark-connection new-connection-mark=TEAMS_AUDIO port=50000-50019 protocol=udp passthrough=yes comment="TEAMS"
add chain=prerouting  action=mark-connection new-connection-mark=TEAMS_AUDIO port=50000-50019 protocol=tcp passthrough=yes
add chain=prerouting  action=mark-packet     connection-mark=TEAMS_AUDIO new-packet-mark=TEAMS_AUDIO passthrough=no
add chain=prerouting  action=mark-connection new-connection-mark=TEAMS_VIDEO port=50020-50039 protocol=udp passthrough=yes
add chain=prerouting  action=mark-connection new-connection-mark=TEAMS_VIDEO port=50020-50039 protocol=tcp passthrough=yes
add chain=prerouting  action=mark-packet     connection-mark=TEAMS_VIDEO new-packet-mark=TEAMS_VIDEO passthrough=no
add chain=prerouting  action=mark-connection new-connection-mark=TEAMS_SHARING port=50040-50059 protocol=udp passthrough=yes
add chain=prerouting  action=mark-connection new-connection-mark=TEAMS_SHARING port=50040-50059 protocol=tcp passthrough=yes
add chain=prerouting  action=mark-packet     connection-mark=TEAMS_SHARING new-packet-mark=TEAMS_SHARING passthrough=no

# Identify VoIP
add chain=prerouting  action=mark-connection new-connection-mark=VOIP port=5060-5062,10000-10050 protocol=udp passthrough=yes comment="VOIP"
add chain=prerouting  action=mark-packet     connection-mark=VOIP new-packet-mark=VOIP passthrough=no

# Identify HTTP/3 and Google's QUIC
add chain=prerouting  action=mark-connection connection-state=new new-connection-mark=QUIC port=80,443 protocol=udp passthrough=yes comment="QUIC"
add chain=prerouting  action=mark-packet     connection-mark=QUIC new-packet-mark=QUIC passthrough=no

# Identify UPD. Useful for further analysis. Should it be considered high priority or put in the catchall? You decide.
add chain=prerouting  action=mark-connection connection-state=new new-connection-mark=UDP protocol=udp passthrough=yes comment="UDP"
add chain=prerouting  action=mark-packet     connection-mark=UDP  new-packet-mark=UDP passthrough=no

# Identify PING on the network or coming from the Router itself
add chain=prerouting  action=mark-connection connection-state=new new-connection-mark=ICMP protocol=icmp passthrough=yes comment="ICMP"
add chain=prerouting  action=mark-packet     connection-mark=ICMP new-packet-mark=ICMP passthrough=no
add chain=postrouting action=mark-connection connection-state=new new-connection-mark=ICMP protocol=icmp passthrough=yes
add chain=postrouting action=mark-packet     connection-mark=ICMP new-packet-mark=ICMP passthrough=no

# Identify Acknowledgment packets
add chain=postrouting action=mark-packet     new-packet-mark=ACK packet-size=0-123 protocol=tcp tcp-flags=ack passthrough=no comment="ACK"
add chain=prerouting  action=mark-packet     new-packet-mark=ACK packet-size=0-123 protocol=tcp tcp-flags=ack passthrough=no

# Identify HTTP traffic but move it to a Streaming mark if necessary.
add chain=prerouting  action=mark-connection connection-mark=no-mark  connection-state=new new-connection-mark=HTTP port=80,443 protocol=tcp passthrough=yes comment="HTTP"
add chain=prerouting  action=mark-connection connection-bytes=5M-0    connection-mark=HTTP connection-rate=2M-100M new-connection-mark=HTTP_BIG protocol=tcp passthrough=yes
add chain=prerouting  action=mark-packet     connection-mark=HTTP_BIG new-packet-mark=HTTP_BIG passthrough=no
add chain=prerouting  action=mark-packet     connection-mark=HTTP     new-packet-mark=HTTP passthrough=no

# Email goes to the catchall
add chain=prerouting  action=mark-connection connection-state=new new-connection-mark=POP3 port=995,465,587 protocol=tcp passthrough=yes comment="OTHER"
add chain=prerouting  action=mark-packet     connection-mark=POP3 new-packet-mark=OTHER passthrough=no

# Unknown goes to the catchall
add chain=prerouting  action=mark-connection connection-mark=no-mark new-connection-mark=OTHER passthrough=yes
add chain=prerouting  action=mark-packet     connection-mark=OTHER   new-packet-mark=OTHER passthrough=no