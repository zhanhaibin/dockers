#!/bin/sh
echo '****************************************************************************'
echo '              git-ibas.sh                                                   '
echo '                      by zhanhaibin                                         '
echo '                           2017.09.28                                       '
echo '  说明：                                                                    '
echo '    1. 通过git，下载ibas代码                                                '
echo '    1. 遍历compile_order.txt文件。                                          '
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

echo --工作的目录：${WORK_FOLDER}
# 获取编译顺序
if [ ! -e ${WORK_FOLDER}/compile_order.txt ]
then
  ls -l ${WORK_FOLDER} | awk '/^d/{print $NF}' > ${WORK_FOLDER}/compile_order.txt
fi
# 遍历当前目录存
# 加速github.com访问
echo "151.101.229.194    github.global.ssl.fastly.net" >>/etc/hosts
echo "192.30.253.112    github.com" >>/etc/hosts
while read file
do
	echo 'Git pull：'${file}
	git clone --depth 1 https://github.com/color-coding/"${file}".git "${IBAS}${file}"; 
        echo '****************************************************************************'
done < ${WORK_FOLDER}/compile_order.txt 
cd ${WORK_FOLDER}
