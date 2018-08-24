#!/bin/sh

# 设置参数变量
# 启动目录
STARTUP_FOLDER=`pwd`
# 工作目录默认第一个参数
WORK_FOLDER=$1
# 修正相对目录为启动目录
if [ "${WORK_FOLDER}" == "./" ]
then
  WORK_FOLDER=${STARTUP_FOLDER}
fi
# 未提供工作目录，则取启动目录
if [ "${WORK_FOLDER}" == "" ]
then
  WORK_FOLDER=${STARTUP_FOLDER}
fi

cd ${WORK_FOLDER}
#nexus3 地址
server=http://nexus.avacloud.com.cn/repository
repo=maven-releases

if [ "${IBAS_PACKAGE}" == "" ];then IBAS_PACKAGE=${WORK_FOLDER}/ibas_packages; fi;
if [ ! -e "${IBAS_PACKAGE}" ];then mkdir -p "${IBAS_PACKAGE}"; fi;

echo --工作的目录：${WORK_FOLDER}
# 下载war包
# 遍历complie_order.txt
while read file
do
        echo 'download wars：'${file}
        # Maven artifact location
        name=${file}.service
        artifact=org/colorcoding/apps/$name
        path=$server/$repo/$artifact

        version=`curl -s "$path/maven-metadata.xml" | grep release | sed "s/.*<release>\([^<]*\)<\/release>.*/\1/"`

        war=$name-$version.war
        echo $war >> "${IBAS_PACKAGE}/ibas.deploy.order.txt"
        url=$path/$version/$war

        # Download
        echo 'SURL:' $url
        wget -q -P ${IBAS_PACKAGE} $url

        #echo Done
        echo unzip ibas war package
        unzip ${IBAS_PACKAGE}/$war -d ${file}
        echo find jar package
        find / -name ${file}-*.jar | xargs -i cp {} ./
        echo mvn install jar
        mvn install:install-file -Dfile=${file}-0.1.0.jar -DgroupId=org.colorcoding.apps -DartifactId=${file} -Dversion=0.1.0 -Dpackaging=jar

done < ${WORK_FOLDER}/compile_dependent_order.txt

echo --安装依赖项目完成
