. ./base.sh
if [ $# -lt 1 ]; then
    echo "Usage: sh $0 [ gh-pages | master ]"
    exit
fi

branch=$1
if [ -z "$branch" ] || [ "$branch" != "master" ]; then
    branch='gh-pages'
fi
exe_cmd "jekyll build"
if [ ! -d '_site' ];then
    echo "not content to be published"
    exit
fi

exe_cmd "git checkout $branch"
error_code=$?
if [ $error_code != 0 ];then
    echo 'Switch branch fail.'
    exit
else
    ls | grep -v _site|xargs rm -rf
    exe_cmd "cp -r _site/* ."
    exe_cmd "rm -rf _site/"
    exe_cmd "touch .nojekyll"
fi
