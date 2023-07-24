# Debloater.sh
Debloater.sh is the Android debloater script using ADB, written in bash. Debloating system bloatware aims to improve privacy and battery performance by removing unnecessary and obscure system apps.

This script actually doesn't uninstall the package, as System apps cannot be uninstalled completely without root. All system apps are installed on the /SYSTEM partition. This partition is read-only, and only the system has the right to write to it through OTA updates. However, System apps also use another partition: the /DATA partition (also called user space). All the user data and cache data are stored on this partition. All the apps you install are stored there. A factory reset from recovery is simply a wipe of the /DATA and /cache partitions. The only thing that can be done is delete its cache and all the related user data. In the end, this method doesn't save any space on your phone. A factory reset will restore all the debloated packages.

The worst that could happen is that uninstalling a core or essential system package could result in a **bootloop**, and you might need to perform a **factor reset**. In any case, you cannot brick your device with this. First, make a complete **backup**!

**Note:** You need to run this script whenever the OEM pushes an update to your phone, as some uninstalled system apps could be reinstalled by the system.

**DISCLAIMER:** I am not responsible for anything that could happen to your phone. Use at your own risk.

## Features
 - [x] Search package
 - [x] List all packages
 - [x] Uninstall package
 - [x] Bulk uninstall package
 - [ ] Restore package

## How to use?
- Make a complete backup
- Enable the developer option in your Android phone
- Turn on USB Debugging from developer settings
- Install ADB on your computer
- Run script: `bash debloat.sh`

<br>

**Credits:** @W1nst0n for [Universal Android Debloater](https://gitlab.com/W1nst0n/universal-android-debloater)
