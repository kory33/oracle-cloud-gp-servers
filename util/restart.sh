#!/bin/bash

cd $1

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

docker-compose pull && docker-compose build
docker-compose down && docker-compose up --force-recreate $2
