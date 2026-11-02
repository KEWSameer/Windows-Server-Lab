# 01 | Windows Server 2022 Installation

Install Windows Server 2022 with the Desktop Experience (GUI) in a VMware virtual machine. This is the base for every later module in the lab.

## Objective

Build a working Windows Server 2022 VM that you log in to as Administrator.

## Requirements

| Item | Value |
|---|---|
| Hypervisor | VMware Workstation Pro (Oracle VirtualBox also works) |
| ISO | Windows Server 2022 Evaluation from Microsoft (free, no sign-up, 180-day evaluation) |
| Edition | Windows Server 2022 Datacenter Evaluation (Desktop Experience) |
| vCPU | 2 cores |
| Memory | 2 GB |
| Disk | 60 GB |

VMware Workstation Pro is free for personal use, but you need to create an account to download it. VirtualBox is open source and needs no account.

## Steps

### 1. Create the virtual machine

1. Install VMware Workstation Pro from the downloaded installer.
2. Open VMware and select **Create a New Virtual Machine**.
3. Choose **Typical** configuration and select Next.
4. Select **I will install the operating system later**. This avoids unwanted automatic installs and saves troubleshooting time.
5. Set the guest operating system to **Microsoft Windows** and the version to **Windows Server 2022**.
6. Name the VM `Windows Server 2022`. Keep the default location.
7. Keep the 60 GB disk size and select **Split virtual disk into multiple files**.
8. Select **Customize Hardware** and set:
   - Memory: 2 GB
   - Processors: 2 cores
   - New CD/DVD: **Use ISO image file**, then browse to the Windows Server 2022 ISO
9. Select Close, then Finish.

To change the disk size later, open the VM settings and edit the hard disk entry.

### 2. Install the operating system

1. Select **Power on this virtual machine**.
2. Press any key when the "Press any key to boot from CD or DVD" prompt appears. The window is short. If you miss it, restart the VM with the play button at the top left.
3. Choose the language, time format, and keyboard layout, then select Next and Install Now.
4. Select the fourth option: **Windows Server 2022 Datacenter Evaluation (Desktop Experience)**.
5. Accept the license terms.
6. Choose **Custom: Install Windows only (advanced)** for a fresh installation.
7. Select the 60 GB disk and select Next.
8. Wait for the installation to finish. The VM restarts several times.

### 3. Set the Administrator password

1. Enter a strong password for the built-in Administrator account and retype it.
2. Select Finish.
3. Send **Ctrl + Alt + Delete** to the VM from the VMware menu bar (VM > Send Ctrl+Alt+Del).
4. Enter the password and sign in.

![Send Ctrl+Alt+Del from the VMware menu](../screenshots/ctrl_alt_del.png)

## Verification

- The Server Manager dashboard opens after sign-in.
- Under System Properties, the edition shows Windows Server 2022 Datacenter Evaluation.

## Troubleshooting

| Problem | Fix |
|---|---|
| VM skips the installer and boots to a black screen | Restart the VM and press a key quickly when prompted |
| ISO not detected | Open VM settings, select CD/DVD, and confirm "Connect at power on" is checked |
| Installer shows only Server Core options | Restart the install and pick the option marked Desktop Experience |

## Next

[02 Network configuration and Active Directory](../02-network-and-active-directory/README.md)
