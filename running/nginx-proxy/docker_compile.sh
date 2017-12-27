#!/bin/sh
echo '****************************************************************************'
echo '              docker_compile.sh                                             '
echo '                      by zhanhaibin                                         '
echo '                           2017.12.27                                       '
echo '  说明：                                                                    '
echo '    1. 启动容器，获取拷贝文件。                                               '
echo '    2. 参数1，使用的镜像，默认colorcoding/nginx:latest。                      '
echo '****************************************************************************'
# 设置参数变量
# 工作目录
WORK_FOLDER=`pwd`
# 容器镜像
DOCKER_IMAGE=$1
# 设置默认镜像
if [ "${DOCKER_IMAGE}" = "" ]
then
  DOCKER_IMAGE=colorcoding/nginx:latest
fi

echo --工作目录：${WORK_FOLDER}
echo --使用镜像：${DOCKER_IMAGE}
# 启动容器
DOCKER_ID=`docker run -it --name=nginx -p 443：443 -d ${DOCKER_IMAGE} `
echo --启动容器：${DOCKER_ID}

echo --拷贝文件
docker cp entrypoint.sh ${DOCKER_ID}:/usr/share/nginx/
docker exec -it ${DOCKER_ID} ./usr/share/nginx/entrypoint.sh
docker cp /srv/ibas/nginx-proxy/apps/* ${DOCKER_ID}:/usr/share/nginx/html/apps/
docker cp /srv/ibas/nginx-proxy/cert/* ${DOCKER_ID}:/etc/nginx/cert/