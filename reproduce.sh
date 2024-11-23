#!/usr/bin/env bash
sudo systemctl start nvidia-container-toolkit-cdi-generator
sudo systemctl start docker
docker ps -a
sudo systemctl stop docker
sudo systemctl list-units | grep 0d1bbc2c74a1 | awk '{print $1}' | xargs -I{} sudo systemctl stop {}
sudo systemctl daemon-reload
sudo systemctl stop nvidia-container-toolkit-cdi-generator
docker ps -a
sudo systemctl restart docker
docker ps -a
docker inspect 0d1bbc2c74a1 | jq '.[].State'
docker-compose up -d
