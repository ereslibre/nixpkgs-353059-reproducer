#!/usr/bin/env bash

export DOCKER_HOST=unix:///tmp/docker-testing

rm /tmp/docker-testing
pkill docker
pkill dockerd
pkill rootlesskit
pkill containerd

run_docker() {
    ~/.wip/dockerd &> output.txt &
    echo $!
}

docker ps -aq | xargs docker rm -f
sudo systemctl start nvidia-container-toolkit-cdi-generator
while true; do
    if ls /var/run/cdi; then
        break
    fi
    sleep 0.5
done
DOCKERD_PID=$(run_docker)
while true; do
    if docker ps; then
        break
    fi
    sleep 0.5
done
if ! docker ps -a | grep gpu-test-container; then
    docker-compose up -d
fi
docker ps -a
kill $DOCKERD_PID
tree /var/run/cdi
sudo systemctl stop nvidia-container-toolkit-cdi-generator
tree /var/run/cdi
docker ps -a
DOCKERD_PID=$(run_docker)
while true; do
    if docker ps; then
        break
    fi
    sleep 0.5
done
docker ps -a
docker inspect $(docker ps -aq --filter=name=gpu-test-container) | jq '.[].State'
kill $DOCKERD_PID
echo "> Waiting for dockerd stop (PID: $DOCKERD_PID)"
