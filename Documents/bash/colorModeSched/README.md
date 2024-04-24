# General info
This is a simple Lua script that executes 2 commands to change color mode for the current user, 
running on schedule according to current <ins>**season**</ins> and <ins>**time**</ins>.<br>
Other files in the folder are **systemd** units and installation (**bash**) scripts.

# Usage
### Note: It's recommended to run it at/after **:30
Just `cd` to this folder and run the following command as current user:
```bash
bash enable.sh
```

## For any other distro/OS
Since this is a Lua script - any other system can run it.<br>
Just change the commands in the `exec` table accordingly, then include the script in your preferred scheduler.

# Requirements
lua *(programming language)*
