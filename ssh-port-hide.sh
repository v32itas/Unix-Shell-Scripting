#
# One more random note!
#
# Author: v32itas 
# Date: Nov:10:2015
# Source of knowledge would be #slackware and #openbsd
#
# This little trick is called "Port Knocking"
#
# It keeps SSH port 22 open and it apears to be open, from
# a simplest NMAP Scan, but you cannot get inside straight.
# you got to know how to knock. So in this case you can only
# get in trough SSH by knocking at 80,443,1337. What is even
# more deceptive that these 3 ports would appear to be open
# as well possibly tricking less skilled attacker into
# believing nonexistent things, That's why I prefer to call
# this "Port Hiding", because: 
# 'The art of disguise is knowing how to hide in plain sight' 
#
# However OpenBSD community discourages you from using it on
# anything serious, but it's ok for fun.
#
# Comment License:
# [CC BY-ND 3.0](http://creativecommons.org/licenses/by-nd/3.0)

#!/bin/sh
/sbin/iptables -t filter -A INPUT -p tcp -m multiport --dports 80,443,1337 -j REJECT --reject-with tcp-reset
/sbin/iptables -t filter -A INPUT -p tcp -m tcp --dport 22 -m connmark ! --mark 0x13F -j REJECT --reject-with tcp-reset
/sbin/iptables -t filter -A FORWARD -p tcp -m multiport --dports 80,443,1337 -j ACCEPT
/sbin/iptables -t mangle -A PREROUTING -p tcp -m multiport --dports 80,443,1337 -j CONNMARK --set-mark 0x13F
/sbin/iptables -t nat -A PREROUTING -p tcp -m multiport --dport 80,443,1337 -j REDIRECT --to-ports 22
exit 0
