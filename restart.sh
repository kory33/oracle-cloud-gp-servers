#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Exiting..." 
   exit 1
fi

docker-compose -f ./docker-compose.yml down
docker-compose -f ./docker-compose.yml pull
docker-compose -f ./docker-compose.yml up --force-recreate --build
