cp -v baupd.service /etc/systemd/system/;
cp -v baupd.timer /etc/systemd/system/;
systemctl enable --now baupd.service;
systemctl enable --now baupd.timer;
systemctl start baupd.timer;
printf "\n[!] Tip: This script runs daily. Make sure to enable it in your spare time.\n\n"
