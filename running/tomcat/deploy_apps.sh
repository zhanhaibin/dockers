#!/bin/bash
echo '*************************************************************************************'
echo '             deploy_apps.sh                                                          '
echo '                      by niuren.zhu                                                  '
echo '                           2017.06.18                                                '
echo '  说明：                                                                             '
echo '    1. 部署IBAS的WAR包到应用目录，需要以管理员权限启动。                             '
echo '    2. 参数1，IBAS数据目录，默认.\ibas。                                             '
echo '    3. 参数2，IBAS的包位置，默认.\ibas_packages。                                    '
echo '    4. 参数3，IBAS部署目录，默认.\webapps。                                          '
echo '    5. 参数4，IBAS共享库目录，默认.\ibas_lib。                                       '
echo '    6. 脚本通文件链接方式，集中配置文件和日志目录到IBAS_HOME下。                     '
echo '    7. 请提前安装unzip，或拷贝到.\ibas_tools目录。                                   '
echo '    8. 请调整catalina.properties的shared.loader="${catalina.home}/ibas_lib/*.jar"。  '
echo '*************************************************************************************'
# 定义变量
OPNAME=`date '+%Y%m%d_%H%M%S'`
# 工作目录
WORK_FOLDER=$PWD
# 设置ibas目录
IBAS_HOME=$1
if [ "${IBAS_HOME}" == "" ];then IBAS_HOME=${WORK_FOLDER}/ibas; fi;
if [ ! -e "${IBAS_HOME}" ];then mkdir -p "${IBAS_HOME}"; fi;
# ibas配置目录
IBAS_CONF=${IBAS_HOME}/conf
if [ ! -e "${IBAS_CONF}" ];then mkdir -p "${IBAS_CONF}"; fi;
# ibas数据目录
IBAS_DATA=${IBAS_HOME}/data
if [ ! -e "${IBAS_DATA}" ];then mkdir -p "${IBAS_DATA}"; fi;
# ibas日志目录
IBAS_LOG=${IBAS_HOME}/logs
if [ ! -e "${IBAS_LOG}" ];then mkdir -p "${IBAS_LOG}"; fi;
# 设置IBAS_PACKAGE目录
IBAS_PACKAGE=$2
if [ "${IBAS_PACKAGE}" == "" ];then IBAS_PACKAGE=${WORK_FOLDER}/ibas_packages; fi;
if [ ! -e "${IBAS_PACKAGE}" ];then mkdir -p "${IBAS_PACKAGE}"; fi;
# 设置IBAS_DEPLOY目录
IBAS_DEPLOY=$3
if [ "${IBAS_DEPLOY}" == "" ];then IBAS_DEPLOY=${WORK_FOLDER}/webapps; fi;
if [ ! -e "${IBAS_DEPLOY}" ];then mkdir -p "${IBAS_DEPLOY}"; fi;
# 设置IBAS_LIB目录
IBAS_LIB=$4
if [ "${IBAS_LIB}" == "" ];then IBAS_LIB=${WORK_FOLDER}/ibas_lib; fi;
if [ ! -e "${IBAS_LIB}" ];then mkdir -p "${IBAS_LIB}"; fi;
# 设置备份目录
IBAS_PACKAGE_BACKUP=${IBAS_PACKAGE}/backup/${OPNAME}/
if [ ! -e "${IBAS_PACKAGE_BACKUP}" ];then mkdir -p "${IBAS_PACKAGE_BACKUP}"; fi;

# 显示参数信息
echo ----------------------------------------------------
echo 应用包目录：${IBAS_PACKAGE}
echo 部署目录：${IBAS_DEPLOY}
echo 共享目录：${IBAS_LIB}
echo 数据目录：${IBAS_HOME}
echo ----------------------------------------------------
# 部署顺序排序
if [ ! -e "${IBAS_PACKAGE}/ibas.deploy.order.txt" ]; then
    cd ${IBAS_PACKAGE}
    ls -l *.war | awk '//{print $NF}' >>"${IBAS_PACKAGE}/ibas.deploy.order.txt";
    cd ${WORK_FOLDER}
fi;
echo 开始解压模块，到目录${IBAS_DEPLOY}
while read file
    do
        file=${file%%.war*}.war
        echo 释放"${IBAS_PACKAGE}/${file}"
