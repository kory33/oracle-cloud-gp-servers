#!/bin/bash

print_lines_with_date () {
  # https://serverfault.com/a/310104
  while IFS= read -r line; do
    printf '[%s] %s\n' "$(date -Isecond)" "$line";
  done
}

restart_services () {
  cd /root/servers-repo
  git pull
  echo "Restarting services..."
  util/restart.sh services -d
  echo "Restarted services!"
}

main () {
  while true; do
    if [ -e /root/controller-trigger/restart-services ]; then
      rm /root/controller-trigger/restart-services
      restart_services
    fi
    sleep 1
  done
}

# clone the repository if not already done
git clone https://github.com/kory33/oracle-cloud-gp-servers \
  /root/servers-repo || true

# copy env files
cp /tmp/services/intercom.env /root/servers-repo/services/intercom.env

restart_services | print_lines_with_date
main | print_lines_with_date
