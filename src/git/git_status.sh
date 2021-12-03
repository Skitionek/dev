#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :07/11/2019?
#email      :Skitionek@gmail.com
#==============================================================================

clear

# just for formatting
b=$(tput bold)
n=$(tput sgr0)

declare -A reppos

find . -name .git -print0 | xargs -0 -n1 dirname | sort --unique | while read -r dir
do
        reppo="${dir##*/}"
    echo "-- ${dir%/*}/${b}${reppo}${n} --"
    if [ ${reppos[$reppo]+_} ]
            then
                echo "Found another copy of this reppo in ${reppos[$reppo]}."
            else
                reppos[$reppo]=${dir}
    fi
    dir=${dir%*/}
    {
        (cd ${dir} && git status --ignore-submodules=all -s)
    } || {
        echo "Repository error!"
    }
    if [[ ! $(cd ${dir} && git status --ignore-submodules=all -s --porcelain) ]]; then
        echo "✓"
    fi
done