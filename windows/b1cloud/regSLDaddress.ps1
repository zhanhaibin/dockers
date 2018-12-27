$registryPath ="HKLM:\SOFTWARE\SAP\SAP Manage"

$Name = "SLDaddress"
$Value = "https://b1c-server.avacloud.cc/sld/sld0100.svc"
New-ItemProperty -Path $registryPath -Name $Name -Value $Value -PropertyType EXPANDString  -Force 

