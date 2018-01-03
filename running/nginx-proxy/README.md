nginx-proxy nginx反向代理容器脚本

使用colorcoding/nginx:latest镜像

docker pull colorcoding/nginx:latest




增加了一段新的反向到nexus的代理

nexus使用反向代理，默认使用 location / 默认代理才能成功，如果使用虚拟目录，需要设置 nexus-default.properties 中的参数

nexus-context-path=/${NEXUS_CONTEXT} 改为：nexus-context-path=/nexus

docker cp nexus-default.properties  nexus:/opt/sonatype/nexus/etc/

https://app.avacloud.com.cn/nexus 