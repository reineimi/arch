systemctl stop --user colormode.timer;
systemctl stop --user colormode.service;
systemctl disable --user colormode.service;
systemctl disable --user colormode.timer;
rm -v "${HOME}"/.config/systemd/user/colormode.lua;
rm -v "${HOME}"/.config/systemd/user/colormode.service;
rm -v "${HOME}"/.config/systemd/user/colormode.timer;
