#!/bin/sh
echo '****************************************************************************'
echo '              deploy_wars.sh                                                '
echo '                      by niuren.zhu                                         '
echo '                           2017.09.19                                       '
echo '  说明：                                                                    '
echo '    1. 遍历工作目录，部署war包到MAVEN服务。                                 '
echo '    2. 参数1，发布VERSION的版本。                                           '
echo '    3. 参数2，发布MAVEN的地址。                                             '
echo '    4. 在MAVEN的setting.xml<servers>节点下添加                              '
echo '          <server>                                                          '
echo '              <id>ibas-maven</id>                                           '
echo '              <username>用户名</username>                                   '
echo '              <password>密码</password>                                     '
echo '          </server>                                                         '
echo '****************************************************************************'

# 工作目录
WORK_FOLDER=`pwd`
# 版本信息
VERSION=date "+%Y%m%d%H%M"
# 仓库地址
REPOSITORY_URL=$2
if [ "${REPOSITORY_URL}" == "" ];then REPOSITORY_URL=http://10.0.8.50:8081/repository/maven-releases; fi;
# MAVEN参数信息
REPOSITORY_ID=ibas-maven
GROUP_ID=org.colorcoding.apps
# 定义war文件名称
file=$3
echo --检查maven运行环境
mvn -v >/dev/null
if [ $? -ne 0 ]; then
  echo 请检查MAVEN是否正常
  exit 1;
fi

echo --工作目录：${WORK_FOLDER}
echo --发布地址：${REPOSITORY_URL}
while read line
do
  if [ -e ${WORK_FOLDER}/${line}/release ]
  then
    cd ${WORK_FOLDER}/${line}/release
    if [ "${line}" == "ibas-typescript"  ]
    then
        file=ibas.root 
        for PACKAGE in `find ./ -name "${file}*.war"` 
		do
		  # 获取包标识
		  ARTIFACT_ID=${PACKAGE##*/}
		  ARTIFACT_ID=${ARTIFACT_ID%%-*}
		  if [ "${VERSION}" == "" ]
		  then
			  # 未提供版本号，则使用POM文件
			  mvn deploy:deploy-file \
				-Dfile=${PACKAGE} \
				-DpomFile=${WORK_FOLDER}/${line}/pom.xml \
				-Durl=${REPOSITORY_URL} \
				-DrepositoryId=${REPOSITORY_ID} \
				-Dpackaging=war
		  else
			  # 提供版本号，独立上传
			  mvn deploy:deploy-file \
				-DgroupId=${GROUP_ID} \
				-DartifactId=${ARTIFACT_ID} \
				-Dversion=${VERSION} \
				-Dfile=${PACKAGE} \
				-Durl=${REPOSITORY_URL} \
				-DrepositoryId=${REPOSITORY_ID} \
				-Dpackaging=war
		  fi;
		done
    else
        file=${line}
		for PACKAGE in `find ./ -name "${file}*.war"` 
		do
		  # 获取包标识
		  ARTIFACT_ID=${PACKAGE##*/}
		  ARTIFACT_ID=${ARTIFACT_ID%%-*}
		  if [ "${VERSION}" == "" ]
		  then
			  # 未提供版本号，则使用POM文件
			  mvn deploy:deploy-file \
				-Dfile=${PACKAGE} \
				-DpomFile=${WORK_FOLDER}/${file}/${ARTIFACT_ID}/pom.xml \
				-Durl=${REPOSITORY_URL} \
				-DrepositoryId=${REPOSITORY_ID} \
				-Dpackaging=war
		  else
			  # 提供版本号，独立上传
			  mvn deploy:deploy-file \
				-DgroupId=${GROUP_ID} \
				-DartifactId=${ARTIFACT_ID} \
				-Dversion=${VERSION} \
				-Dfile=${PACKAGE} \
				-Durl=${REPOSITORY_URL} \
				-DrepositoryId=${REPOSITORY_ID} \
				-Dpackaging=war
		  fi;
		done
    fi  
  fi
done < ${WORK_FOLDER}/compile_order.txt | sed 's/\r//g'
cd ${WORK_FOLDER}/
echo --操作完成
