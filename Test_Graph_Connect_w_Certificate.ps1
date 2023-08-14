# Add environment variables to be used by Connect-MgGraph
$env:AZURE_CLIENT_ID = "YOUR Client ID from your Registered App in Microsoft Entra"
$env:AZURE_TENANT_ID = "YOUR Tenant ID"
$CertificatePublicKey = "YOUR Authentication Certificate Public Key"
Connect-MgGraph -ClientId $env:AZURE_CLIENT_ID -TenantId $env:AZURE_TENANT_ID -CertificateThumbprint $CertificatePublicKey
Get-MgOrganization | Select-Object DisplayName, VerifiedDomains, ID

# Disconnect from Microsoft Graph
Disconnect-MgGraph