# Add environment variables to be used by Connect-MgGraph
$env:AZURE_CLIENT_ID = "0000000"
$env:AZURE_TENANT_ID = "0000000"
$env:AZURE_CLIENT_SECRET = "XXXXXXXXXX"
Connect-MgGraph -EnvironmentVariable
Get-MgOrganization | Select-Object DisplayName, VerifiedDomains, ID