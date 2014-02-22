#!/bin/sh -x

USAGE="$0 source-branch dest-branch"

if [ $# == 1 -a \( x$1 == "x--help" -o x$1 == "x-h" \) ]
then
    echo $USAGE
    exit 0
fi

if [ $# != 2 ]
then
    echo $USAGE
    exit 1
fi

SOURCE_BRANCH_NAME=origin/$1
DEST_BRANCH_NAME=origin/$2

REPO_DIR=~/Development/browser-reviews
REVIEW_DIRNAME=~/Documents/Reviews/$(echo $SOURCE_BRANCH_NAME | tr / -)

cd $REPO_DIR
git fetch
COMMON_COMMIT=$(git merge-base $SOURCE_BRANCH_NAME $DEST_BRANCH_NAME)
CHANGED_FILES=$(git diff ${COMMON_COMMIT}..${SOURCE_BRANCH_NAME} --name-only | grep ^src)
if [ ! -d ${REVIEW_DIRNAME}/orig ]
then
    mkdir -p ${REVIEW_DIRNAME}/orig
    for file in $CHANGED_FILES
    do
        git show $COMMON_COMMIT:$file > ${REVIEW_DIRNAME}/orig/`basename $file`
    done
fi
LATEST_COMMIT_DATE=$(git log -n1 --format=format:%ai $SOURCE_BRANCH_NAME)
if [ ! -d "${REVIEW_DIRNAME}/${LATEST_COMMIT_DATE}" ]
then
    CURRENT_FOLDER="${REVIEW_DIRNAME}/${LATEST_COMMIT_DATE}"
    mkdir "$CURRENT_FOLDER"
    LATEST_DIR="${REVIEW_DIRNAME}/latest"
    rm -f "$LATEST_DIR"
    ln -s "${CURRENT_FOLDER}" "${LATEST_DIR}"
    for file in $CHANGED_FILES
    do
        git show "$SOURCE_BRANCH_NAME:$file" > "$CURRENT_FOLDER/`basename $file`"
    done
fi
cd -
