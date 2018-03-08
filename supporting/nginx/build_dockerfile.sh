#!/bin/bash
echo '****************************************************************************'
echo '    build_dockerfile.sh                                                     '
echo '                      by zhanhaibin                                         '
echo '                           2018.02.06                                       '
echo '  说明：                                                                    '
echo '    1. 调用dockerfile创建镜像。                                         '
echo '    2. 参数1，构建的镜像标签，默认为时间戳。                                '
echo '****************************************************************************'
# 定义变量
NAME=colorcoding/nginx
TAG=$1
if [ "${TAG}" == "" ]; then TAG=ibas-alpine; fi;
NAME_TAG=${NAME}:${TAG}

echo 开始构建镜像${NAME_TAG}
# 调用docker build
docker build --force-rm --no-cache -f ./dockerfile -t ${NAME_TAG} ./

if [ "$?" == "0" ]; then
  echo 镜像${NAME_TAG}构建完成
else
  echo 镜像构建失败
fi;