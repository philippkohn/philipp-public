<#
.SYNOPSIS
This script fetches service endpoint data from Microsoft 365 and exports it to a CSV file.

.DESCRIPTION
The script uses the Invoke-RestMethod cmdlet to retrieve service endpoint data from Microsoft 365. 
It processes the data to select the service area display name and URLs. Each URL is associated with 
its service area and then exported to a CSV file. This is particularly useful for administrators and 
consultants who need to analyze or document Microsoft 365 service endpoints.

.OUTPUTS
The script outputs a CSV file containing two columns: Service and URL. Each row represents a service 
area and its associated URL.

.NOTES
File Name       : Export-M365ServiceEndpoints.ps1
Author          : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite    : PowerShell 5.1 or later. Internet connectivity is required to fetch the data.
Copyright 2024  : cloudcopilot.de

Change Log
----------
Date       Version   Author          Description
--------   -------   ------          -----------
08/01/24   1.0       Philipp Kohn     Initial creation with assistance from OpenAI's ChatGPT.
#>

# Fetching service endpoint data from Microsoft 365
$result = Invoke-RestMethod -uri "https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7" |
    Select-Object serviceAreaDisplayName, urls |
    ForEach-Object {
        # Processing each service area and its URLs
        foreach ($url in $_.urls) {
            [pscustomobject][ordered]@{
                Service = $_.serviceAreaDisplayName
                URL     = $url
            }
        }
    }

# Exporting the results to a CSV file
$result | Export-Csv -Path "output.csv" -NoTypeInformation
