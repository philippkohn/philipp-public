<#
.SYNOPSIS
    PowerCLI_Get_VMware_Tools_Version.ps1 - Script to query the installed version of VMware Tools
 
.DESCRIPTION
    Script is written for interactive use with PowerShell ISE!
    
.OUTPUTS
    Results are printed to the console
.NOTES
    Prerequisites VMware PowerCLI have to be installed
	Author        Philipp Kohn, kohn.blog, Twitter: @philipp_kohn
    
    Change Log    V1.00, 11/17/2018 - Initial version
    Change Log    V1.01, 12/09/2019 - Edit Comments and Inital commit to GitHub Repo    
#>

# Check if PowerCLI is loaded
If ( ! (Get-module VMware.VimAutomation.Core )) {

    . "C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
    }
    
    # vCenter Server
    $vcenter = 'vcenter01.kohn.blog'
    
    # Simple txt file list for VMs to query 
    $VMlist = 'C:\Script\VMs-to-query.txt'
    
    # Logon to vCenter
    Connect-VIServer -Server $vcenter -Protocol https
    
    # Get VMs from txt file
    $VMs = Get-Content $VMlist
    
    # Query VMware Tools version from VMs listet in the txt file
    get-vm $VMs| get-vmguest | Select-Object VMName, ToolsVersion | out-file $env:USERPROFILE\documents\VMWare_Tools_Report_$(get-date -f dd-MM-yyyy-hhmm).txt
    
    # Query VMware Tools of all VMs
    # get-vm | get-vmguest | select VMName, ToolsVersion | out-file $env:USERPROFILE\documents\VMWare_Tools_Report_$(get-date -f dd-MM-yyyy-hhmm).txt
    
    # Query VMware Tools of specific VMs from a vSphere Infrastructure folder
    # get-folder 'DCs' | get-vm | get-vmguest | select VMName, ToolsVersion | out-file $env:USERPROFILE\documents\VMWare_Tools_Report_$(get-date -f dd-MM-yyyy-hhmm).txt
    
    # Logoff from vCenter
    Disconnect-VIServer -Server $vcenter