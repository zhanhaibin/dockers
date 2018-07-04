#!/bin/sh
echo '****************************************************************************'
echo '              docker_compile.sh                                             '
echo '                      by niuren.zhu                                         '
echo '                           2017.11.22                                       '
echo '  说明：                                                                    '
echo '    1. 启动容器，获取并编译代码。                                           '
echo '    2. 参数1，使用的镜像，默认colorcoding/compiling:ibas-alpine。           '
echo '****************************************************************************'
# 设置参数变量
# 工作目录
WORK_FOLDER=`pwd`
# 容器镜像
DOCKER_IMAGE=$1
# 设置默认镜像
if [ "${DOCKER_IMAGE}" = "" ]
then
  DOCKER_IMAGE=colorcoding/compiling:ibas-gtf-alpine
fi

echo --工作目录：${WORK_FOLDER}
echo --使用镜像：${DOCKER_IMAGE}
# 启动容器
DOCKER_ID=`sudo docker run -m 512m --memory-swap 0 -v  /etc/localtime:/etc/localtime -id ${DOCKER_IMAGE}`
echo --启动容器：${DOCKER_ID}

CODE_HOME=/home/code
echo --复制脚本：...:${CODE_HOME}
# 复制脚本及其他
sudo docker cp ${WORK_FOLDER}/compile_order.txt ${DOCKER_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/builds.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/compiles.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/deploy_wars.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/copy_wars.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/git-btulz.transforms.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/git-ibas-framework.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/git-ibas.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/git-ibas-cloud.sh ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/compile_cloud_order.txt ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/settings.xml ${sudo docker_ID}:${CODE_HOME} 
sudo docker cp /srv/ibas/maven/repository ${sudo docker_ID}:${CODE_HOME}
sudo docker cp ${WORK_FOLDER}/copy_mavens.sh ${sudo docker_ID}:${CODE_HOME}
echo --开始运行脚本
# 下载代码

#sudo docker exec -it ${DOCKER_ID} ${CODE_HOME}/git-ibas.sh && ${CODE_HOME}/git-ibas-cloud.sh && ${CODE_HOME}/builds.sh  && ${CODE_HOME}/compiles.sh && ${CODE_HOME}/copy_wars.sh && ${CODE_HOME}/deploy_wars.sh

# 拷贝maven依赖的jar包
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/copy_mavens.sh
# 下载代码
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/git-ibas.sh
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/git-ibas-cloud.sh
 # 编译代码
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/builds.sh
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/compiles.sh
 # 整理包
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/copy_wars.sh 
 # 发布包
sudo docker cp ${CODE_HOME}/settings.xml ${DOCKER_ID}:${MAVEN_HOME}/conf/
sudo docker exec -i ${DOCKER_ID} ${CODE_HOME}/deploy_wars.sh
# 清理资源
echo --停止容器：
sudo docker stop ${DOCKER_ID}
echo --删除容器：
sudo docker rm -fv ${DOCKER_ID} 
echo --操作完成