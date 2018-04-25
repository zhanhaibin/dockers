#!/bin/sh
echo '****************************************************************************'
echo '              builds.sh                                                     '
echo '                      by niuren.zhu                                         '
echo '                           2017.06.01                                       '
echo '  说明：                                                                    '
echo '    1. 遍历工作目录，存在build_all.bat则调用。                              '
echo '    2. 使用uglifyjs压缩*.js文件为*.min.js。                                 '
echo '    3. 参数1，工作目录。                                                    '
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

echo --工作的目录：${WORK_FOLDER}
echo --检查工具
COMPRESS=false
uglifyjs -V
if [ "$?" = "0" ]
then
  COMPRESS=true
else
  echo 请先安装压缩工具[npm install uglify-es -g]
fi

# 获取编译顺序
if [ ! -e ${WORK_FOLDER}/compile_order.txt ]
then
  ls -l ${WORK_FOLDER} | awk '/^d/{print $NF}' > ${WORK_FOLDER}/compile_order.txt
fi
# 遍历当前目录
while read folder
do
  for builder in `find ${WORK_FOLDER}/${folder} -type f -name build_all.sh`
  do
# 运行编译命令
    if [ ! -x "${builder}" ]
    then
      chmod 775 ${builder}
    fi
    echo --开始调用：${builder}
    "${builder}"
  done
# 尝试压缩js文件
  if [ "${COMPRESS}" = "true" ]
  then
# 遍历当前目录
    for file in `find ${WORK_FOLDER}/${folder} -type f -name *.js ! -name *.min.js ! -path "*3rdparty*" ! -path "*openui5/resources*" ! -path "*target*"`
    do
      compressed=${file%%.js*}.min.js
      echo --开始压缩：${file}
      uglifyjs --compress --keep-classnames --keep-fnames --mangle --output ${compressed} ${file}
    done
  fi
  echo '****************************************************************************'
done < ${WORK_FOLDER}/compile_order.txt | sed 's/\r//g'
cd ${WORK_FOLDER}

