<#
.SYNOPSIS
This script fetches and exports all files from OneDrive and SharePoint Online in Microsoft 365 using Microsoft Graph PowerShell SDK.

.DESCRIPTION
- The script first connects to Microsoft Graph using `Connect-MgGraph`.
- It fetches all users and iterates through them to collect OneDrive files.
- Similarly, it fetches all SharePoint Online sites and iterates through them to collect SharePoint files.
- File details like Filename, Path, FileType, LastEdit, and Creator are captured.
- These details are then exported to two separate CSV files: One for OneDrive and another for SharePoint Online.

.OUTPUTS
Two CSV files containing details of all files in OneDrive and SharePoint Online:
- OneDriveFiles.csv
- SharePointFiles.csv

.NOTES
File Name      : M365_FileReport.ps1
Author         : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite   : PowerShell 7.x or newer. Microsoft Graph PowerShell SDK. Sufficient permissions to access user and site data.
Copyright 2023 : philipp.kohn@sva.de

Change Log
----------
Date       Version   Author          Description
--------   -------   ------          -----------
18/09/23   1.0       Philipp Kohn    Initial version.
#>


# Check PowerShell Version
Write-Host "Check if running PowerShell Version 7.x" -ForegroundColor 'Cyan'
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Throw "This script requires PowerShell 7 or a newer version."
}

# Try Discconnect Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions"
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}


# Add environment variables to be used by Connect-MgGraph
$env:AZURE_CLIENT_ID = "YOUR Client ID from your App Registration in Microsoft Entra"
$env:AZURE_TENANT_ID = "YOUR Tenant ID"

# Add environment variable with the Thumbprint of your Certificate
$Certificate = "The Tumbprint of your Certificate"

# Connect to Microsoft Graph PowerShell SDK
Connect-MgGraph -ClientId $env:AZURE_CLIENT_ID -TenantId $env:AZURE_TENANT_ID -CertificateThumbprint $Certificate

# Connection Infos for Microsoft Graph PowerShell SDK Connection
Write-Host "Getting the built-in onmicrosoft.com domain name of the tenant..."
$tenantName = (Get-MgOrganization).VerifiedDomains | Where-Object {$_.IsInitial -eq $true} | Select-Object -ExpandProperty Name
$AppRegistration = (Get-MgContext | Select-Object -ExpandProperty AppName)
$Scopes = (Get-MgContext | Select-Object -ExpandProperty Scopes)
Write-Host "Tenant: $tenantName" -ForegroundColor 'Cyan'
Write-Host "AppRegistration: $AppRegistration" -ForegroundColor 'Magenta'
Write-Host "Scopes: $Scopes" -ForegroundColor 'Cyan'

# Initialize arrays to store SharePoint and OneDrive file information
$sharePointFiles = @()
$oneDriveFiles = @()

# Fetch all SharePoint sites
$sites = Get-MgSite

# Debug: Display the number of SharePoint sites fetched
Write-Host "Number of SharePoint sites fetched: $($sites.Count)"

# Loop through each site to fetch SharePoint files
foreach ($site in $sites) {
    # Debug: Display the current site being processed
    Write-Host "Processing site: $($site.Id)"
    try {
        $drive = Get-MgSiteDrive -SiteId $site.Id
        if ($drive) {
            # Debug: Display a message if a drive is found
            Write-Host "Drive found for site: $($site.Id)"
            $driveId = $drive.Id
            Write-Host "Debug: DriveId is $($driveId) and its type is $($driveId.GetType().FullName)"
            $files = Get-MgDriveListItem -DriveId $driveId
            foreach ($file in $files) {
                $filePath = $file.WebUrl -replace "https://", ""
                $fileInfo = [PSCustomObject]@{
                    "Path" = $filePath
                    "FileType" = $file.File.MimeType
                    "LastEdit" = $file.LastModifiedDateTime
                    "Creator" = $file.CreatedBy.User.DisplayName
                }
                
                if ($filePath -match "^company-my.sharepoint.com/personal") {
                    $oneDriveFiles += $fileInfo
                } else {
                    $sharePointFiles += $fileInfo
                }
            }
        } else {
            # Debug: Display a message if no drive is found
            Write-Host "No drive found for site: $($site.Id)"
        }
    } catch {
        # Debug: Display an error message if fetching the drive fails
        Write-Host "Error fetching drive for site: $($site.Id)"
        Write-Host $_.Exception.Message
    }
}

# Export SharePoint and OneDrive files to separate CSV files
$sharePointFiles | Export-Csv -Path "SharePointFiles.csv"
$oneDriveFiles | Export-Csv -Path "OneDriveFiles.csv"

#Disconnect Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions" -ForegroundColor 'Magenta' 
Disconnect-MgGraph

Write-Host "Done."