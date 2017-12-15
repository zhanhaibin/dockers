# tomcat:ibas
ibas应用的运行环境,最新发布都使用tomcat.new下脚本


download_wars.sh 下载最新的war包

compile_order.txt 下载所需的资源文件

./build_dockerfile.sh C01-01 自动创建服务端SERVICE镜像，并启动运行容器。

************************************************************************************************************************
****以下命令已集成到build_dockerfile.sh脚本里，不需要手工执行了
创建镜像：

./build_dockerfile.sh C01-01  创建C01-01的Tomcat镜像

运行：

docker run -it --name=C01-01-SERVICE -m 512m --memory-swap 0 -v /etc/localtime:/etc/localtime -p 8971:8971 -d colorcoding/tomcat:C01-01

-m 512m 设置内存大小 512m

--memory-swap  内存+交换分区大小总限制，--memory-swap必须比-m,--memory大；给--memory-swap设置成 0。容器能使用的内存大小为 a，能使用的交换分区大小也为 a。因为 Docker 默认容器交换分区的大小和内存相同。

引用：

《Docker 运行时资源限制》：

http://blog.csdn.net/candcplusplus/article/details/53728507

************************************************************************************************************************

