#!/bin/sh
echo '****************************************************************************'
echo '              compiles.sh                                                   '
echo '                      by niuren.zhu                                         '
echo '                           2017.06.01                                       '
echo '  说明：                                                                     '
echo '    1. 遍历工作目录，存在compile_packages.bat则调用。                           '
echo '    2. 参数1，工作目录。                                                       '
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
while read folder
do
  if [ -e ${WORK_FOLDER}/${folder}/compile_packages.sh ]
  then
    if [ ! -x ${WORK_FOLDER}/${folder}/compile_packages.sh ]
    then
      chmod 775 ${WORK_FOLDER}/${folder}/compile_packages.sh
    fi
    cd ${WORK_FOLDER}/${folder}
    echo ----开始编译：`pwd`
    ${WORK_FOLDER}/${folder}/compile_packages.sh
  fi
done < ${WORK_FOLDER}/compile_order.txt | sed 's/\r//g'
cd ${WORK_FOLDER}
