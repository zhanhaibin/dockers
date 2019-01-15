docker build -t nginx:latest .
docker run -d --name=nginx -p 443:443 nginx
docker cp .\nginx.conf nginx:/nginx-1.9.13/conf/
docker exec -it nginx nginx -s reload