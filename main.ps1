$Path = Get-Location
$File = Read-Host "please enter log file name"

Select-String -Path "$Path\*.txt" -Pattern 'OS Name'
Select-String -Path "$Path\*.txt" -Pattern 'OS Version'

Write-Output "CHECK IF BFE IS RUNNING"
Get-Service -Name BFE

Write-Output "CHECK NSI IS RUNNING"
Get-Service -Name nsi 

Write-Output "check if power is running"
Get-Service -Name Power 

#LMHosts
#EnableLMHOSTS = 1 means enabled
Write-Output 'CHECK IF LMHOSTS IS ENABLED'
function Test-NetBT{
    $interfaces = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\TCPIP*
    $i = 0
    foreach ($interface in $interfaces) {
        $i +=  $interface.EnableLMHOSTS
        if ($interfaces.Count *2 -eq $i) {
        #netbios disabled
        return  0
        }
        else {
        # netbios enabled
        return   1
        }
    }
}
(Test-NetBT) 
 
Write-Output "CHECK IF CERTIFICATE IS ENABLED"
Get-ChildItem -Path Cert:\LocalMachine -Recurse | Where-Object {$_.FriendlyName -contains "Digicert"}

Write-Output "CHECK IF TS01 CONNECTING"

#New-Object System.Net.Sockets.TcpClient("ts01-b.cloudsinknet", 443)
$TCPClient = New-Object System.Net.Sockets.TcpClient("ts01-b.cloudsink.net", 443)
$TCPClient | Get-Member -Type Method

Write-Output "CHECK PROXY"
netsh winhttp show proxy 

#CHECK IF GPO ENABLED
#gpresult /v >> c:\temp\gpresult.txt 