#!/bin/bash
PROJECT_NAME=${1}
SRC_PATH=${4}
PROJECT_SRC=${SRC_PATH}"/"${PROJECT_NAME}
PROJECT_REPO=${2}
PROJECT_BRANCH=${3}

_dirName=`dirname $0` && _dirName=`cd $_dirName && pwd`
source "${_dirName}/util.sh"

if [ ! -n "$SRC_PATH" ];then
    echo "please input project dir"
    exit
fi
if [ ! -n "$PROJECT_NAME" ];then
    echo "please input project dir"
    exit
fi
if [ ! -n "$PROJECT_REPO" ];then
    echo "please input project repo"
    exit
fi
if [ ! -n "$PROJECT_BRANCH" ];then
    echo "please input project branch"
    exit
fi

if [ ! -x "$SRC_PATH" ];then
    mkdir $SRC_PATH -p
fi

if [ -x "$PROJECT_SRC" ];then
    $(robotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} Start git pull ${PROJECT_REPO} ${PROJECT_NAME}")
	echo "Start git pull path:"$PROJECT_SRC
    cd $PROJECT_SRC
    echo "pulling source code..."
    git reset --hard origin/$PROJECT_BRANCH
    git clean -f
    git pull origin ${PROJECT_BRANCH}
else
    $(robotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} Start git clone ${PROJECT_REPO} ${PROJECT_NAME}")
	echo "Start git clone path: "$PROJECT_SRC
	cd $SRC_PATH
	git clone $PROJECT_REPO $PROJECT_NAME
	cd $PROJECT_NAME
fi

git checkout $PROJECT_BRANCH

echo "build..."
npm install
if [ $? -eq 0 ];then
    $(robotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm install success")
else
    $(robotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm install fail")
    exit
fi
export branch=$PROJECT_BRANCH
script="${PROJECT_SRC}/index.js"
count=`ps -ef |grep $script |grep -v "grep" |wc -l`
if [ 0 == $count ];then
    echo $script begin run
    pm2 start $script --name="${PROJECT_NAME} ${PROJECT_BRANCH}"
else
    echo $script restart
    pm2 restart $script --name="${PROJECT_NAME} ${PROJECT_BRANCH}"
fi
if [ $? -eq 0 ];then
    $(robotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm start success")
else
    $(robotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm start fail")
    exit
fi
echo "Finished."