# 修正war包的解压目录
        folder=${file##*ibas.}
        folder=${folder%%.service*}
# 记录释放的目录到ibas.release.txt，此文件为部署顺序说明。
        if [ ! -e "${IBAS_DEPLOY}/ibas.release.txt" ]; then :>"${IBAS_DEPLOY}/ibas.release.txt"; fi;
        grep -q ${folder} "${IBAS_DEPLOY}/ibas.release.txt" || echo "${folder}" >>"${IBAS_DEPLOY}/ibas.release.txt"
# 解压war包到目录
        unzip -o "${IBAS_PACKAGE}/${file}" -d "${IBAS_DEPLOY}/${folder}"
# 删除配置文件，并映射到统一位置
        if [ -e "${IBAS_DEPLOY}/${folder}/WEB-INF/app.xml" ]; then
            if [ ! -e "${IBAS_CONF}/app.xml" ]; then cp -f "${IBAS_DEPLOY}/${folder}/WEB-INF/app.xml" "${IBAS_CONF}/app.xml"; fi;
            rm -f "${IBAS_DEPLOY}/${folder}/WEB-INF/app.xml"
            ln -s "${IBAS_CONF}/app.xml" "${IBAS_DEPLOY}/${folder}/WEB-INF/app.xml"
        fi;
# 删除服务路由文件，并映射到统一位置
        if [ -e "${IBAS_DEPLOY}/${folder}/WEB-INF/service_routing.xml" ]; then
            if [ ! -e "${IBAS_CONF}/service_routing.xml" ]; then cp -f "${IBAS_DEPLOY}/${folder}/WEB-INF/service_routing.xml" "${IBAS_CONF}/service_routing.xml"; fi;
            rm -f "${IBAS_DEPLOY}/${folder}/WEB-INF/service_routing.xml"
            ln -s "${IBAS_CONF}/service_routing.xml" "${IBAS_DEPLOY}/${folder}/WEB-INF/service_routing.xml"
        fi
# 删除前端配置文件，并映射到统一位置
        if [ -e "${IBAS_DEPLOY}/${folder}/config.json" ]; then
            if [ ! -e "${IBAS_CONF}/config.json" ]; then cp -f "${IBAS_DEPLOY}/${folder}/config.json" "${IBAS_CONF}/config.json"; fi;
            rm -f "${IBAS_DEPLOY}/${folder}/config.json"
            ln -s "${IBAS_CONF}/config.json" "${IBAS_DEPLOY}/${folder}/config.json"
        fi;
# 映射日志文件夹到统一位置
        if [ -e "${IBAS_DEPLOY}/${folder}/WEB-INF/logs" ]; then rm -rf "${IBAS_DEPLOY}/${folder}/WEB-INF/logs"; fi;
        ln -s -d "${IBAS_LOG}" "${IBAS_DEPLOY}/${folder}/WEB-INF/"
# 映射数据文件夹到统一位置
        if [ -e "${IBAS_DEPLOY}/${folder}/WEB-INF/data" ]; then rm -rf "${IBAS_DEPLOY}/${folder}/WEB-INF/data"; fi;
        ln -s -d "${IBAS_DATA}" "${IBAS_DEPLOY}/${folder}/WEB-INF/"
# 集中共享jar包
        if [ -e "${IBAS_LIB}" ]
        then
# 复制模块jar包到tomcat的lib目录
            cp -f "${IBAS_DEPLOY}/${folder}/WEB-INF/lib/"*.jar "${IBAS_LIB}";
# 清除tomcat的lib已经存在的jar包
            rm -f "${IBAS_DEPLOY}/${folder}/WEB-INF/lib/"*.jar;
        fi;
# 备份程序包
        mv "${IBAS_PACKAGE}/${file}" ${IBAS_PACKAGE_BACKUP}/${file}
    done < "${IBAS_PACKAGE}/ibas.deploy.order.txt" | sed 's/\r//g';
# 备份顺序文件
mv "${IBAS_PACKAGE}/ibas.deploy.order.txt" ${IBAS_PACKAGE_BACKUP}/ibas.deploy.order.txt
# 修正ROOT目录
if [ -e "${IBAS_DEPLOY}/root" ]; then mv "${IBAS_DEPLOY}/root" "${IBAS_DEPLOY}/ROOT"; fi;
echo 操作完成
