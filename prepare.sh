#!/bin/bash -e

KEEPALIVED_STATE=${KEEPALIVED_STATE:-"BACKUP"}
KEEPALIVED_ROUTER_ID=${KEEPALIVED_ROUTER_ID:-"51"}
KEEPALIVED_INTERFACE=${KEEPALIVED_INTERFACE:-"eth0"}
KEEPALIVED_PRIORITY=${KEEPALIVED_PRIORITY:-"150"}
KEEPALIVED_PASSWORD=${KEEPALIVED_PASSWORD:-"d0ck3r"}

sed -i "s|{{ KEEPALIVED_STATE }}|$KEEPALIVED_STATE|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_PASSWORD }}|$KEEPALIVED_PASSWORD|g" /etc/keepalived/keepalived.conf


if [ -n "$KEEPALIVED_NOTIFY" ]; then
sed -i "s|{{ KEEPALIVED_NOTIFY }}|notify \"$KEEPALIVED_NOTIFY\"|g" /etc/keepalived/keepalived.conf
chmod +x $KEEPALIVED_NOTIFY
else
KEEPALIVED_NOTIFY=/etc/keepalived/notify.sh
sed -i "s|{{ KEEPALIVED_NOTIFY }}|notify \"$KEEPALIVED_NOTIFY\"|g" /etc/keepalived/keepalived.conf
fi

IFS=';' read -ra ADDR <<< "$KEEPALIVED_VIRTUAL_IPS"
for i in "${ADDR[@]}"; do
   sed -i "s|{{ KEEPALIVED_VIRTUAL_IPS }}|${i}\n    {{ KEEPALIVED_VIRTUAL_IPS }}|g" /etc/keepalived/keepalived.conf
done
sed -i "/{{ KEEPALIVED_VIRTUAL_IPS }}/d" /etc/keepalived/keepalived.conf

exec /usr/sbin/keepalived -f /etc/keepalived/keepalived.conf --dont-fork --log-console ${KEEPALIVED_COMMAND_LINE_ARGUMENTS}