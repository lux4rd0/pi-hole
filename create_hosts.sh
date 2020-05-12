IFS=$'\n'
for line in $(printf "$(cat /etc/pihole/dhcp.leases | awk '{print $3, $4}' | sed '/*/,/^/d')")
do

  client_name=$(echo $line|awk '{print $2}')

output="echo $client_name.tylephony.com | tr '[:upper:]' '[:lower:]' >> /tmp/whirlchart-hosts.tmp"
eval "$output"
done

cat /etc/hosts |tail -n +3 | awk '{print $2}' >> /tmp/whirlchart-hosts.tmp

echo "www.daveschmid.com" >> /tmp/whirlchart-hosts.tmp
echo "www.boulph.com" >> /tmp/whirlchart-hosts.tmp
echo "dns.google" >> /tmp/whirlchart-hosts.tmp
echo "one.one.one.one" >> /tmp/whirlchart-hosts.tmp

sort /tmp/whirlchart-hosts.tmp > /tmp/whirlchart-hosts.txt

cp /tmp/whirlchart-hosts.txt /mnt/docker/whirlchart/config

rm /tmp/whirlchart-hosts.tmp
