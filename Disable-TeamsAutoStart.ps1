<#
.SYNOPSIS
This script disables the auto-start feature of the new Microsoft Teams client by modifying a registry value.

.DESCRIPTION
The script targets a specific DWORD registry entry related to Microsoft Teams startup behavior. It changes the 'State' DWORD value from its current setting to 0, effectively disabling the auto-start feature of Microsoft Teams. This script is useful for administrators who need to manage Teams startup settings on multiple systems.

.PARAMETER path
The registry path of the 'State' DWORD to be modified.

.PARAMETER name
The name of the registry DWORD to be modified. Default is 'State'.

.PARAMETER newValue
The new value to be set for the registry DWORD, set to 0 to disable auto-start. Default is 0.

.OUTPUTS
Output to console regarding the success or failure of the operation.

.EXAMPLE
PS> .\Disable-TeamsAutoStart.ps1

This example runs the script to change the 'State' DWORD value to 0, disabling auto-start.

.NOTES
File Name       : Disable-TeamsAutoStart.ps1
Author          : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite    : PowerShell 5.1 or later. Administrative rights are required to modify the registry.
Copyright 2024  : cloudcopilot.de

Change Log
----------
Date       Version   Author         Description
--------   -------   ------         -----------
09/01/24   1.0       Philipp Kohn    Initial creation with assistance from OpenAI's ChatGPT. Kudos to my colleague Dominik Paebst for finding the Registry Key.
#>

$path = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MSTeams_8wekyb3d8bbwe\TeamsTfwStartupTask"
$name = "State"
$newValue = 0  # Set to 0 to disable auto-start

# Check if the path exists
if (Test-Path $path) {
    # Get the current value
    $currentValue = Get-ItemProperty -Path $path -Name $name

    # Check if the State property exists and its current value
    if ($null -ne $currentValue.$name) {
        # Change the value of the State entry
        Set-ItemProperty -Path $path -Name $name -Value $newValue
        Write-Host "Registry entry 'State' updated to $newValue to disable auto-start of Teams."
    } else {
        Write-Host "The 'State' property does not exist at the specified path."
    }
} else {
    Write-Host "The specified registry path does not exist."
}