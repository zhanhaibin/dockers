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
NAME=colorcoding/nginx
RegistoryUrl=docker.avacloud.com.cn
TAG=$1
echo ----下载镜像--------------------------------------------------------------
echo 登录私有镜像仓库
docker login -u admin -p AVAtech2018 ${RegistoryUrl}
echo 私有仓库下载镜像
docker pull ${RegistoryUrl}/${NAME}:${TAG}
echo 登出私有镜像仓库
docker logout  ${RegistoryUrl}

echo ------------------------------------------------------------------
# nginx.xml配置文件，根据参数复制新文件
echo 清理nginx.xml配置文件，根据参数复制新文件
if [ -e "/srv/ibas/nginx/${TAG}.nginx.conf" ] ; then 
  sudo rm -rf /srv/ibas/nginx/${TAG}.nginx.conf
fi;
cp /srv/ibas/nginx/ibas.nginx.conf /srv/ibas/nginx/${TAG}.nginx.conf 

# 替换数据库名称
sed -i "s/SERVERNAME/$TAG-SERVICE/g" /srv/ibas/nginx/${TAG}.nginx.conf
echo 查看nginx.conf配置文件
cat /srv/ibas/nginx/${TAG}.nginx.conf
echo ------------------------------------------------------------------
# 启动容器
echo 容器启动： ${TAG}-WEB 
# 从ibasCustomers.xml中，读取客户的端口号
PORT=$(cat /srv/ibas/nginx/ibasCustomers.xml|grep "<"${TAG}">"|cut -d">" -f2|cut -d "<" -f1)
# 启动容器
docker run -it --name=${TAG}-WEB -m 64m --memory-swap 0 -v /etc/localtime:/etc/localtime -v/srv/ibas/Customers/${TAG}/data/documents_files:/usr/share/nginx/webapps/documents/resources/files/  -p ${PORT}:80 --link=${TAG}-SERVICE:${TAG}-SERVICE -d ${RegistoryUrl}/${NAME}:${TAG}


# 拷贝配置文件到容器
echo 拷贝配置文件到容器
docker cp /srv/ibas/nginx/${TAG}.nginx.conf ${TAG}-WEB:/etc/nginx/nginx.conf
#docker cp /srv/ibas/resources/ ${TAG}-WEB:/usr/share/nginx/webapps/root/openui5/
echo ------------------------------------------------------------------

# 重启容器nginx服务
#docker exec -it ${TAG}-WEB service nginx reload
# 重启容器
docker restart ${TAG}-WEB 
echo 容器启动完成