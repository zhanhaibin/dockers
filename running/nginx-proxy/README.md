nginx-proxy nginx反向代理容器脚本

使用colorcoding/nginx:latest镜像

docker pull colorcoding/nginx:latest




增加了一段新的反向到nexus的代理

nexus使用反向代理，默认使用 location / 默认代理才能成功，如果使用虚拟目录，需要设置 nexus-default.properties 中的参数

nexus-context-path=/${NEXUS_CONTEXT} 改为：nexus-context-path=/nexus

docker cp nexus-default.properties  nexus:/opt/sonatype/nexus/etc/

https://app.avacloud.com.cn/nexus 




cat nginx.crt >> /etc/pki/tls/certs/ca-bundle.crt
  336  service restart docker


 location /nexus {
                proxy_next_upstream http_502 http_504 error timeout invalid_header;
                proxy_pass http://10.0.8.50:8081/nexus;
                proxy_redirect off;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto "https";
        }


docker run -d -p 8081:8081 -p 5000:5000 --name nexus -e MAX_HEAP=768m -v /etc/localtime:/etc/localtime  --volumes-from nexus-data sonatype/nexus3