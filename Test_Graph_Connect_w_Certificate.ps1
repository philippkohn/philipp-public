# Add environment variables to be used by Connect-MgGraph
$env:AZURE_CLIENT_ID = "YOUR Client ID from your Registered App in Microsoft Entra"
$env:AZURE_TENANT_ID = "YOUR Tenant ID"

# Add variable with the Thumbprint of your Certificate
$Certificate = "The Tumbprint of your Certificate"
Connect-MgGraph -ClientId $env:AZURE_CLIENT_ID -TenantId $env:AZURE_TENANT_ID -CertificateThumbprint $Certificate

# Connect to Microsoft Graph PowerShell SDK
Connect-MgGraph -ClientId $env:AZURE_CLIENT_ID -TenantId $env:AZURE_TENANT_ID -CertificateThumbprint $Certificate

# Get Organization Infos for testing purposes
Get-MgOrganization | Select-Object DisplayName, VerifiedDomains, ID

# Disconnect from Microsoft Graph
Disconnect-MgGraph