#!/bin/bash
echo '****************************************************************************'
echo '    build_dockerfile.sh                                                     '
echo '                      by niuren.zhu                                         '
echo '                           2016.12.14                                       '
echo '  说明：                                                                    '
echo '    1. 调用dockerfile4all创建镜像。                                         '
echo '    2. 参数1，构建的镜像标签，默认为时间戳。                                '
echo '****************************************************************************'
# 定义变量
NAME=colorcoding/tomcat
RegistoryUrl=docker.avacloud.com.cn
TAG=$1
if [ "${TAG}" == "" ]; then TAG=$(date +%s); fi;
NAME_TAG=${NAME}:${TAG}

echo 开始下载war包

./download_wars.sh

echo 开始构建镜像${NAME_TAG}
# 调用docker build
docker build --force-rm --no-cache -f ./dockerfile -t ${RegistoryUrl}/${NAME_TAG} ./

if [ "$?" == "0" ]; then
  echo 镜像${NAME_TAG}构建完成
else
  echo 镜像构建失败
fi;

echo 登录私有镜像仓库
docker login -u admin -p AVAtech2018 ${RegistoryUrl}
echo 上传镜像至私有仓库
docker push ${RegistoryUrl}/${NAME_TAG}
echo 删除本地镜像
docker rmi ${RegistoryUrl}/${NAME_TAG}
echo 容器镜像上传完成
docker logout ${RegistoryUrl}

echo 启动容器
./docker_run.sh ${TAG}

