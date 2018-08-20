#!/bin/bash
echo '****************************************************************************'
echo '    docker_compile.sh                                                     '
echo '                      by niuren.zhu                                         '
echo '                           2016.12.14                                       '
echo '  说明：                                                                    '
echo '    1. 运行容器                                         '
echo '                                    '
echo '****************************************************************************'
# 定义变量
RegistoryUrl=docker.avacloud.com.cn
NAME=$1
TAG=$2
ACCOUNT=$3

# 启动容器
echo 容器启动： ${ACCOUNT}-SERVICE
docker run -it --name=${ACCOUNT}-SERVICE -m 768m --memory-swap 0  -e JAVA_OPTS='-Xmx768m'  -v /srv/ibas/customers/${ACCOUNT}/ibas/:/usr/local/tomcat/ibas/ -d ${RegistoryUrl}/${NAME}:${TAG}

echo ------------------------------------------------------------------
# 拷贝文件
docker cp deploy_documents.sh ${ACCOUNT}-SERVICE:/usr/local/tomcat/
# 执行创建数据库脚本
echo 开始创建数据库、数据：${ACCOUNT}
docker exec -it ${ACCOUNT}-SERVICE ./initialize_apps.sh
echo 初始化数据库、数据
echo ------------------------------------------------------------------
echo 执行创建文件文件软链接
docker exec -it ${ACCOUNT}-SERVICE ./deploy_documents.sh
echo 共享文件软链接完成
echo ------------------------------------------------------------------
# 重启容器
docker restart ${ACCOUNT}-SERVICE
echo 容器启动完成
