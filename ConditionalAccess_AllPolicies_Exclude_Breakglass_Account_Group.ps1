<#
.SYNOPSIS
This script updates all Microsoft Graph Conditional Access policies to exclude a specified user or group.

.DESCRIPTION
uThis script connects to the Microsoft Graph API using the Microsoft Graph PowerShell SDK. It retrieves all Conditional Access policies and updates each policy to exclude a specified user or group, identified by its Object ID. This is typically used for excluding break-glass accounts from Conditional Access policies.

.PARAMETER AZURE_CLIENT_ID
The Client ID from your registered app in Microsoft Entra.

.PARAMETER AZURE_TENANT_ID
Your Entra Tenant ID.

.PARAMETER Certificate
The Thumbprint of your certificate used for authentication with Microsoft Graph.

.PARAMETER excludeObjectId
The Object ID of the Microsoft Entra group or user to exclude. This should be the ID of the group where all break-glass accounts are members.

.OUTPUTS
Informational messages about the updated policies, including their display names and IDs.

.EXAMPLE
.\ConditionalAccess_AllPolicies_Exclude_Breakglass_Account_Group.ps1

This will run the script using the parameters defined within it.

.NOTES
File Name      : ConditionalAccess_AllPolicies_Exclude_Breakglass_Account_Group.ps1
Author         : Philipp Kohn, Assisted by OpenAI's ChatGPT
Prerequisite   : Microsoft Graph PowerShell SDK, appropriate permissions to modify Conditional Access policies.
Copyright 2024 : cloudcopilot.de

Change Log
----------
Date       Version   Author          Description
--------   -------   ------          -----------
15/01/24   1.0       Philipp Kohn    Initial creation with assistance from OpenAI's ChatGPT.
#>

# Disconnect from any existing sessions with the Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions" -ForegroundColor Cyan
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}

# Add environment variables to be used by Connect-MgGraph
$env:AZURE_CLIENT_ID = "YOUR Client ID from your Registered App in Microsoft Entra"
$env:AZURE_TENANT_ID = "YOUR Tenant ID"

# Add environment variable with the Thumbprint of your Certificate
$Certificate = "The Tumbprint of your Certificate"

# Connect to Microsoft Graph PowerShell SDK
Connect-MgGraph -ClientId $env:AZURE_CLIENT_ID -TenantId $env:AZURE_TENANT_ID -CertificateThumbprint $Certificate

# Get all Conditional Access Policies
$policies = Get-MgIdentityConditionalAccessPolicy

# Specify the Object ID of the group or user to exclude
$excludeObjectId = "A Microsoft Entra Group ID - Where all Break Glass Accounts are a member of"

foreach ($policy in $policies) {
    # Check if the policy has a users condition
    if ($policy.Conditions.Users) {
        # Initialize exclude users list if it doesn't exist
        if (-not $policy.Conditions.Users.ExcludeUsers) {
            $policy.Conditions.Users.ExcludeUsers = @()
        }

        # Add the user/group to the exclude list if not already present
        if (-not $policy.Conditions.Users.ExcludeUsers.Contains($excludeObjectId)) {
            $policy.Conditions.Users.ExcludeUsers += $excludeObjectId

            # Update only the changed part of the policy
            try {
                Update-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $policy.Id -BodyParameter @{
                    Conditions = $policy.Conditions
                }
                Write-Host "Updated policy: $($policy.DisplayName) (ID: $($policy.Id))"
            } catch {
                Write-Host "Failed to update policy: $($policy.DisplayName) (ID: $($policy.Id)). Error: $_"
            }
        } else {
            Write-Host "User/Group already excluded in policy: $($policy.DisplayName) (ID: $($policy.Id))"
        }
    } else {
        Write-Host "No user conditions in policy: $($policy.DisplayName) (ID: $($policy.Id))"
    }
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph