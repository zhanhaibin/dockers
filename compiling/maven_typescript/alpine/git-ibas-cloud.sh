#!/bin/sh
echo '****************************************************************************'
echo '              git_ibas_cloud.sh                                                   '
echo '                      by zhanhaibin                                         '
echo '                           2017.09.28                                       '
echo '  说明：                                                                    '
echo '    1. 通过git tf，从TFS下载ibas_cloud代码                                  '
echo '    1. 遍历compile_cloud_order.txt文件。                                    '
echo '    2. 参数1，工作目录。                                                    '
echo '****************************************************************************'
# 设置参数变量
# 启动目录
STARTUP_FOLDER=`pwd`
# 工作目录默认第一个参数
WORK_FOLDER=$1
# 修正相对目录为启动
if [ "${WORK_FOLDER}" == "./" ]
then
  WORK_FOLDER=${STARTUP_FOLDER}
fi
# 未提供工作目录，则取启动目录
if [ "${WORK_FOLDER}" == "" ]
then
  WORK_FOLDER=${STARTUP_FOLDER}
fi

echo --工作的目录：${WORK_FOLDER}

#设置GIT-TF环境变量
export PATH="$PATH:/srv/ibas/git-tf-2.0.3.20131219/"
#配置Git-tf的默认用户名、密码
git config --global git-tf.server.username avatech\\ibas_publisher
git config --global git-tf.server.password 1q2w\#E\$R

# 获取编译顺序
if [ ! -e ${WORK_FOLDER}/compile_cloud_order.txt ]
then
  ls -l ${WORK_FOLDER} | awk '/^d/{print $NF}' > ${WORK_FOLDER}/compile_cloud_order.txt
fi
# 遍历当前目录存
while read file
do
	echo 'Git TF pull： '$file}
	rm -r "${file}"
        git tf clone http://192.168.3.32:8080/tfs/ibas_cloud $/"${file}" "${IBAS}${file}"; 
        echo '****************************************************************************'
done < ${WORK_FOLDER}/compile_cloud_order.txt 
cd ${WORK_FOLDER}
