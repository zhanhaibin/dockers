#!/bin/bash
echo '*************************************************************************************'
echo '             deploy_documents.sh                                                          '
echo '                      by zhanhaibin                                                  '
echo '                           2017.12.14                                                '
echo '  说明：                                                                             '
echo '    1. 部署IBAS的WAR包到应用目录，需要以管理员权限启动。                             '
echo '    2. 参数1，IBAS数据目录，默认.\ibas。                                             '
echo '    3. 参数2，IBAS文件共享位置，默认.\ibas\data\documents_files。                     '
echo '    4. 参数3，IBAS部署目录，默认.\webapps。                                          '
echo '*************************************************************************************'

# 工作目录
WORK_FOLDER=$PWD
# 设置ibas目录
IBAS_HOME=$1
if [ "${IBAS_HOME}" == "" ];then IBAS_HOME=${WORK_FOLDER}/ibas; fi;
if [ ! -e "${IBAS_HOME}" ];then mkdir -p "${IBAS_HOME}"; fi;
# ibas文件共享目录：
IBAS_DOCUMENT=$2
if [ "${IBAS_DOCUMENT}" == "" ];then IBAS_DOCUMENT=${IBAS_HOME}/data/documents_files; fi;
if [ ! -e "${IBAS_DOCUMENT}" ];then mkdir -p "${IBAS_DOCUMENT}"; fi;
# 设置IBAS_DEPLOY目录
IBAS_DEPLOY=$3
if [ "${IBAS_DEPLOY}" == "" ];then IBAS_DEPLOY=${WORK_FOLDER}/webapps; fi;
if [ ! -e "${IBAS_DEPLOY}" ];then mkdir -p "${IBAS_DEPLOY}"; fi;
# 显示参数信息
echo ----------------------------------------------------
echo 文件共享目录：${IBAS_DOCUMENT}
echo ----------------------------------------------------

if [ -e "${IBAS_DEPLOY}/documents/resources/files" ]; then rm -rf "${IBAS_DEPLOY}/documents/resources/files"; fi;
        ln -s "${IBAS_DOCUMENT}" "${IBAS_DEPLOY}/documents/resources/files"

echo 操作完成
