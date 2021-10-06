#!/usr/bin/env ash
set -e

printf "\n\n*** CONTAINER INFO ***\n"
printf "  Host: $(hostname)\n"
printf "    IP: $(hostname -i)\n"
printf "    OS: $(awk '/Alpine/{print $3,$4,$5}' /etc/issue)\n"
printf "*** CONTAINER INFO ***\n\n"

echo "[$(date)] Creating config files"
ansible-playbook /opt/files/prestart.yml

echo "[$(date)] Starting ActiveMQ"
set -- /opt/activemq/bin/activemq console
exec "${@}"
