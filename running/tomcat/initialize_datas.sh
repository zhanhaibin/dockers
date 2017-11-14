#!/bin/bash
echo '****************************************************************************'
echo '     initialize_datas.sh                                                    '
echo '            by niuren.zhu                                                   '
echo '               2017.03.22                                                   '
echo '  说明：                                                                     '
echo '    1. 分析jar包并初始化数据，数据库信息取值app.xml。                             '
echo '    2. 参数1，待分析的目录，默认.\webapps。                                     '
echo '    3. 参数2，共享库目录，默认.\ibas_lib。                                      '
echo '    4. 提前下载btulz.transforms并放置.\ibas_tools\目录。                       '
echo '    5. 提前配置app.xml的数据库信息。                                            '
echo '****************************************************************************'
# 设置参数变量
WORK_FOLDER=$PWD
# 设置ibas_tools目录
TOOLS_FOLDER=${WORK_FOLDER}/ibas_tools
TOOLS_TRANSFORM=${TOOLS_FOLDER}/btulz.transforms.bobas-0.1.0.jar
if [ ! -e "${TOOLS_TRANSFORM}" ];then
  echo not found btulz.transforms, in [${TOOLS_FOLDER}].
  exit 1
fi;
# 设置DEPLOY目录
IBAS_DEPLOY=$1
if [ "${IBAS_DEPLOY}" == "" ];then IBAS_DEPLOY=${WORK_FOLDER}/webapps; fi;
if [ ! -e "${IBAS_DEPLOY}" ];then
  echo not found webapps.
  exit 1;
fi;
# 设置LIB目录
IBAS_LIB=$2
if [ "${IBAS_LIB}" == "" ];then IBAS_LIB=${WORK_FOLDER}/ibas_lib; fi;

# 显示参数信息
echo ----------------------------------------------------
echo 工具地址：${TOOLS_TRANSFORM}
echo 部署目录：${IBAS_DEPLOY}
echo 共享目录：${IBAS_LIB}
echo ----------------------------------------------------

# 初始化数据
function initDatas()  
{
# 参数1，使用的jar包
  JarFile=$1;
# 参数2，配置文件
  Config=$2;
# 参数3，加载的类库
  Classes=$3;
# 生成命令
  COMMOND="java \
    -jar ${TOOLS_TRANSFORM} init \
    ""-data=${JarFile}"" \
    ""-config=${Config}"" \
    ""-classes=${Classes}""";
  echo exec: ${COMMOND};
  eval $(echo ${COMMOND});
}

echo 开始分析${IBAS_DEPLOY}目录下数据
# 检查是否存在模块说明文件，此文件描述模块初始化顺序。
if [ ! -e "${IBAS_DEPLOY}/ibas.release.txt" ]
then
  ls -l "${IBAS_DEPLOY}" | awk '/^d/{print $NF}' > "${IBAS_DEPLOY}/ibas.release.txt"
fi
while read folder
do
  echo --${folder}
# 判断配置文件是否存在
    FILE_APP=${IBAS_DEPLOY}/${folder}/WEB-INF/app.xml
    if [ -e "${FILE_APP}" ]; then
# 使用模块目录jar包
      if [ -e "${IBAS_DEPLOY}/${folder}/WEB-INF/lib" ]
      then
        FILE_CLASSES=
        for file in `ls "${IBAS_DEPLOY}/${folder}/WEB-INF/lib" | grep \..jar`
        do
          FILE_CLASSES=${FILE_CLASSES}${IBAS_DEPLOY}/${folder}/WEB-INF/lib/${file}\\\;;
        done
        for file in `ls "${IBAS_DEPLOY}/${folder}/WEB-INF/lib" | grep ibas\.${folder}\-.`
        do
          echo ----${file}
          FILE_DATA=${IBAS_DEPLOY}/${folder}/WEB-INF/lib/${file}
          initDatas "${FILE_DATA}" "${FILE_APP}" "${FILE_CLASSES}"
          echo ----
        done
      fi;
# 使用共享目录jar包
      if [ -e "${IBAS_LIB}" ]
      then
        FILE_CLASSES=
        for file in `ls "${IBAS_LIB}" | grep \..jar`
        do
          FILE_CLASSES=${FILE_CLASSES}${IBAS_LIB}/${file}\\\;;
        done
        for file in `ls "${IBAS_LIB}" | grep ibas\.${folder}\-.`
        do
          echo ----${file}
          FILE_DATA=${IBAS_LIB}/${file};
          initDatas "${FILE_DATA}" "${FILE_APP}" "${FILE_CLASSES}"
          echo ----
        done
      fi;
    fi;
    echo --
  done < "${IBAS_DEPLOY}/ibas.release.txt" | sed 's/\r//g' | sed 's/\n//g'
echo 操作完成
