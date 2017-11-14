# docker4ibas tomcat
为ibas创建的docker4tomcat相关内容。

### 使用说明 | instructions
* build_dockerfile.sh                   使用dockerfile创建容器镜像，若ibas_packages中无war包则自动下载
* deploy_apps.sh                            部署应用
* initialize_datastructures.sh              创建数据结构
* initialize_datas.sh                       初始化数据
* 使用时注意提前修改ibas_conf中配置文件
```
app.xml                                ibas服务配置
service_routing.xml                    ibas模块配置
config.json                            ibas前端配置
```
* 使用时注意提前修改tomcat_conf配置文件
```
catalina.properties                    tomcat容器配置
context.xml                            tomcat内容配置，务必打开允许软连接
```
* 测试环境时，配置文件中涉及的主机，建议修改本机host文件指向。
* 脚本中使用了额外文件作为任务执行顺序，详见各自内容。

* 执行时，同级目录要有btulz.transforms.tar压缩包
### 启动 | running
```
docker run --name ibas-db-mysql -p 3306:3306 -d -e MYSQL_ROOT_PASSWORD=1q2w3e mysql:5.7                             启动MYSQL容器
docker run --name=ibas-apps-demo --link=ibas-db-mysql:ibas-db-mysql -p 8080:8080 -d ibas-tomcat-all:1476945979       启动TOMCAT容器，并连接MYSQL容器
docker exec -it ibas-apps-demo ./initialize_datastructures.sh                                                    执行创建数据结构
docker exec -it ibas-apps-demo ./initialize_datas.sh                                                             执行初始化数据
```

### 鸣谢 | thanks
[牛加人等于朱](http://baike.baidu.com/view/1769.htm "NiurenZhu")<br>
[Color-Coding](http://colorcoding.org/ "咔啦工作室")<br>
