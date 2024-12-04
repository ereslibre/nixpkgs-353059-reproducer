#!/usr/bin/env bash
docker ps -aq | xargs docker rm -f
sudo systemctl start nvidia-container-toolkit-cdi-generator
sudo systemctl start docker
if ! docker ps -a | grep gpu-test-container; then
    docker-compose up -d
fi
docker ps -a
sudo systemctl stop docker
sudo systemctl list-units | grep docker | grep scope  | awk '{print $1}' | xargs -I{} sudo systemctl stop {}
sudo systemctl daemon-reload
tree /var/run/cdi
sudo systemctl stop nvidia-container-toolkit-cdi-generator
tree /var/run/cdi
docker ps -a
sudo systemctl restart docker
while true; do
    if docker ps; then
        break
    fi
    sleep 0.5
done
docker ps -a
docker inspect $(docker ps -aq --filter=name=gpu-test-container) | jq '.[].State'
