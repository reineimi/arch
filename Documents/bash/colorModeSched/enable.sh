mkdir ~/.config/systemd
mkdir ~/.config/systemd/user
cp -v colormode.lua "${HOME}"/.config/systemd/user/;
cp -v colormode.service "${HOME}"/.config/systemd/user/;
cp -v colormode.timer "${HOME}"/.config/systemd/user/;
systemctl enable --user --now colormode.service;
systemctl enable --user --now colormode.timer;
systemctl start --user colormode.timer;
