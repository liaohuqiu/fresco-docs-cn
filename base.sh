#!/bin/bash

NC='\033[0m'      # Normal Color
RED='\033[0;31m'  # Error Color
CYAN='\033[0;36m' # Info Color

function run_cmd() {
    t=`date`
    echo $t":" $1
    eval $1
}

function ensure_dir() {
    if [ ! -d $1 ]; then
        run_cmd "mkdir -p $1"
    fi
}

function stop_container() {
    container_name=$1
    cmd="docker ps -a -f name='$container_name' | grep '$container_name' | awk '{print \$1}' | xargs -I {} docker rm -f --volumes {}"
    run_cmd "$cmd"
}

docker_domain=docker.srain.in

function push_image() {
    image_name=$1
    url=$docker_domain/$image_name
    run_cmd "docker tag -f $image_name $url"
    run_cmd "docker push $url"
}

function pull_image() {
    image_name=$1
    url=$docker_domain/$image_name
    run_cmd "docker pull $url"
    run_cmd "docker tag $url $image_name"
}
