#!/bin/bash
# example iptables script for Firewalling your Server
# read the comments first, then change, THEN implete to your server!

# safe this script on your server, make it executeable (chmod +x script), execute it
# to check your rules
# iptables -L -n -v

# iptable rules get resetted when the server reboots, so to make this consitent, 2 Ways:

# add script to crontab with:
# crontab -e
# add row:
# @reboot /path/to/script.sh

# add script to systemd with:
# copy script (executable!) 
# cp script.sh /etc/systemd/system/myown_iptables_firewall.service
# systemctl start myown_iptables_firewall
# systemctl enable myown_iptables_firewall

# to disable crontab, remove line from crontab

# to disable systemd
# systemctl stop myown_iptables_firewall
# systemctl disable myown_iptables_firewall

# H.Eudenbach in 2021 - holger@eude.rocks - no warranties given!

# Here we start - remeber, Rules work from Top to Bottom, Position in the Script is VITAL
# this deletes all old Rules
iptables -F
iptables -t nat -F
iptables -X
 
# Basic Rules
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
 
# localhost allow
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
 
# let requestet pakets pass
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m tcp -p tcp --tcp-flags ALL ACK -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m tcp -p tcp --tcp-flags ALL ACK -j ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m tcp -p tcp --tcp-flags ALL ACK -j ACCEPT
 
# icmp allow
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT
 
##### Internet
 
#example allow certain Ports (20, 21, 22, 50000 - 50500), for certain IP's
iptables -A INPUT -p tcp -m multiport --dport 20,21,22,50000:50500 -s 8.8.8.8 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dport 20,21,22,50000:50500 -s 9.9.9.9 -j ACCEPT
 
#same but with a full subnet
iptables -A INPUT -p tcp -m multiport --dport 20,21,22,50000:50500 -s 7.7.7.0/22 -j ACCEPT
 
#drop all other connections to those ports except the ones in the row before
iptables -A INPUT -p tcp -m multiport --dport 20,21,22,50000:50500 -j DROP
 
# http, https and Port 9000 allow
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 9000 -j ACCEPT

# exampel checkmk allow with certain IP, all other connections DROP
iptables -A INPUT -p tcp -m multiport --dport 6556,6557 -s 6.6.6.6 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dport 6556,6557 -j DROP
 
### Beginn Debug, enable to debug 
#iptables -N LOGGING
#iptables -A INPUT -j LOGGING
#iptables -A OUTPUT -j LOGGING
#iptables -A FORWARD -j LOGGING
#iptables -A LOGGING -j LOG --log-prefix "IPTables-Reject: " --log-level 4
### Ende Debug
 
# all other Forward-Traffic rejected:
iptables -A FORWARD -j REJECT
iptables -A INPUT -j REJECT