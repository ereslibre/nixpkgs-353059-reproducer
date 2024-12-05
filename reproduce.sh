#!/usr/bin/env bash

export DOCKER_HOST_PATH=/tmp/docker-testing
export DOCKER_HOST=unix://$DOCKER_HOST_PATH

kill_docker() {
    while true; do
        pkill docker &> /dev/null
    done
    while true; do
        pkill dockerd &> /dev/null
    done
    while true; do
        pkill rootlesskit &> /dev/null
    done
    while true; do
        pkill containerd &> /dev/null
    done
    rm /tmp/docker-testing &> /dev/null
}

run_docker() {
    ~/.wip/dockerd &> output.txt &
    RET_PID=$!
    while true; do
        if docker ps &> /dev/null; then
            break
        fi
        echo "wait 1"
        sleep 0.5
    done
    echo $RET_PID
}

docker ps -aq | xargs docker rm -f
sudo systemctl start nvidia-container-toolkit-cdi-generator
while true; do
    if ls /var/run/cdi; then
        break
    fi
    echo "wait 2"
    sleep 0.5
done
DOCKERD_PID=$(run_docker)
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
docker ps -a
docker inspect $(docker ps -aq --filter=name=gpu-test-container) | jq '.[].State'
kill $DOCKERD_PID
echo "> Waiting for dockerd stop (PID: $DOCKERD_PID)"
