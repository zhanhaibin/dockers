maven_typescript ibas应用程序编译，打包，上传私有仓库的镜像

基于官方node的镜像，做java 和maven 编译环境

1、构建maven_typescript的docker时，apache-maven-3.5.0-bin.tar.gz和 jdk-8u144-linux-x64.tar.gz 这两个安装包需要在同目录下

2、运行sh	build_dockerfile.sh   生成镜像，默认为colorcoding/maven_typescript 版本为当前日期

-------------------------------------------------------------------------------------------------------------------------
以下文件会在创建镜像时，会自动拷贝到镜像内

1、使用git-ibas.sh 从git上下载最新的ibas基础模块

2、使用git-ibas-cloud.sh 从tfs上下载最新的ibas cloud模块

3、使用git-ibas-framework 获取ibas-framework最新代码

4、使用git-btulz.tramsforms获取tramsforms最新代码

    注意这里，ibas-framework及btulz.tansforms不用发布时获取代码，这些会从Maven仓库获取，而且那里是稳定版本。

5、compile_order.txt ，在git-ibas.sh下载模块清单

6、complie_cloud_order.txt，在git-ibas-cloud.sh下载模块清单

7、builds.sh 前端ts编译脚本

8、compiles.sh 后台编辑脚本

9、deploy_wars.sh    将编译后war包，发布到maven私有仓库



