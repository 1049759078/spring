#!/bin/bash -x

if [ $# -lt 1 ] ; then
    echo -e "\e[1;33m!!!USEAGE: build.sh [MOD]\e[0m"
    exit 1
fi

REMOTE="root@192.168.103.103:/opt/www/tools/packages"
TAG=`date "+%Y%m%d%H%M"`

MODULE=$1

WORKSPACE=$(dirname $(readlink -f $0))

FRONT=`cat ${WORKSPACE}/${MODULE}/src/main/docker/Dockerfile |grep zeta.tesir.top | awk -F ' ' '{print $3}'`
echo "I guess $FRONT"

pushd ./$MODULE

if [ -z $FRONT ];then
  echo -e "\e[1;33mNot web module,skip front copy.\e[0m"
else
  echo -e "\e[1;33mBegin copy ${MODULE} front public to resource dir\e[0m"

  rm -rf ./src/main/resources/front
  mkdir -p ./src/main/resources/front
  pushd ./src/main/resources/front
  curl -s ${FRONT} |tar xz
  popd
fi


cd $WORKSPACE/$MODULE

echo -e "\e[1;33mSTEP1: Build ${MODULE} deliver package.\e[0m"
mvn clean package -Dmaven.test.skip=true -U
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m## Build failed!\e[0m"
  exit 1
else
  echo -e "\e[1;32mDown\e[0m"
fi


echo -e "\e[1;33mSTEP2: Begin copy ${MODULE} target to download repo...\e[0m"
scp $WORKSPACE/${MODULE}/target/*.war ${REMOTE}/cmait-eu-dev/${MODULE}-${TAG}.war

if [ $? -ne 0 ]; then
  echo -e "\e[1;31m## Something wrong when copy target, please check!\e[0m"
  exit 1
else
  echo -e "\e[1;32mDown\e[0m"
fi

