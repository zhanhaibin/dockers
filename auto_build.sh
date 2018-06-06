#!/bin/sh

date=`date +%Y%m%d%H%M`
cd /mnt/ibas/dockers/compiling/maven_typescript/alpine/
/bin/sh auto_docker_compile.sh >> /mnt/ibas/deploy/logs/auto_docker_compile_${date}.txt
cd /mnt/ibas/kubernetes/tomcat/
/bin/sh auto_build.sh ${date} >>  /mnt/ibas/deploy/logs/auto_buildimage_tomcat_${date}.txt
cd /mnt/ibas/kubernetes/nginx/
/bin/sh auto_build.sh ${date} >>  /mnt/ibas/deploy/logs/auto_buildimage_nginx_${date}.txt
