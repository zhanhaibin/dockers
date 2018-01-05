#!/bin/bash
echo '****************************************************************************'
echo '              download_wars.sh                                              '
echo '                      by zhanhaibin                                         '
echo '                           2017.10.10                                       '
echo '  说明：                                                                    '
echo '    1. 遍历ibas_deploy_order.txt文件。                                          '
echo '    2. 参数1，工作目录。                                                    '
echo '****************************************************************************'
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

#war包下载地址
IBAS_PACKAGE=$2
if [ "${IBAS_PACKAGE}" == "" ];then IBAS_PACKAGE=${WORK_FOLDER}/ibas_packages; fi;
if [ ! -e "${IBAS_PACKAGE}" ];then mkdir -p "${IBAS_PACKAGE}"; fi;
cd ${IBAS_PACKAGE} 
rm ibas.*.war
rm ibas.deploy.order.txt

cd ${WORK_FOLDER}
#nexus3 地址
server=http://maven.avacloud.com.cn/repository
repo=maven-releases



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
	wget -q -N -P ${IBAS_PACKAGE} $url
 
	#echo Done
done < ${WORK_FOLDER}/compile_order.txt
chmod -R 777 ${IBAS_PACKAGE} 

echo --下载war包完成

