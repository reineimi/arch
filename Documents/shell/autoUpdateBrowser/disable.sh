systemctl stop baupd.timer;
systemctl stop baupd.service;
systemctl disable baupd.service;
systemctl disable baupd.timer;
rm -v /etc/systemd/system/baupd.service;
rm -v /etc/systemd/system/baupd.timer;
