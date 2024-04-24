`~/Documents/bash/autoUpdateArch`
# Arch Linux automatic update scheduler
A simple **daily** schedule for `sudo pacman -Syu` with desktop notification.<br>
Just `cd` to this folder and run the following command as current user:
```
bash enable.sh
```
Note that this script will prompt a password confirmation dialogue, therefore you must enable it at the most convenient for you time.
# Requirements
[polkit](https://archlinux.org/packages/extra/x86_64/polkit/)
