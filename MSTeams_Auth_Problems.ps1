<#
.SYNOPSIS
    MSTeams_Auth_Problems.ps1 - PowerShell Script to workaround Microsoft Teams Authentication Problems 
 
.DESCRIPTION
    The Script works only for the current User! Don't use it with "runas"!
    
    Script Part 1: Adds trusted Site to Zone Assignments for the current User
                   Reference: https://docs.microsoft.com/en-us/microsoftteams/known-issues#authentication 
    Script Part 2: Purges the Microsoft Teams Application Cache Folders for the current User
    Script Part 3: Clear "Cached Credentials" for Microsoft Teams from the Windows Credential Manager for the current User

.OUTPUTS
    Results are printed to the console

.NOTES
    Author        Philipp Kohn, kohn.blog, Twitter: @philipp_kohn
    
    Change Log    V1.00, 04/01/2019 - Initial version
    Change Log    V1.01, 04/01/2019 - Added additional Teams Cache Folders
    Change Log    V1.02, 04/01/2019 - Several minor Changes, Suggestions from ISESteroids 
#>

#########################################################################################################################################
### Script Part1: Add "https://login.microsoftonline.com" and "https://*.teams.microsoft.com" to Internet Explorer Trusted Sites Zone ###
#########################################################################################################################################

# Internet Explorer Trusted Sites Assignment: "*.teams.microsoft.com"

$registryPath1 = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoft.com\*.teams'
$name1 = 'https'
$value1 = '2'
$propertytype1 = 'DWORD'

#If Registry key does not exist create it and set value
IF(!(Test-Path -Path $registryPath1))
        {New-Item -Path $registryPath1 -Force | Out-Null
         New-ItemProperty -Path $registryPath1 -Name $name1 -Value $value1 -PropertyType $propertytype1 -Force | Out-Null}
#If Registry key does exist set value only
 ELSE   {New-ItemProperty -Path $registryPath1 -Name $name1 -Value $value1 -PropertyType $propertytype1 -Force | Out-Null}

# Internet Explorer Trusted Sites Assignment: "login.microsoftonline.com"
$registryPath2 = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftonline.com\login'
$name2 = 'https'
$value2 = '2'
$propertytype2 = 'DWORD'
#If Registry key does not exist create it and set value
IF(!(Test-Path -Path $registryPath2))
        {New-Item -Path $registryPath2 -Force | Out-Null
         New-ItemProperty -Path $registryPath2 -Name $name2 -Value $value2 -PropertyType $propertytype2 -Force | Out-Null}
#If Registry key does exist set value only
ELSE    {New-ItemProperty -Path $registryPath2 -Name $name2 -Value $value2 -PropertyType $propertytype2 -Force | Out-Null}

#############################################################################################################################################
### Script Part2: Purge Microsoft Teams Client Cache Folders                                                                              ###
#############################################################################################################################################

# Microsoft Teams Client Cache Folders
$TeamsCacheFolder1 = "$env:APPDATA\Microsoft\teams\Application Cache\Cache"
$TeamsCacheFolder2 = "$env:APPDATA\Microsoft\Teams\blob_storage"
$TeamsCacheFolder3 = "$env:APPDATA\Microsoft\Teams\Cache"
$TeamsCacheFolder4 = "$env:APPDATA\Microsoft\Teams\databases"
$TeamsCacheFolder5 = "$env:APPDATA\Microsoft\Teams\GPUCache"
$TeamsCacheFolder6 = "$env:APPDATA\Microsoft\Teams\IndexedDB"
$TeamsCacheFolder7 = "$env:APPDATA\Microsoft\Teams\Local Storage"
$TeamsCacheFolder8 = "$env:APPDATA\Microsoft\Teams\tmp"

# Check if Path exists
IF (-not (Test-Path -Path "$env:APPDATA\Microsoft\teams")) 
        {Write-Error -Message 'Path Query: The Teams Application does not exist' -ErrorAction Stop}
ELSE    {Write-Verbose -Message 'Path Query: The Teams Application path exist' -Verbose}

# Stop running Microsoft Teams Instances 
Write-Warning -Message 'Script stops all running Teams processes in 15 seconds! Press Ctrl+C to stop script processing'
Start-Sleep -Seconds 15
Stop-Process -Name Teams -ErrorAction SilentlyContinue

# Purge Microsoft Teams Client Cache
Add-Type -AssemblyName PresentationFramework
$msgBoxInput =  [Windows.MessageBox]::Show('Purge Microsoft Teams Client Cache','MSTeams_Auth_Problems.ps1','YesNo','Error')

  switch  ($msgBoxInput) {

  'Yes' {Remove-Item -path "$TeamsCacheFolder1\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder2\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder3\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder4\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder5\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder6\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder7\*" -Recurse -ErrorAction SilentlyContinue
         Remove-Item -path "$TeamsCacheFolder8\*" -Recurse -ErrorAction SilentlyContinue}

  'No'  {Write-Verbose -Message 'Microsoft Teams Client Cache not purged on user choice'}
}

#############################################################################################################################################
### Script Part3: Clear Cached Credentials for Microsoft Teams                                                                            ###
#############################################################################################################################################

# Clear Microsoft Teams Cached Credentials 
$msgBoxInput =  [Windows.MessageBox]::Show('Clear Microsoft Teams Cached Credentials from Windows Credential Manager','MSTeams_Auth_Problems.ps1','YesNo','Error')
  switch  ($msgBoxInput) {

  'Yes' {

        #Clearing Credential Manager
        #Kudos @hhazeley, hazelnest.com

        #Set filters to query Credential Manager
        $filters = 'msteams*'

        #Extract information from Credential Manager and filter only Target.
        Foreach ($filter in $filters)
        {
        $keys = & "$env:windir\system32\cmdkey.exe" /list:($filter) | & "$env:windir\system32\findstr.exe" 'Target'
        $keys = ($keys -replace ' ','' -replace 'Target:','')}

        #Delete each target
        Foreach ($key in $keys)
        {
        Write-Verbose -Message "Removing credentials for target $key" -Verbose
        & "$env:windir\system32\cmdkey.exe" /del:($key) 
        }

        }

  'No' {Write-Verbose -Message 'Cached Credentials not cleared on user choice' -Verbose}
}