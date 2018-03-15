$RootDrive = 'C:\'
$GitPath = join-path $RootDrive 'Git'
$NAVServerRSName = 'NO01DEV03'
# Client Enabling WSManCredSSP to be able to do a double hop with authentication.
Enable-WSManCredSSP -Role Client -DelegateComputer $NAVServerRSName  -Force
$InstanceSecurePassword = ConvertTo-SecureString $InstancePassword -AsPlainText -Force
$UserCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $InstanceSecurePassword 
Enter-PSSession -ComputerName $NAVServerRSName -UseSSL -Credential $UserCredential –Authentication CredSSP

Import-Module SQLPS -DisableNameChecking 
Import-module (Join-Path "$GitPath\Cloud.Ready.Software.PowerShell\PSModules" 'LoadModules.ps1') -Force -WarningAction SilentlyContinue | Out-Null
Import-module (Join-Path "$GitPath\IncadeaNorway" 'LoadModules.ps1') -Force -WarningAction SilentlyContinue | Out-Null
Import-NAVModules-INC -ShortVersion '110' -ImportRTCModule 
$NAVLicense = 'C:\Incadea\NAV2018.flf'
$NAVInstanceName = 'DynamicsNAV110'
$ExtensionName = 'SMS Authentication'
$NAVInstance = Get-NAVServerInstance -ServerInstance $NAVInstanceName
$NAVInstance | Set-NAVServerInstance -stop
#$NAVInstance | Set-NAVServerConfiguration -KeyName PublicWebBaseUrl -KeyValue "http://no01dev03.si-dev.local:8088/dynamicsnav110/"
$NAVInstance | Set-NAVServerConfiguration -KeyName PublicWebBaseUrl -KeyValue "http://localhost:8080/dynamicsnav110/"
$NAVInstance | Set-NAVServerInstance -start
$NAVInstance | Import-NAVServerLicense -LicenseFile $NAVLicense
# Remember to change the tag NetFx40_LegacySecurityPolicy to "false" in the file Microsoft.Dynamics.Nav.Server.exe.config
$NAVInstance | Set-NAVServerInstance -Restart

Get-NAVAppInfo -ServerInstance $NAVInstanceName
$NAVInstance | Sync-NAVTenant -Mode Sync
$NAVInstance | Sync-NAVApp -Name $ExtensionName -Mode Clean -Force
$NAVInstance | sync-nav Unpublish-NAVApp -Name $ExtensionName -Version 1.0.0.0
$NAVInstance | Uninstall-NAVApp -Name $ExtensionName -Version 1.0.0.0
$NAVInstance | Unpublish-NAVApp -Name $ExtensionName -Version 1.0.0.0
# Run this after publishing new version of a extension. Update the version number with the new version.
$NAVInstance | Start-NAVAppDataUpgrade -Name $ExtensionName -Version 1.0.0.6


