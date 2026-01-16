#!/bin/sh

LOG_FILE="/var/log/wireguard.log"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

# 1) Reverting our previously set IP forwarding overrides
/usr/sbin/sysctl -w net.inet.ip.forwarding=0
/usr/sbin/sysctl -w net.inet6.ip6.forwarding=0 
log "IP forwarding disabled"

# 2) Remove the IPv4 filter rule by reference. Adding and
#    removing rules by references like this will automatically
#    disable the packet filter firewall if there are no other
#    references left, but will leave it up if there are.
ANCHOR="com.apple/wireguard_ipv4"
pfctl -a ${ANCHOR} -F all || exit 1
echo "Removed IPv4 rule with anchor: ${ANCHOR}"
IPV4_TOKEN=`sudo cat /usr/local/var/run/wireguard/pf_wireguard_ipv4_token.txt`
pfctl -X ${IPV4_TOKEN} || exit 1
echo "Removed reference for token: ${IPV4_TOKEN}"
rm -rf /usr/local/var/run/wireguard/pf_wireguard_ipv4_token.txt
echo "Deleted IPv4 token file"
log "IPv4 NAT removed"

# 3) Remove the IPv6 filter rule by reference. Adding and
#    removing rules by references like this will automatically
#    disable the packet filter firewall if there are no other
#    references left, but will leave it up if there are.
ANCHOR="com.apple/wireguard_ipv6"
pfctl -a ${ANCHOR} -F all || exit 1
echo "Removed IPv6 rule with anchor: ${ANCHOR}"
IPV6_TOKEN=`sudo cat /usr/local/var/run/wireguard/pf_wireguard_ipv6_token.txt`
pfctl -X ${IPV6_TOKEN} || exit 1
echo "Removed reference for token: ${IPV6_TOKEN}"
rm -rf /usr/local/var/run/wireguard/pf_wireguard_ipv6_token.txt
echo "Deleted IPv6 token file"
log "IPv6 NAT removed"
