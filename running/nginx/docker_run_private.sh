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
RegistoryUrl=docker.avacloud.com.cn
NAME=$1
TAG=$2
ACCOUNT=$3


# 启动容器
echo 容器启动： ${ACCOUNT}-WEB

# 启动容器
docker run -it --name=${ACCOUNT}-WEB -m 64m --memory-swap 0 -v /etc/localtime:/etc/localtime -v /mnt/customers/${ACCOUNT}/ibas/data/documents_files:/usr/share/nginx/webapps/documents/resources/files/  -p ${PORT}:80 --link=${ACCOUNT}-SERVICE:${ACCOUNT}-SERVICE -d ${RegistoryUrl}/${NAME}:${TAG}


# 拷贝配置文件到容器
echo 拷贝配置文件到容器
docker cp /srv/ibas/nginx/${ACCOUNT}.nginx.conf ${ACCOUNT}-WEB:/etc/nginx/nginx.conf
#docker cp /srv/ibas/resources/ ${TAG}-WEB:/usr/share/nginx/webapps/root/openui5/
echo ------------------------------------------------------------------

# 重启容器nginx服务
#docker exec -it ${TAG}-WEB service nginx reload
#docker exec -it ${ACCOUNT}-WEB /usr/sbin/nginx -s reload
# 重启容器
docker restart ${ACCOUNT}-WEB
echo 容器启动完成
