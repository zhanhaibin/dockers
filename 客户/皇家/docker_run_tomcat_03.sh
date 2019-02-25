#!/bin/bash

RegistoryUrl=docker.avacloud.com.cn
customer=$1
account=$2
port=$3
tag=$4


docker run -it --name=${customer}-${account}-service  -c 2048 -m 4096m --memory-swap 0  -e JAVA_OPTS='-Xmx768m'  -v /srv/vstore/${customer}-${account}/ibas/:/usr/local/tomcat/ibas/ --link=vstore-mysql:vstore-mysql --restart=always -d ${RegistoryUrl}/c00003/c00003-01/ps-ava-vstore-hj/tomcat:${tag}
