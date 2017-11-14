maven_typescript 构建docker image后操作

1、使用git-ibas-framework 获取ibas-framework最新代码

2、使用git-btulz.tramsforms获取tramsforms最新代码

3、使用git-ibas.sh 获取ibas的最新代码 

4、构建maven_typescript的docker时，apache-maven-3.5.0-bin.tar.gz和 jdk-8u144-linux-x64.tar.gz 这两个安装包需要在同目录下

5、运行	./build_dockerfile.sh   生成镜像，默认为colorcoding/maven_typescript 版本为当前日期

