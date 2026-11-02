# Windows Server 2022 Active Directory Home Lab

A virtualized Windows domain built from scratch. The lab covers server installation, Active Directory, identity management, Group Policy, file permissions, and end-user testing from a Windows 11 client.

![Platform](https://img.shields.io/badge/Windows%20Server-2022-0078D4)
![Client](https://img.shields.io/badge/Client-Windows%2011%20Pro-0078D4)
![Hypervisor](https://img.shields.io/badge/Hypervisor-VMware%20Workstation-607078)
![Domain](https://img.shields.io/badge/Domain-lab.local-2E7D32)

## Overview

You build a small corporate network inside VMware. One Windows Server 2022 machine acts as the domain controller. One Windows 11 Pro machine acts as an employee workstation. You then configure security controls on the server and prove they work from the client.

## Skills demonstrated

- Virtual machine provisioning and Windows Server installation
- Static IPv4 configuration, DNS, and Active Directory Domain Services
- Domain controller promotion and forest creation
- Organizational Units, users, and security groups
- Bulk user creation with PowerShell and CSV
- Group Policy: password, lockout, UAC, USB, installer, and Control Panel controls
- NTFS permissions, SMB shares, and Effective Access checks
- Domain join and policy validation from a client

## Architecture

```text
Windows 11 Pro client (CL01)
        |  DNS, Kerberos authentication, SMB
        v
Windows Server 2022 domain controller
  |-- Active Directory domain: lab.local
  |-- OU: lab.users
  |-- Security group: Dev
  |-- Group Policy Objects
  `-- SMB share: Devs
```

## Lab specification

| Component | Configuration |
|---|---|
| Server VM | Windows Server 2022 Datacenter Evaluation (Desktop Experience), 2 vCPU, 2 GB RAM, 60 GB disk |
| Client VM | Windows 11 Pro, 50 GB disk, computer name `CL01` |
| Hypervisor | VMware Workstation Pro |
| Network | NAT, client DNS points to the domain controller |
| Domain | `lab.local` |
| Evaluation period | 180 days for Windows Server |

## Modules

| # | Module | Outcome |
|---|---|---|
| 01 | [Windows Server installation](01-windows-server-installation/README.md) | Server VM installed and signed in |
| 02 | [Network and Active Directory](02-network-and-active-directory/README.md) | Static IP, AD DS role, `lab.local` domain |
| 03 | [Users, OUs, and groups](03-users-ous-groups/README.md) | Four users in `lab.users`, `Dev` group created |
| 04 | [Folder permissions](04-folder-permissions/README.md) | `Devs` share limited to the `Dev` group |
| 05 | [Group Policy and password policy](05-group-policy-and-password-policy/README.md) | Password, lockout, and workstation controls |
| 06 | [Client VM and testing](06-client-vm-and-testing/README.md) | Domain-joined client, policies and access verified |

Follow the modules in order. Each one builds on the previous result.

## Identity model

| User | Logon | Group | Devs share |
|---|---|---|---|
| John Smith | `j.smith` | none | Denied |
| John Doe | `j.doe` | Dev | Modify |
| Robert Wilson | `r.wilson` | Dev | Modify |
| Sarah Davis | `s.davis` | none | Denied |

## Security controls applied

| Area | Setting |
|---|---|
| Minimum password length | 12 characters |
| Password complexity | Enabled |
| Password history / max age / min age | 10 / 60 days / 1 day |
| Account lockout | 5 attempts, 15-minute lockout, 15-minute reset |
| Screen lock | 15 minutes of inactivity |
| Removable storage | All access denied |
| Windows Installer | Turned off |
| Control Panel | Blocked for users |
| Built-in Administrator and Guest | Disabled by policy |

## Key lessons

- Point client DNS at the domain controller. Verify name resolution, not only IP connectivity.
- Computer Configuration policies apply to computer accounts in the OU where the GPO is linked. A link on a user OU does not cover a computer in the default `Computers` container.
- Share permissions and NTFS permissions combine. The more restrictive result wins.
- Run `gpupdate /force` and check the result with `gpresult` before you claim a policy is enforced.
- Use groups, not individual users, to assign permissions.
- Keep a recovery path for administrative access before you disable built-in accounts.

## Security notes

- This lab runs in an isolated virtual network. It is not a production baseline.
- Never commit real passwords, product keys, or personal data. Redact screenshots before you publish them.
- The example server name and IP address in the notes are specific to the original lab. Replace them with your own values.

## Repository structure

```text
windows-server-ad-lab/
|-- README.md
|-- 01-windows-server-installation/
|-- 02-network-and-active-directory/
|-- 03-users-ous-groups/
|-- 04-folder-permissions/
|-- 05-group-policy-and-password-policy/
|-- 06-client-vm-and-testing/
`-- screenshots/
```

## Author

Khalid Ebne Walid Sameer

Part of a self-directed path toward cloud engineering and security.
