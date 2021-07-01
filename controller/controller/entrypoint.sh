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
  util/restart.sh services
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

restart_services | print_lines_with_date
main | print_lines_with_date
