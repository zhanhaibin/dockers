#!/bin/sh
echo '****************************************************************************'
echo '              copy_wars.sh                                                  '
echo '                      by niuren.zhu                                         '
echo '                           2017.06.23                                       '
echo '  说明：                                                                    '
echo '    1. 遍历工作目录，寻找war包到./ibas_packages。                           '
echo '    2. 参数1，工作目录。                                                    '
echo '****************************************************************************'
# 设置参数变量
# 启动目录
STARTUP_FOLDER=`pwd`
# 工作目录默认第一个参数
WORK_FOLDER=$1
# 修正相对目录为启动目录
if [ "${WORK_FOLDER}" = "./" ]
then
  WORK_FOLDER=${STARTUP_FOLDER}
fi
# 未提供工作目录，则取启动目录
if [ "${WORK_FOLDER}" = "" ]
then
  WORK_FOLDER=${STARTUP_FOLDER}
fi
PACKAGES_FOLDER=${STARTUP_FOLDER}/ibas_packages
if [ ! -e ${PACKAGES_FOLDER} ]
then
  mkdir ${PACKAGES_FOLDER}
fi
echo --工作的目录：${WORK_FOLDER}
echo --程序的目录：${PACKAGES_FOLDER}
# 获取编译顺序
if [ ! -e ${WORK_FOLDER}/compile_order.txt ]
then
  ls -l ${WORK_FOLDER} | awk '/^d/{print $NF}' > ${WORK_FOLDER}/compile_order.txt
fi
# 遍历当前目录存
while read folder
do
  find ${WORK_FOLDER}/${folder}/release/ -name "*.war" -type f -exec cp {} ${PACKAGES_FOLDER} \;
done < ${WORK_FOLDER}/compile_order.txt | sed 's/\r//g'
echo --程序清单：
ls ${PACKAGES_FOLDER}