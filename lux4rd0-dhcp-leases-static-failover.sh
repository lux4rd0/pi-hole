# Publish Pi-Hole DHCP leases to Static LAN Address for Failover
# 0 * * * * /etc/pihole/lux4rd0-dhcp-leases-static-failover.sh >/dev/null 2>&1

IFS=$'\n'
for line in $(printf "$(cat /etc/pihole/dhcp.leases|tail -n +3|awk '{print $3, $4}')")
do
  client_ip=$(echo $line|awk '{print $1}')
  client_name=$(echo $line|awk '{print $2}')


output="echo $client_ip $client_name.pulpfree.net       $client_name >> /tmp/static-leases.tmp"
eval "$output"
done
sort /tmp/static-leases.tmp > /tmp/lux4rd0-static-leases.lan
cat /etc/hosts /tmp/lux4rd0-static-leases.lan > /tmp/lux4rd0-hosts

scp /tmp/lux4rd0-static-leases.lan root@pfdns02.pulpfree.net:/etc/pihole
scp /tmp/lux4rd0-hosts root@pfdns02.pulpfree.net:/etc/hosts
ssh root@pfdns02.pulpfree.net '/usr/local/bin/pihole restartdns'

rm /tmp/static-leases.tmp
