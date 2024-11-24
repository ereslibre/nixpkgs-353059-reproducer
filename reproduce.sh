#!/usr/bin/env bash
sudo systemctl start nvidia-container-toolkit-cdi-generator
sudo systemctl start docker
docker ps -a
sudo systemctl stop docker
sudo systemctl list-units | grep 53c8e1740bd4 | awk '{print $1}' | xargs -I{} sudo systemctl stop {}
sudo systemctl daemon-reload
sudo systemctl stop nvidia-container-toolkit-cdi-generator
docker ps -a
sudo systemctl restart docker
docker ps -a
docker inspect 53c8e1740bd4 | jq '.[].State'
# docker-compose up -d
