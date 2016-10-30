#!/bin/bash

set -e

prj_path=$(cd $(dirname $0); pwd -P)
SCRIPTFILE=`basename $0`

source $prj_path/base.sh

app_image=jekyll/jekyll:3.2.1
app_container=blog-jekyll

function run_blog_container() {
    cmd=$1
    args=''
    args="$args -v $prj_path:/opt/app"
    args="$args -w /opt/app"
    run_cmd "docker run -it $args --rm --name $app_container $app_image $cmd"
}

function stop_blog_container() {
    stop_container $app_container
}

function into_blog() {
    run_blog_container '/bin/bash'
}

function build_log() {
    run_blog_container 'jekyll build -w'
}

function show_usage() {
	cat <<-EOF
    
    Usage: mamanger.sh [options]

	    Valid options are:

            build                   build blog
            into-blog
            stop-blog

            -h                      show this help message and exit

EOF
	exit $1
}

while :; do
    case $1 in
        -h|-\?|--help)
            show_usage
            exit
            ;;
        build)
            build_log
            exit
            ;;
        into-blog)
            into_blog
            exit
            ;;
        stop-blog)
            stop_blog_container
            exit
            ;;
        *)               # Default case: If no more options then break out of the loop.
            printf 'ERROR: no such option.\n' >&2
            show_usage
            exit 1
            break
    esac

    shift
done
