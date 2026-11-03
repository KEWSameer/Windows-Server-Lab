# 🧰 Scripts

PowerShell versions of the manual steps in the lab modules. Run them on the domain controller in an elevated PowerShell window.

| Script | Matches module | What it does |
|---|---|---|
| `Create-LabUsers.ps1` | 03 | Creates the `lab.users` OU, users from `users.csv`, and the `Dev` group |
| `Set-PasswordPolicy.ps1` | 05 | Applies the password and account lockout values to the domain |
| `Test-LabHealth.ps1` | 03 to 05 | Prints PASS or FAIL for users, group, policy, GPOs, and the share |
| `users.csv` | 03 | Sample input for the user script |

## Usage

```powershell
Set-Location C:\Scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\Create-LabUsers.ps1
.\Set-PasswordPolicy.ps1
.\Test-LabHealth.ps1
```

## Notes

- `Create-LabUsers.ps1` asks for a temporary password at run time. No password is stored in the repository.
- Both setup scripts skip objects that exist, so you run them again without errors.
- Run the manual steps in the module READMEs first. The scripts are there to repeat the work quickly.
- Test the scripts in your own lab only.
