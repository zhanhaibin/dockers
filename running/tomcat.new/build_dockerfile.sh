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
TAG=$1
if [ "${TAG}" == "" ]; then TAG=$(date +%s); fi;
NAME_TAG=${NAME}:${TAG}

echo 开始下载war包

./download_wars.sh

echo 开始构建镜像${NAME_TAG}
# 调用docker build
docker build --force-rm --no-cache -f ./dockerfile -t ${NAME_TAG} ./

if [ "$?" == "0" ]; then
  echo 镜像${NAME_TAG}构建完成
else
  echo 镜像构建失败
fi;


echo ------------------------------------------------------------------
# 清理app.xml配置文件，根据参数复制新文件
echo 清理app.xml配置文件，根据参数复制新文件
if [ -e "/srv/ibas/tomcat/conf/${TAG}.app.xml" ] ; then 
  sudo rm -rf /srv/ibas/tomcat/conf/${TAG}.app.xml
fi;
cp /srv/ibas/tomcat/conf/app.xml /srv/ibas/tomcat/conf/${TAG}.app.xml

# 替换数据库名称
sed -i "s/DatabaseName/$TAG/g" /srv/ibas/tomcat/conf/${TAG}.app.xml
echo 查看app.xml配置文件
cat /srv/ibas/tomcat/conf/${TAG}.app.xml
# 启动容器
echo 容器启动： ${TAG}-SERVICE
docker run -it --name=${TAG}-SERVICE -m 512m --memory-swap 0 -v /etc/localtime:/etc/localtime -d ${NAME_TAG}
echo ------------------------------------------------------------------
# 拷贝配置文件到容器
echo 拷贝配置文件到容器
docker cp /srv/ibas/tomcat/conf/${TAG}.app.xml ${TAG}-SERVICE:/usr/local/tomcat/ibas/conf/app.xml
docker cp /srv/ibas/tomcat/conf/config.json ${TAG}-SERVICE:/usr/local/tomcat/ibas/conf/config.json
docker cp /srv/ibas/tomcat/conf/service_routing.xml ${TAG}-SERVICE:/usr/local/tomcat/ibas/conf/service_routing.xml
echo ------------------------------------------------------------------
# 拷贝文件
docker cp deploy_documents.sh ${TAG}-SERVICE:/usr/local/tomcat/
# 执行创建数据库脚本
echo 开始创建数据库：${TAG}
docker exec -it ${TAG}-SERVICE ./initialize_datastructures.sh
echo 数据库创建完成
echo ------------------------------------------------------------------
echo 开始初始化数据：${TAG}
docker exec -it ${TAG}-SERVICE ./initialize_datas.sh
echo 初始化数据完成
echo ------------------------------------------------------------------
echo 执行创建文件文件软链接
docker exec -it ${TAG}-SERVICE ./deploy_documents.sh 
echo 共享文件软链接完成
echo ------------------------------------------------------------------
# 重启容器
docker restart ${TAG}-SERVICE 
echo 容器启动完成


