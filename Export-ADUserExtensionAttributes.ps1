<#
.SYNOPSIS
Exports Active Directory user information including extension attributes to a CSV file.

.DESCRIPTION
- Validates the presence of the Active Directory PowerShell module.
- Constructs a list of properties to retrieve, focusing on basic user attributes and extensionAttribute1 through extensionAttribute15.
- Uses the Get-ADUser cmdlet to fetch user details from the local Active Directory.
- Processes extension attributes to ensure they are exported as single-value strings, even if they contain multiple values.
- Exports the results, including user attributes and extension attributes, to a CSV file at the specified output path.

.PARAMETER outputPath
The path where the output CSV file will be saved.

.OUTPUTS
A CSV file containing selected user information and extension attributes.

.EXAMPLE
PS C:\> .\Export-ADUserExtensionAttributes.ps1
Exports user information to 'C:\Script\ADUsersExtensionAttributes.csv'.

.NOTES
File Name      : Export-ADUserExtensionAttributes.ps1
Author         : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite   : Active Directory PowerShell Module. PowerShell 5.1 or newer.


Change Log
----------
Date       Version   Author         Description
--------   -------   ------         -----------
19/02/24   1.0       Philipp Kohn   Initial version. The script exports user information, including extension attributes from Active Directory to a CSV file.
#>

# Define the output path for the CSV file
$outputPath = "C:\Script\ADUsersExtensionAttributes.csv"  # Update this path

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the properties array, starting with basic user attributes
$properties = @(
    "Name",
    "UserPrincipalName",
    "EmailAddress"
)

# Add extensionAttribute1 through extensionAttribute15 to the properties array
1..15 | ForEach-Object {
    $properties += "extensionAttribute$_"
}

# Fetch the user data, including the specified properties
$users = Get-ADUser -Filter * -Properties $properties | 
    Select-Object -Property Name,
                              UserPrincipalName,
                              EmailAddress,
                              @{Name='extensionAttribute1'; Expression={($_.extensionAttribute1 -join ';')}},
                              @{Name='extensionAttribute2'; Expression={($_.extensionAttribute2 -join ';')}},
                              @{Name='extensionAttribute3'; Expression={($_.extensionAttribute3 -join ';')}},
                              @{Name='extensionAttribute4'; Expression={($_.extensionAttribute4 -join ';')}},
                              @{Name='extensionAttribute5'; Expression={($_.extensionAttribute5 -join ';')}},
                              @{Name='extensionAttribute6'; Expression={($_.extensionAttribute6 -join ';')}},
                              @{Name='extensionAttribute7'; Expression={($_.extensionAttribute7 -join ';')}},
                              @{Name='extensionAttribute8'; Expression={($_.extensionAttribute8 -join ';')}},
                              @{Name='extensionAttribute9'; Expression={($_.extensionAttribute9 -join ';')}},
                              @{Name='extensionAttribute10'; Expression={($_.extensionAttribute10 -join ';')}},
                              @{Name='extensionAttribute11'; Expression={($_.extensionAttribute11 -join ';')}},
                              @{Name='extensionAttribute12'; Expression={($_.extensionAttribute12 -join ';')}},
                              @{Name='extensionAttribute13'; Expression={($_.extensionAttribute13 -join ';')}},
                              @{Name='extensionAttribute14'; Expression={($_.extensionAttribute14 -join ';')}},
                              @{Name='extensionAttribute15'; Expression={($_.extensionAttribute15 -join ';')}}

# Export the user data to a CSV file
$users | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "Export completed. The file is located at: $outputPath"