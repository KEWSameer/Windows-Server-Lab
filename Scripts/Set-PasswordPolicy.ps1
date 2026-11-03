<#
.SYNOPSIS
    Applies the lab password and account lockout policy to the default domain policy.

.DESCRIPTION
    Matches module 05, parts 1 and 2. Run it on the domain controller as an administrator.

.EXAMPLE
    .\Set-PasswordPolicy.ps1
#>
[CmdletBinding()]
param(
    [string]$Domain = (Get-ADDomain).DNSRoot
)

Import-Module ActiveDirectory

Set-ADDefaultDomainPasswordPolicy -Identity $Domain `
    -PasswordHistoryCount 10 `
    -MaxPasswordAge (New-TimeSpan -Days 60) `
    -MinPasswordAge (New-TimeSpan -Days 1) `
    -MinPasswordLength 12 `
    -ComplexityEnabled $true `
    -LockoutThreshold 5 `
    -LockoutDuration (New-TimeSpan -Minutes 15) `
    -LockoutObservationWindow (New-TimeSpan -Minutes 15)

Write-Host 'Password and lockout policy applied. Current values:' -ForegroundColor Green
Get-ADDefaultDomainPasswordPolicy -Identity $Domain |
    Select-Object PasswordHistoryCount, MaxPasswordAge, MinPasswordAge, MinPasswordLength,
        ComplexityEnabled, LockoutThreshold, LockoutDuration, LockoutObservationWindow |
    Format-List

gpupdate /force
