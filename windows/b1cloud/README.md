# SAP B1 DIAPI DOCKERS
B1 DIAPI的容器

### 安装包 | packages
* packages/Windows.tar.gz               操作系统缺失的链接库
* packages/SqlNativeClient.tar.gz       SqlServer数据库连接库（2012）
* packages/Prerequisites.tar            基础运行环境，自行从B1安装包目录打包 (使用7zip打包，选择tar格式)
* packages/DIAPI.x64.tar                DI API安装包，自行从B1安装包目录打包
* packages/SLDAgentMSI_x64.tar          SLD Agent安装包，在B1Cloud的安装包

### 构建镜像 | building
* tomcat:ibas-b193
~~~
docker build --rm --force-rm -f ./dockerfile-b193 -t tomcat:ibas-b193 ./
docker run -it --name ibas-b193-demo -p 8080:8080 tomcat:ibas-b193
docker exec -it ibas-b193-demo cmd

docker cp packages\hosts ibas-b193-demo:C:\Windows\System32\drivers\etc\
docker cp packages\b1-local-machine.xml ibas-b193-demo:'/C:/Program Files/SAP/SAP Business One DI API/Conf/'
docker cp packages\regSLDaddress.ps1 ibas-b193-demo:C:\
docker exec -it ibas-b193-demo powershell C:\regSLDaddress.ps1
~~~
* others
~~~
### avacloud.cc/ 文件夹， B1Cloud环境的域控证书
### b1-local-machine.xml DI正确配置文件，在启动容器时，拷贝覆盖到DI 的conf的路径下
### createsldagent.ps1  通过cloud api创建sld agent
### oldclearagent.ps1   清理sld agent
### hosts  容器内部，如果DI配置文件使用机器名方式连接，需要更改hosts，否则连不到服务器
### regSLDAddress.ps1    修改sldaddress的注册表键值

### 安装证书

Import-PfxCertificate -FilePath 'C:\packages\avacloud.cc\keystore.pfx' -CertStoreLocation Cert:\LocalMachine\Root -Password (ConvertTo-SecureString -String "avatech" -Force –AsPlainText) ;
Import-Certificate -FilePath 'C:\packages\avacloud.cc\myCA.cer' -CertStoreLocation Cert:\LocalMachine\Root ;
Import-Certificate -FilePath 'C:\packages\avacloud.cc\ClientCert.crt' -CertStoreLocation Cert:\LocalMachine\CA ;

### 安装sld

Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{4DA2E464-C0A5-4743-9376-797205220E1C}\sqlncli_x64.msi',"/qn","IACCEPTSQLNCLILICENSETERMS=YES","/L*v sqlncli_x64.txt" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{DDC8DAA2-F191-4513-8AF7-EB151604EEA9}\sqlncli_x64.msi',"/qn","IACCEPTSQLNCLILICENSETERMS=YES" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{66EE9CF0-7792-49B6-81E1-EDCC77B800B3}\msodbcsql.msi',"/qn","IACCEPTMSODBCSQLLICENSETERMS=YES","/L*v msodbcsql.txt" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath msiexec -ArgumentList "/i",'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{5D5FFF39-015A-4DC8-A97F-6D51BAE90EDC}\SAPJVM8_x64.msi',"/qn","IACCEPTSQLNCLILICENSETERMS=YES" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{57bcd1d4-2de9-49d9-bc0c-3f4263e9970e}\WindowsInstaller-KB893803-v2-x86.exe' -ArgumentList "/q" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{C29E74A6-5565-44A4-AC93-A25720D76AAA}\vcredist_x64.exe' -ArgumentList "/q" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\ISSetupPrerequisites\{83960519-644A-4722-BA7A-37D23C1D004F}\vcredist_x86.exe' -ArgumentList "/q" -Wait -NoNewWindow -PassThru; `
Start-Process -FilePath 'C:\packages\SLDAgentMSI_x64\SLDAgent_x64.exe' -ArgumentList "/S","/v/qn" -Wait -NoNewWindow -PassThru;

~~~

