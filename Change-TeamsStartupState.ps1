<#
.SYNOPSIS
This script changes the 'State' DWORD registry entry from 1 to 2 for Microsoft Teams startup.

.DESCRIPTION
The script is designed to modify a specific registry entry for controlling Microsoft Teams startup behavior. 
It targets the 'State' DWORD value in the registry and changes its value from 1 to 2. This is useful for 
administrators needing to automate the configuration of Teams on multiple systems.

.PARAMETER path
The registry path of the 'State' DWORD to be modified.

.PARAMETER name
The name of the registry DWORD to be modified. Default is 'State'.

.PARAMETER newValue
The new value to be set for the registry DWORD. Default is 2.

.OUTPUTS
Output to console regarding the success or failure of the operation.

.EXAMPLE
PS> .\Change-TeamsStartupState.ps1

This example runs the script to change the 'State' DWORD value to 2.

.NOTES
File Name       : Change-TeamsStartupState.ps1
Author          : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite    : PowerShell 5.1 or later. Administrative rights are required to modify the registry.
Copyright 2024  : Philipp Kohn, cloudcopilot.de

Change Log
----------
Date       Version   Author         Description
--------   -------   ------         -----------
09/01/24   1.0       Philipp    Initial creation with assistance from OpenAI's ChatGPT. Kudos to my colleague Dominik Paebst for finding the Registry Key
#>

$path = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask"
$name = "State"
$newValue = 2

# Check if the path exists
if (Test-Path $path) {
    # Get the current value
    $currentValue = Get-ItemProperty -Path $path -Name $name

    # Check if the State property exists and its current value
    if ($currentValue -and $currentValue.$name -ne $null) {
        # Change the value of the State entry
        Set-ItemProperty -Path $path -Name $name -Value $newValue
        Write-Host "Registry entry 'State' updated to $newValue."
    } else {
        Write-Host "The 'State' property does not exist at the specified path."
    }
} else {
    Write-Host "The specified registry path does not exist."
}
