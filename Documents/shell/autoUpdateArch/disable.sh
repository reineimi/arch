systemctl stop --user aupd.timer;
systemctl stop --user aupd.service;
systemctl disable --user aupd.service;
systemctl disable --user aupd.timer;
rm -v ~/.config/systemd/user/aupd.service;
rm -v ~/.config/systemd/user/aupd.timer;
