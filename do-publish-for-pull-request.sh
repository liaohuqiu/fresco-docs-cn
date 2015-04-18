. ./base.sh
if [ $# -lt 1 ]; then
    echo "Usage: sh $0 pull-request-id"
    exit
fi

id=$1
exe_cmd 'git checkout docs'
exe_cmd 'git fetch'
exe_cmd 'git rebase origin/docs'
exe_cmd 'rvm 1.9.3'
exe_cmd 'sh publish-gh-pages.sh gh-pages'
exe_cmd "git commit -a -m 'published for $1'"
exe_cmd "git checkout docs"
exe_cmd "jekyll build"
exe_cmd "git push --all"
