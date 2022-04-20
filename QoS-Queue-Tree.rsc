# This script sets up Queue Trees for QoS Rules
# See also QoS-Firewall-Mangle.txt
# Before running:
# - Check that max-limit is 90% of actual available bandwidth
# - Check the interface names for UP and DOWN rules

/queue tree

# DOWN
add name=DOWN max-limit=9M parent=bridge bucket-size=0.01 queue=default

add name="P1. VOIP"     packet-mark=VOIP     parent=DOWN priority=1 queue=default
add name="P1. TEAMS_AUDIO"  packet-mark=TEAMS_AUDIO parent=DOWN priority=1 queue=default
add name="P1. TEAMS_VIDEO"  packet-mark=TEAMS_VIDEO parent=DOWN priority=1 queue=default
add name="P1. TEAMS_SHARING"  packet-mark=TEAMS_SHARING parent=DOWN priority=1 queue=default
add name="P2. DNS"      packet-mark=DNS      parent=DOWN priority=2 queue=default
add name="P3. ACK"      packet-mark=ACK      parent=DOWN priority=3 queue=default
add name="P3. UDP"      packet-mark=UDP      parent=DOWN priority=3 queue=default
add name="P4. ICMP"     packet-mark=ICMP     parent=DOWN priority=4 queue=default
add name="P5. HTTP"     packet-mark=HTTP     parent=DOWN priority=5 queue=default
add name="P6. HTTP_BIG" packet-mark=HTTP_BIG parent=DOWN priority=6 queue=default
add name="P7. QUIC"     packet-mark=QUIC     parent=DOWN priority=7 queue=default
add name="P8. OTHER"    packet-mark=OTHER    parent=DOWN priority=8 queue=default


# UP
add name=UP max-limit=9M parent=ether1 bucket-size=0.01 queue=default

add name="P1. VOIP_"     packet-mark=VOIP     parent=UP priority=1 queue=default
add name="P1. TEAMS_AUDIO_"  packet-mark=TEAMS_AUDIO parent=UP priority=1 queue=default
add name="P1. TEAMS_VIDEO_"  packet-mark=TEAMS_VIDEO parent=UP priority=1 queue=default
add name="P1. TEAMS_SHARING_"  packet-mark=TEAMS_SHARING parent=UP priority=1 queue=default
add name="P2. DNS_"      packet-mark=DNS      parent=UP priority=2 queue=default
add name="P3. ACK_"      packet-mark=ACK      parent=UP priority=3 queue=default
add name="P3. UDP_"      packet-mark=UDP      parent=UP priority=3 queue=default
add name="P4. ICMP_"     packet-mark=ICMP     parent=UP priority=4 queue=default
add name="P5. HTTP_"     packet-mark=HTTP     parent=UP priority=5 queue=default
add name="P6. HTTP_BIG_" packet-mark=HTTP_BIG parent=UP priority=6 queue=default
add name="P7. QUIC_"     packet-mark=QUIC     parent=UP priority=7 queue=default
add name="P8. OTHER_"    packet-mark=OTHER    parent=UP priority=8 queue=default