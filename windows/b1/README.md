# SAP B1 DIAPI DOCKERS
B1 DIAPI的容器

### 安装包 | packages
* packages/Windows.tar.gz               操作系统缺失的链接库
* packages/SqlNativeClient.tar.gz       SqlServer数据库连接库（2012）
* packages/Prerequisites.tar            基础运行环境，自行从B1_SHR目录打包
* packages/DIAPI.x64.tar                DI API安装包，自行从B1_SHR目录打包

### 构建镜像 | building
* tomcat:ibas-b192
~~~
docker build --rm --force-rm -f ./dockerfile-b192 -t tomcat:ibas-b192 ./
docker run -it --name ibas-b192-demo -p 8080:8080 tomcat:ibas-b192

docker build --rm --force-rm -f ./dockerfile-b193 -t tomcat:ibas-b193 ./
docker run -it --name ibas-b193-demo -p 8080:8080 tomcat:ibas-b193



docker cp packages\hosts ibas-b192-demo:C:\Windows\System32\drivers\etc\
docker exec -it ibas-b192-demo cmd
~~~
* others
~~~
# 安装证书
Import-PfxCertificate -FilePath keystore.pfx -CertStoreLocation Cert:\LocalMachine\Root -Password (ConvertTo-SecureString -String "avatech" -Force –AsPlainText) ;
Import-Certificate -FilePath my.cert -CertStoreLocation Cert:\LocalMachine\Root ;
Import-Certificate -FilePath my.cert -CertStoreLocation Cert:\LocalMachine\CA ;

# 安装程序包
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{4DA2E464-C0A5-4743-9376-797205220E1C}\sqlncli_x64.msi',"/qn","IACCEPTSQLNCLILICENSETERMS=YES","/L*v sqlncli_x64.txt" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{DDC8DAA2-F191-4513-8AF7-EB151604EEA9}\sqlncli_x64.msi',"/qn","IACCEPTSQLNCLILICENSETERMS=YES" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{66EE9CF0-7792-49B6-81E1-EDCC77B800B3}\msodbcsql.msi',"/qn","IACCEPTMSODBCSQLLICENSETERMS=YES","/L*v msodbcsql.txt" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{5D5FFF39-015A-4DC8-A97F-6D51BAE90EDC}\SAPJVM8_x64.msi',"/qn","IACCEPTSQLNCLILICENSETERMS=YES" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{57bcd1d4-2de9-49d9-bc0c-3f4263e9970e}\WindowsInstaller-KB893803-v2-x86.exe' -ArgumentList "/q" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{C29E74A6-5565-44A4-AC93-A25720D76AAA}\vcredist_x64.exe' -ArgumentList "/q" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{83960519-644A-4722-BA7A-37D23C1D004F}\vcredist_x86.exe' -ArgumentList "/q" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\SLDAgent_x64.exe' -ArgumentList "/S","/v/qn" -Wait -NoNewWindow -PassThru;

# 安装sldagent
RUN powershell -executionpolicy unrestricted C:\packages\createsldagent.ps1	 ;



~~~

### 鸣谢 | thanks
[牛加人等于朱](http://baike.baidu.com/view/1769.htm "NiurenZhu")<br>
[Color-Coding](http://colorcoding.org/ "咔啦工作室")<br>
