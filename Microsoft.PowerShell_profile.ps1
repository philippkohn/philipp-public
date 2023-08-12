# Set the current location to the specified path
Set-Location C:\Scripts\GitHub\M365

# Check if the Terminal-Icons module is installed, if not, write a warning message
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Write-Warning "The Terminal-Icons module is not installed. Please install it from the PowerShell Gallery."
}

# Import the Terminal-Icons module that adds file and folder icons to the terminal output
Import-Module -Name Terminal-Icons

# Check if the oh-my-posh package is installed using winget, if not, write a warning message
if (-not (winget list JanDeDobbeleer.OhMyPosh)) {
    Write-Warning "The oh-my-posh package is not installed. Please install it using winget."
}

# Check if the file C:\Scripts\GitHub\philipp-public\ohmyposhv3-v2.json exists, if not, write a warning message
if (-not (Test-Path C:\Scripts\GitHub\philipp-public\ohmyposhv3-v2.json)) {
    Write-Warning "The file C:\Scripts\GitHub\philipp-public\ohmyposhv3-v2.json does not exist. Please download it from GitHub."
}

# Initialize the oh-my-posh module that adds a customizable prompt and theme to the terminal
oh-my-posh --init --shell pwsh --config "C:\Scripts\GitHub\philipp-public\ohmyposhv3-v2.json" | Invoke-Expression

# Check if the host name is ConsoleHost, which is the default host for PowerShell
if ($host.Name -eq 'ConsoleHost')
{
    # Check if the PSReadLine module is installed, if not, write a warning message
    if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
        Write-Warning "The PSReadLine module is not installed. Please install it from the PowerShell Gallery."
    }
    # Import the PSReadLine module that adds syntax highlighting, auto-completion and history search to the terminal input
    Import-Module PSReadLine
}

# Set the key handler for the up arrow key to search backward in the command history
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# Set the key handler for the down arrow key to search forward in the command history
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Write a greeting message to the terminal output in yellow text with a blue background
Write-Host Hello Commander how can I serve you! -ForegroundColor Yellow -BackgroundColor Blue