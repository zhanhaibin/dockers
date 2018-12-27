### 使用SAP Cloud API 注册Sld Agent

# 忽略https请求，证书认证
if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
{
$certCallback = @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback ==null)
            {
                ServicePointManager.ServerCertificateValidationCallback += 
                    delegate
                    (
                        Object obj, 
                        X509Certificate certificate, 
                        X509Chain chain, 
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
    Add-Type $certCallback
 }
[ServerCertificateValidationCallback]::Ignore()

$uri="https://b1c-server.avacloud.cc/sld/sld0100.svc"
$header = @{
    "Accept"="application/json"
    "SBO-SLD-APP-ID"="5645523035534C44534C444167656E743A30303730323438333638373331323933F2192310B8ED4F4388C213C56D8103E139BFAD03"
}
$body = @{
    "Account"="b1cadm"
    "Password"="Aa123456"
} 
# LogonBySystemUser
$response= try { 
    Invoke-WebRequest -Method Post -Uri $uri/LogonBySystemUser -UseBasicParsing -ContentType "application/json" -Body ($body|ConvertTo-Json) -Headers $header -SessionVariable websession
} catch [System.Net.WebException]{
    Write-Verbose "An exception was caught: $($_.Exception.Mesage)"
    $_.Exception.Message
}
# get cookie
$cookies=$websession.Cookies.GetCookies($uri+"/LogonBySystemUser")
# add cookie value in headers
foreach ($cookie in $cookies) {    
    $header.Add("Cookie", "$cookie")
}
# add Agent-Host-Name in headers
$computer=Get-WMIObject Win32_ComputerSystem
$cname=$computer.name
$header.Add("Agent-Host-Name", $cname)
# CreateServiceUserAndLoginToken 
$response1=Invoke-RestMethod -Method Post -Uri $uri/CreateServiceUserAndLoginToken -ContentType "application/json" -Headers $header -WebSession $websession
$token=$response1.d.CreateServiceUserAndLoginToken
 
# clearOldAgentEntries
Invoke-WebRequest -Method Get -Uri $uri/clearOldAgentEntries  -UseBasicParsing -ContentType "application/json" -Headers $header -WebSession $websession
# LogonByServiceToken
$body.Add("Token",$token)
$response2=Invoke-WebRequest -Method Post -Uri $uri/LogonByServiceToken  -UseBasicParsing -ContentType "application/json" -Body ($body|ConvertTo-Json) -Headers $header -WebSession $websession
#$response2.Content

# ReserveIDs
$header.Remove("Accept")
$header.Add("Accept","application/json")
$header.Add("Agent-OS-Name","windows")

$response3=Invoke-RestMethod -Method Get -Uri $uri/ReserveIDs?Key="'Workstation'" -ContentType "application/json" -Headers $header -WebSession $websession
$agentID=$response3.d.results[0].ToString()

Invoke-RestMethod -Method Get -Uri $uri/RequestCommand?AgentID=$agentID -ContentType "application/json" -Headers $header -WebSession $websession
