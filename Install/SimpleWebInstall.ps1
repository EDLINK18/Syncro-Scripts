### There are multiple places in this file that file/folder names have been replaced with XXXXX (5 Xs). This should make it easier to find and replace with your custom info.
### These functions, options, etc have been put together from multiple sources. Please feel free to optomize and submit changes back if there is a better way.
### Thanks, EDLINK18 - Region 18 Education Service Center Technology Consortium

$InstallerUrl = "https://XXXXX.net/XXXXX/XXXXX.msi"
$InstallerName = "XXXXX.msi"
$AppName = "XXXXX"
$InstallerFolder = "C:\temp\"
$AppFolder = "C:\Program Files\XXXXX"

#Check that folder exists, if not create folder
if (Test-Path $InstallerFolder) {
   
    Write-Host "Folder Exists"

}
else
{

    New-Item $InstallerFolder -ItemType Directory
    Write-Host "Folder Created successfully"

}

#Check if program path exists, if not install
if (Test-Path "$AppFolder") {

    Write-Output 'App already installed.'

}
else
{

Invoke-WebRequest -Uri "$InstallerUrl" -OutFile "$InstallerFolder\$InstallerName"
Start-Process "$InstallerFolder\$InstallerName" -ArgumentList "/quiet" -Wait

$IsAppInstalledOrNot = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -Match "$AppName" }

if ($IsAppInstalledOrNot -Match $AppName)
{
    Write-Output $IsAppInstalledOrNot
	Write-Output "Application successfully installed."
}
else
{
	Write-Output "Application failed to install. We can't find $AppName in the Add/Remove Programs list."
}

}
