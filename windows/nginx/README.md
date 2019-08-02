docker build -t nginx:latest .
docker run -d --name=nginx -p 443:443 nginx
docker cp .\nginx.conf nginx:/nginx-1.9.13/conf/
docker exec -it nginx nginx -s reload



docker run -d --name=nginx  -v C:\vstore\Docker\nginx\logs\:C:\nginx-1.9.13\logs\ --restart=always -p 443:443 nginx
docker cp .\cert\2283251_b1i.avacloud.com.cn.key nginx:C:\nginx-1.9.13\cert\
docker cp .\cert\2283251_b1i.avacloud.com.cn.pem nginx:C:\nginx-1.9.13\cert\
docker cp .\nginx.conf nginx:C:\nginx-1.9.13\conf\