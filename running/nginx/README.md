ibas前端运行环境

ibas.index.html ibas首页
ibas.nginx.conf nginx配置文件


download_wars.sh  下载war包
compile_order.txt 下载war包资源文件

docker run -it --name=C02-01-WEB  -m 128m --memory-swap 0 -v /etc/localtime:/etc/localtime -p 82:80 --link=C02-01-SERVICE:C02-01-SERVICE -d colorcoding/nginx:C02-01
