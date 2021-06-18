#!/bin/bash

cd "$(dirname "$0")"

sudo docker-compose -f ./docker-compose.yml down
sudo docker-compose -f ./docker-compose.yml pull
sudo docker-compose -f ./docker-compose.yml up --force-recreate --build
