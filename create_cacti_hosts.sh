IFS=$'\n'
for line in $(printf "$(cat /etc/pihole/dhcp.leases | awk '{print $3, $4}' | sed '/*/,/^/d')")
do

  client_name=$(echo $line|awk '{print $2}')

output="echo $client_name | tr '[:upper:]' '[:lower:]' >> /tmp/cacti-hosts.tmp"
eval "$output"
done

cat /etc/hosts |tail -n +3 | awk '{print $2}' >> /tmp/cacti-hosts.tmp

sort /tmp/cacti-hosts.tmp > /tmp/cacti-hosts.txt

cp /tmp/cacti-hosts.txt /mnt/attic/cacti

rm /tmp/cacti-hosts.tmp
