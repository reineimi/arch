mkdir ~/.config/systemd
mkdir ~/.config/systemd/user
cp -v aupd.service ~/.config/systemd/user/;
cp -v aupd.timer ~/.config/systemd/user/;
systemctl enable --user --now aupd.service;
systemctl enable --user --now aupd.timer;
systemctl start --user aupd.timer;
echo "[!] Tip: This script runs daily. Make sure to enable it in your spare time."
