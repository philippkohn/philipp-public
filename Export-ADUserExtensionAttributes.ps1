<#
.SYNOPSIS
Exports Active Directory user information including extension attributes to a CSV file.

.DESCRIPTION
- The script starts by verifying the presence of the Active Directory PowerShell module.
- It dynamically constructs a list of properties to retrieve, focusing on basic user attributes and extensionAttribute1 through extensionAttribute15.
- Utilizes the Get-ADUser cmdlet to fetch user details from the local Active Directory.
- The Fully Qualified Domain Name (FQDN) of the domain is included in the name of the output CSV file to uniquely identify the source domain.
- The results, including selected user attributes and extension attributes, are exported to a CSV file named according to the domain's FQDN.

.OUTPUTS
A CSV file named 'ADUsersExtensionAttributes_<DomainFQDN>.csv' containing selected user information and extension attributes.

.NOTES
File Name      : Export-ADUserExtensionAttributes.ps1
Author         : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite   : Active Directory PowerShell Module. PowerShell 5.1 or newer.
Copyright 2024 : SVA System Vertrieb Alexander GmbH

Change Log
----------
Date       Version   Author         Description
--------   -------   ------         -----------
19/02/24   1.0       Philipp Kohn   Initial version.
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Start with the basic properties you always want
$properties = @(
    "Name",
    "UserPrincipalName", # Using UPN instead of SamAccountName
    "EmailAddress"
)

# Dynamically add extensionAttribute1 through extensionAttribute15
1..15 | ForEach-Object {
    $properties += "extensionAttribute$_"
}

# Fetch the domain's FQDN
$domainFQDN = (Get-ADDomain).DNSRoot

# Replace invalid filename characters in FQDN
$validDomainFQDN = $domainFQDN -replace '[\\/:*?"<>|]', '-'

# Fetch the user data and select the properties
$users = Get-ADUser -Filter * -Properties $properties | Select-Object $properties

# Define the CSV file path, including the domain FQDN
$csvFilePath = "ADUsersExtensionAttributes_$validDomainFQDN.csv"

# Export the data to a CSV file
$users | Export-Csv -Path $csvFilePath -NoTypeInformation