#!/bin/sh
echo '****************************************************************************'
echo '              git-ibas-framework.sh                                                     '
echo '                      by zhanhaibin                                         '
echo '                           2017.09.28                                       '
echo '  说明：                                                                    ' 
echo '    1. 参数1，工作目录。                                                    '
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
 
#下载btulz.transforms代码 
echo '****Git pull：btulz.transforms***********************************************'
rm -r btulz.transforms
git clone https://github.com/color-coding/ibas-framework.git ; 
echo '****************************************************************************'

cd ${WORK_FOLDER}
