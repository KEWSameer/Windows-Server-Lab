<#
.SYNOPSIS
    Creates the lab.users OU, the lab users from a CSV file, and the Dev security group.

.DESCRIPTION
    Matches module 03 of the lab. The script skips objects that already exist,
    so you run it again without errors. It asks for a temporary password and
    forces each user to change it at first sign-in. No password is stored in the script.

.EXAMPLE
    .\Create-LabUsers.ps1
    .\Create-LabUsers.ps1 -CsvPath "C:\Users\Administrator\Desktop\users.csv"
#>
[CmdletBinding()]
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot 'users.csv'),
    [string]$OuName = 'lab.users',
    [string]$GroupName = 'Dev',
    [string[]]$GroupMembers = @('j.doe', 'r.wilson')
)

Import-Module ActiveDirectory

$domainDN = (Get-ADDomain).DistinguishedName
$ouPath = "OU=$OuName,$domainDN"

# 1. Create the OU when it is missing
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$OuName'" -SearchBase $domainDN -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $OuName -Path $domainDN
    Write-Host "Created OU $OuName" -ForegroundColor Green
}
else {
    Write-Host "OU $OuName already exists" -ForegroundColor Yellow
}

# 2. Create the users
$tempPassword = Read-Host -AsSecureString 'Enter a temporary password for new users'

Import-Csv -Path $CsvPath | ForEach-Object {
    if (Get-ADUser -Filter "SamAccountName -eq '$($_.SamAccountName)'" -ErrorAction SilentlyContinue) {
        Write-Host "User $($_.SamAccountName) already exists" -ForegroundColor Yellow
    }
    else {
        New-ADUser -Name $_.Name `
            -SamAccountName $_.SamAccountName `
            -UserPrincipalName $_.UPN `
            -Path $ouPath `
            -AccountPassword $tempPassword `
            -ChangePasswordAtLogon $true `
            -Enabled $true
        Write-Host "Created user $($_.SamAccountName)" -ForegroundColor Green
    }
}

# 3. Create the security group and add members
if (-not (Get-ADGroup -Filter "Name -eq '$GroupName'" -ErrorAction SilentlyContinue)) {
    New-ADGroup -Name $GroupName -GroupScope Global -GroupCategory Security -Path $ouPath
    Write-Host "Created group $GroupName" -ForegroundColor Green
}

Add-ADGroupMember -Identity $GroupName -Members $GroupMembers
Write-Host "Added $($GroupMembers -join ', ') to $GroupName" -ForegroundColor Green
