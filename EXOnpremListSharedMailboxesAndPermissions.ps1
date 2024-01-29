# Written by my colleague Marcel Suck

# Add-Type lädt die Windows Forms Assembly

# Abrufen aller Shared Mailboxes
$sharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited
Write-Host "Shared Mailboxes abgerufen." -ForegroundColor Green

# Sammeln von SendAs und FullAccess Berechtigungen für jede Shared Mailbox
$permissionsData = @()

foreach ($mailbox in $sharedMailboxes) {

    # Hier fügen wir die E-Mail-Adresse hinzu
    $emailAddress = $mailbox.PrimarySmtpAddress

    if ($sendAsPermissions.Count -eq 0 -and $fullAccessPermissions.Count -eq 0) {
        $permissionsData += [PSCustomObject]@{
            Mailbox        = $mailbox.DisplayName
            EmailAddress   = $emailAddress  # E-Mail-Adresse hinzugefügt
            User           = "Kein Zugriff"
            PermissionType = "N/A"
        foreach ($permission in $sendAsPermissions) {
            $permissionsData += [PSCustomObject]@{
                Mailbox        = $mailbox.DisplayName
                EmailAddress   = $emailAddress  # E-Mail-Adresse hinzugefügt
                User           = $permission.Trustee
                PermissionType = "Send As"

        foreach ($permission in $fullAccessPermissions) {
            $permissionsData += [PSCustomObject]@{
                Mailbox        = $mailbox.DisplayName
                EmailAddress   = $emailAddress  # E-Mail-Adresse hinzugefügt
                User           = $permission.User
                PermissionType = "Full Access"

Write-Host "Berechtigungsdaten zusammengestellt." -ForegroundColor Green

# Erstellen des Speicherdialogs
$saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
$saveFileDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
$saveFileDialog.Filter = "CSV files (*.csv)|*.csv"
$saveFileDialog.FileName = "SharedMailboxPermissions.csv"

if ($saveFileDialog.ShowDialog() -eq "OK") {
    $permissionsData | Export-Csv -Path $saveFileDialog.FileName -NoTypeInformation
    Write-Host "Daten in $($saveFileDialog.FileName) exportiert." -ForegroundColor Green
    Write-Host "Export abgebrochen." -ForegroundColor Yellow
