#!/bin/bash
#

current_dir=`pwd`
root_dir=$(dirname $current_dir)

function exe_cmd()
{
    echo $1
    eval $1
}

function copy_from_sample()
{
    local file_name=$1
    local sample_file_name=$2
    local tag_after_done=$3

    if [ ! -f $file_name ]; then 
        exe_cmd "cp -rf $sample_file_name $file_name"
    else
        local config_content=`cat $sample_file_name`
        change_line append $file_name "$tag_after_done" "$config_content";
    fi
}

# mode file tag_str content
function change_line() 
{
    local mode=$1
    local file=$2
    local tag_str=$3
    local content=$4
    local file_bak=$file".bak"
    local file_temp=$file".temp"
    cp -f $file $file_bak
    if [ $mode == "append" ]; then
        grep -q "$tag_str" $file || echo "$content" >> $file
    else
        cat $file |awk -v mode="$mode" -v tag_str="$tag_str" -v content="$content" '
        {
            if ( index($0, tag_str) > 0) {
                if ( mode == "after"){
                    printf( "%s\n%s\n", $0, content);

                } else if (mode == "before")
                {
                    printf( "%s\n%s\n", content, $0);

                } else if(mode == "replace") 
                {
                    print content;
                }
            } else if ( index ($0, content) > 0) 
            {
                # target content in line
                # do nothing
            } else
            {
                print $0;
            }
        }' > $file_temp
        mv $file_temp $file
    fi
}
