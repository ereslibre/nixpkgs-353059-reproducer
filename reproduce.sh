#!/usr/bin/env bash

export DOCKER_HOST_PATH=/tmp/docker-testing
export DOCKER_HOST=unix://$DOCKER_HOST_PATH

kill_docker() {
    echo "Killing process $1"
    kill $1
    pkill docker
    pkill dockerd
    pkill rootlesskit
    pkill containerd
    while true; do
        if ! docker ps &> /dev/null; then
            break
        fi
        sleep 0.5
    done
    rm /tmp/docker-testing &> /dev/null
}

run_docker() {
    pkill rootlesskit
    ~/.wip/dockerd &> output.txt &
    RET_PID=$!
    while true; do
        if docker ps &> /dev/null; then
            echo "docker is available" 1>&2
            break
        fi
        sleep 0.5
    done
    echo $RET_PID
}

docker ps -aq | xargs docker rm -f
sudo systemctl start nvidia-container-toolkit-cdi-generator
while true; do
    if ls /var/run/cdi; then
        echo "/var/run/cdi present"
        break
    fi
    sleep 0.5
done
DOCKERD_PID=$(run_docker)
if ! docker ps -a | grep gpu-test-container; then
    echo "gpu-test-container not present, bringing up"
    docker-compose up -d
fi
docker ps -a
kill_docker $DOCKERD_PID
tree /var/run/cdi
#sudo systemctl stop nvidia-container-toolkit-cdi-generator
tree /var/run/cdi
docker ps -a
DOCKERD_PID=$(run_docker)
docker ps -a
docker inspect $(docker ps -aq --filter=name=gpu-test-container) | jq '.[].State'
kill_docker $DOCKERD_PID
echo "> Waiting for dockerd stop (PID: $DOCKERD_PID)"
