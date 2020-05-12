# Publish Pi-Hole DHCP leases to Static LAN Address for Failover
# 0 * * * * /etc/pihole/lux4rd0-dhcp-leases-static-failover.sh >/dev/null 2>&1

IFS=$'\n'
for line in $(printf "$(cat /etc/pihole/dhcp.leases|tail -n +3|awk '{print $3, $4}')")
do
  client_ip=$(echo $line|awk '{print $1}')
  client_name=$(echo $line|awk '{print $2}')


output="echo $client_ip	$client_name.tylephony.com	$client_name >> /tmp/static-leases.tmp"
eval "$output"
done 
sort /tmp/static-leases.tmp > /tmp/lux4rd0-static-leases.lan
cat /etc/hosts /tmp/lux4rd0-static-leases.lan > /tmp/lux4rd0-hosts

scp /tmp/lux4rd0-static-leases.lan root@dns02.tylephony.com:/etc/pihole
scp /tmp/lux4rd0-hosts root@dns02.tylephony.com:/etc/hosts
ssh root@dns02.tylephony.com '/usr/local/bin/pihole restartdns'

rm /tmp/static-leases.tmp
