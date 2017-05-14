#!/bin/bash
SRC_PATH='/www/project/src'
WEB_PATH='/www/project/web'
WEB_USER='www'
WEB_USERGROUP='www'

PROJECT_NAME=${1}
PROJECT_SRC=${SRC_PATH}"/"${PROJECT_NAME}
PROJECT_WEB=${WEB_PATH}"/"${PROJECT_NAME}
PROJECT_REPO=${2}
PROJECT_BRANCH=${3}

dingdingRobotMsg(){
    curl 'https://oapi.dingtalk.com/robot/send?access_token=xxxx' \
    -H 'Content-Type: application/json' \
    -d "
    {\"msgtype\": \"text\",
    \"text\": {
        \"content\" : \"${1}\"
     }
    }"
}

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
    $(dingdingRobotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} Start git pull ${PROJECT_REPO} ${PROJECT_NAME}")
	echo "Start git pull path:"$PROJECT_SRC
    cd $PROJECT_SRC
    echo "pulling source code..."
    git reset --hard origin/$PROJECT_BRANCH
    git clean -f
    git pull
else
    $(dingdingRobotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} Start git clone ${PROJECT_REPO} ${PROJECT_NAME}")
	echo "Start git clone path:"$PROJECT_SRC
	cd $SRC_PATH
	git clone $PROJECT_REPO $PROJECT_NAME
	cd $PROJECT_NAME
fi

git checkout $PROJECT_BRANCH

echo "build..."
npm install
if [ $? ];then
    $(dingdingRobotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm install success")
else
    $(dingdingRobotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm install fail")
    exit
fi
npm run build
if [ $? ];then
    $(dingdingRobotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm build success")
else
    $(dingdingRobotMsg "${PROJECT_NAME} ${PROJECT_BRANCH} npm build fail")
    exit
fi
echo "release to web path"
if [ ! -x "$PROJECT_WEB" ];then
    mkdir $PROJECT_WEB -p
fi
yes|cp -a $PROJECT_SRC/dist/* $PROJECT_WEB
echo "changing permissions..."
chown -R $WEB_USER:$WEB_USERGROUP $WEB_PATH
echo "Finished."

# next check and rsync web dir to slave server