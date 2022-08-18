#!/bin/bash

source $(dirname "$0")/project_folders.sh

APPLE_SWIFT_STRING=`xcrun swift -version`
SWIFT_VERSION=`echo ${APPLE_SWIFT_STRING} | sed 's/Apple Swift version \(.*\) (.*/\1/'`

changed()
{
    files=$(git diff $1 --name-only --diff-filter=d)
    files_string=""
    count=0
    for file in $files
    do
        if [[ $file == *.swift ]]
        then
            folder=${file%%/*}
            if [[ " ${project_folders[@]} " =~ " ${folder} " ]]
            then
                if [ -f "$file" ]
                then
                    count+=1
                    files_string+=" $file"
                fi
            fi
        fi
    done
    $(swift run --package-path scripts/Format swiftformat --swiftversion $SWIFT_VERSION $files_string)

    if [ $count == 0 ]
    then
        echo "No .swift files changed"
    fi
}

since()
{
    if [ "$1" == "" ]
    then
        echo "Missing a commit hash"
    else
        echo "Changes since: $1"
        changed $1
    fi

}

all()
{
    echo "Running in all white listed folders"
    folders_string=""
    for i in "${project_folders[@]}"
    do
        folders_string+=" $i"
    done

    $(swift run --package-path scripts/Format swiftformat --swiftversion $SWIFT_VERSION $folders_string)
}

lintall()
{
    echo "Running in all white listed folders"
    ret=0
    for i in "${project_folders[@]}"
    do
        echo "Running in folder: $i"
        $(swift run --package-path scripts/Format swiftformat --lint --swiftversion $SWIFT_VERSION $i)
        RESULT=$?
        if [ $RESULT == 1 ]
        then
            ret=1
        fi
    done
    exit $ret
}

usage()
{
    echo "usage: [[[--all ] [--changed] [--since] [--lint]] | [--help]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -a | --all )        all
                            ;;
        -c | --changed )    changed "HEAD"
                            ;;
        -s | --since )      shift
                            since $1
                            ;;
        -l | --lint )       lintall
                            ;;
        -h | --help )       usage
                            exit
                            ;;
        * )                 all
                            exit 1
    esac
    shift
done
