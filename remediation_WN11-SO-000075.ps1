<#
.SYNOPSIS
    This PowerShell script configures the required legal notice to display before console logon.
.NOTES
    Author          : Symone-Marie Priester
    LinkedIn        : linkedin.com/in/symone-mariepriester
    GitHub          : github.com/Symone-Marie
    Date Created    : 2026-02-20
    Last Modified   : 2026-02-20
    Version         : Microsoft Windows [Version 10.0.26200.7623]
    CVEs            : N/A
    Vuln-ID         : V-253445
    STIG-ID         : WN11-SO-000075
.TESTED ON
    Date(s) Tested  : 2026-02-20
    Tested By       : Symone-Marie Priester
    Systems Tested  : Windows 11 Pro OS
    PowerShell Ver. : 5.1
    Manual Test     : Yes, remediated via Local Group Policy Editor (gpedit.msc) with screenshot documentation
.USAGE
    Configures the required DoD legal notice text and title to display before console logon.
    Example syntax:
    PS C:\> .\remediation_WN11-SO-000075.ps1
#>

# Define registry path and values
$regPath    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regNameText  = "legalnoticetext"
$regNameCaption = "legalnoticecaption"

$bannerText = "You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only. By using this IS (which includes any device attached to this IS), you consent to the following conditions: -The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations. -At any time, the USG may inspect and seize data stored on this IS. -Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose. -This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy. -Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details."

$bannerCaption = "DoD Notice and Consent Banner"

Write-Host "Configuring required legal notice for console logon..."

# Create registry path if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Set the registry values
Set-ItemProperty -Path $regPath -Name $regNameText -Value $bannerText -Type String
Write-Host "Set $regNameText to required DoD banner text"

Set-ItemProperty -Path $regPath -Name $regNameCaption -Value $bannerCaption -Type String
Write-Host "Set $regNameCaption to '$bannerCaption'"

# Verify the changes
Write-Host "`nVerifying configuration..."
$currentText    = Get-ItemProperty -Path $regPath -Name $regNameText -ErrorAction SilentlyContinue
$currentCaption = Get-ItemProperty -Path $regPath -Name $regNameCaption -ErrorAction SilentlyContinue

if ($currentText.$regNameText -eq $bannerText -and $currentCaption.$regNameCaption -eq $bannerCaption) {
    Write-Host "SUCCESS: WN11-SO-000075 remediated - Legal notice is configured for console logon" -ForegroundColor Green
    Write-Host "`nCurrent registry values:"
    Get-ItemProperty -Path $regPath -Name $regNameText | Select-Object legalnoticetext
    Get-ItemProperty -Path $regPath -Name $regNameCaption | Select-Object legalnoticecaption
} else {
    Write-Host "ERROR: Failed to set registry values" -ForegroundColor Red
}

# Apply Group Policy changes immediately
Write-Host "`nApplying Group Policy update..."
gpupdate /force
