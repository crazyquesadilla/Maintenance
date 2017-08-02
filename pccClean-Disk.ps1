﻿<#
--------------------------
Automate running Disk Cleanup with all
options enabled.
Parsec Computer Corp.
Created:  Van Donley - 04/14/2017
Last Updated:  Van Donely - 04/17/2017
--------------------------
#>

function pccClean-Disk
{

# Create hashtable for return from function

[hashtable]$Return = @{}

# Registry information to configure Disk Cleanup

$strKeyPath   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
$strValueName = "StateFlags0042"
$subkeys      = Get-ChildItem -Path $strKeyPath -Name

# Try setting the registry keys and catch any errors

    try
    { 
        ForEach($subkey in $subkeys){
            $null = New-ItemProperty -Path $strKeyPath\$subkey -Name $strValueName -PropertyType DWord -Value 2 }

       $Return.AddRegKeys = "Success"
    }
    
    catch [Exception] { $Return.AddRegKeys = $_.Exception.Message | Format-List | Out-String }

# Try running Disk Cleanup
    
    try
    {
        Start-Process cleanmgr.exe -ArgumentList "/sagerun:42" -Wait -NoNewWindow

        $Return.RunCleanup = "Running cleanmgr.exe"
    }
    
    catch [Exception] { $Return.RunCleanup = $_.Exception.Message | Format-List | Out-String }

# Try removing the registry keys
    
    try
    {
        ForEach($subkey in $subkeys){
            $null = Remove-ItemProperty -Path $strKeyPath\$subkey -Name $strValueName }
        
        $Return.DelRegKeys = "Success" 
    }

    catch [Exception] { $Return.DelRegKeys = $_.Exception.Message | Format-List | Out-String }

 return $Return

}

pccClean-Disk    