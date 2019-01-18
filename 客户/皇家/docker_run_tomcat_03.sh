#!/bin/bash

RegistoryUrl=docker.avacloud.com.cn
customer=$1
account=$2
port=$3
tag=$4


docker run -it --name=${customer}-${account}-web -v /etc/localtime:/etc/localtime -v /srv/vstore/${customer}-${account}/ibas/data/documents_files:/usr/share/nginx/webapps/documents/resources/files/ -v /srv/vstore/${customer}-${account}/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -p ${port}:80 --restart=always --link=${customer}-${account}-service:${customer}-${account}-service -d ${RegistoryUrl}/c00003/c00003-01/ps-ava-vstore-hj/nginx:${tag}
