IFS=$'\n'
for line in $(printf "$(cat /etc/pihole/dhcp.leases | awk '{print $3, $4}' | sed '/*/,/^/d')")
do

  client_name=$(echo $line|awk '{print $2}')

output="echo $client_name.tylephony.com | tr '[:upper:]' '[:lower:]' >> /tmp/telegraf-hosts.tmp"
eval "$output"
done

cat /etc/hosts |tail -n +3 | awk '{print $2}' >> /tmp/telegraf-hosts.tmp

echo "www.daveschmid.com" >> /tmp/telegraf-hosts.tmp
echo "www.boulph.com" >> /tmp/telegraf-hosts.tmp
echo "dns.google" >> /tmp/telegraf-hosts.tmp
echo "one.one.one.one" >> /tmp/telegraf-hosts.tmp

sort /tmp/telegraf-hosts.tmp > /mnt/docker/telegraf/ping/hosts.txt

rm /tmp/telegraf-hosts.tmp
