<#
.SYNOPSIS
    Checks that the main lab objects and settings exist.

.DESCRIPTION
    Run it on the domain controller after modules 03 to 05. It prints PASS or FAIL for each check.

.EXAMPLE
    .\Test-LabHealth.ps1
#>
[CmdletBinding()]
param(
    [string]$OuName = 'lab.users',
    [string]$GroupName = 'Dev',
    [string]$ShareName = 'Devs',
    [string[]]$ExpectedUsers = @('j.smith', 'j.doe', 's.davis', 'r.wilson'),
    [string[]]$ExpectedGpos = @('screen lock policy', 'UAC policy', 'usb deny policy', 'software policy', 'pc setting policy', 'local policy')
)

Import-Module ActiveDirectory
Import-Module GroupPolicy

function Write-Check {
    param([string]$Name, [bool]$Passed)
    if ($Passed) { Write-Host "[PASS] $Name" -ForegroundColor Green }
    else { Write-Host "[FAIL] $Name" -ForegroundColor Red }
}

$domain = Get-ADDomain
Write-Check "Domain $($domain.DNSRoot) is reachable" ($null -ne $domain)

$ou = Get-ADOrganizationalUnit -Filter "Name -eq '$OuName'" -ErrorAction SilentlyContinue
Write-Check "OU $OuName exists" ($null -ne $ou)

foreach ($user in $ExpectedUsers) {
    $found = Get-ADUser -Filter "SamAccountName -eq '$user'" -ErrorAction SilentlyContinue
    Write-Check "User $user exists" ($null -ne $found)
}

$members = @(Get-ADGroupMember -Identity $GroupName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty SamAccountName)
Write-Check "Group $GroupName contains j.doe" ($members -contains 'j.doe')
Write-Check "Group $GroupName contains r.wilson" ($members -contains 'r.wilson')
Write-Check "Group $GroupName does not contain s.davis" ($members -notcontains 's.davis')

$policy = Get-ADDefaultDomainPasswordPolicy
Write-Check 'Minimum password length is 12' ($policy.MinPasswordLength -eq 12)
Write-Check 'Password complexity is enabled' ($policy.ComplexityEnabled -eq $true)
Write-Check 'Lockout threshold is 5' ($policy.LockoutThreshold -eq 5)

foreach ($gpo in $ExpectedGpos) {
    $found = Get-GPO -Name $gpo -ErrorAction SilentlyContinue
    Write-Check "GPO '$gpo' exists" ($null -ne $found)
}

$share = Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue
Write-Check "SMB share $ShareName exists" ($null -ne $share)
