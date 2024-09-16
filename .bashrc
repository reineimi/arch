# ~/.bashrc
# @reineimi | github.com/reineimi

	# GENERAL SETTINGS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '
alias ls='ls --color=auto'
alias grep='grep --color=auto'
unset HISTFILE

	# SYSTEM MANAGEMENT

alias own='sudo chmod u=rwx'
alias copy='cp -rvpn'
alias freeram='sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches'

adduser() {
	sudo useradd -m $1;
	passwd $1;
	sudo echo "$1 ALL=(ALL:ALL) ALL" >> /etc/sudoers;
}

uname() {
	sudo usermod -l $1 $2;
	usermod -d /home/$1 -m $2;
	sudo echo "$1 ALL=(ALL:ALL) ALL" >> /etc/sudoers;
}

restart() {
	sudo systemctl restart $1;
}

	# SYSTEM CONFIG

alias conf='nano ~/.bashrc'
alias fstab='sudo nano /etc/fstab'
alias grub='sudo nano /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias setenv='sudo nano /etc/environment'
alias setloc='sudo nano /etc/locale.gen && sudo locale-gen'
alias sethost='sudo nano /etc/hostname && sudo nano /etc/hosts'
alias setctl='sudo nano /etc/sysctl.conf && sudo sysctl --load=/etc/sysctl.conf'

	# SYSTEM INFO

alias log='nano /var/log/pacman.log'
alias btw='neofetch --ascii ~/.ascii'

	# PACKAGE MANAGEMENT

alias add='sudo pacman -Syy'
alias del='sudo pacman -Rdd'
alias wipe='sudo pacman -Rcns'
alias upd='sudo pacman -Syy'
alias fupd='sudo pacman -Syu'
alias key='gpg --recv-keys'
alias pkgs='sudo pacman -Qn'
alias untar='tar -xvf'

cleanup() {
	echo 'Cleaning up pacman cache...';
	sudo rm -f /var/cache/pacman/pkg/*;
	echo 'Total memory freed:' `du -h /var/cache/pacman/pkg/`;
}

dbfix() {
	echo 'Fixing pacman...';
	sudo rm /var/lib/pacman/db.lck;
	sudo pacman -Syy;
	sudo pacman -S archlinux-keyring;
}

aur() {
	cd; mkdir tempgit; cd tempgit;
	git clone https://aur.archlinux.org/$1.git;
	cd $1 && makepkg -si;
	echo 'Remove "tempgit"? (y/N)';
	read yn;
	if [ "$yn" == 'y' ]; then
		cd && rm -rf tempgit;
	fi
}

	# NETWORK MANAGEMENT

alias bans='sudo iptables -L -n --line'

ban() {
	sudo iptables -A INPUT -s $1 -j REJECT;
	sudo iptables -A INPUT -s $1 -j DROP;
	sudo iptables -A FORWARD -s $1 -j REJECT;
	sudo iptables -A FORWARD -s $1 -j DROP;
	#sudo ipset add blacklist $1;
}

unban() {
	sudo iptables -D INPUT -s $1 -j REJECT;
	sudo iptables -D INPUT -s $1 -j DROP;
	sudo iptables -D FORWARD -s $1 -j REJECT;
	sudo iptables -D FORWARD -s $1 -j DROP;
	#sudo ipset del blacklist $1;
}

	# DESKTOP MANAGEMENT

alias ldm='sudo nano /etc/lightdm/lightdm.conf'
alias useldm='systemctl disable gdm && systemctl enable lightdm && reboot'
alias usegdm='systemctl disable lightdm && systemctl enable gdm && reboot'
alias sscl='rm -rfv ~/Pictures/Screenshots/* && echo "Screenshots cleared"'
alias apps='dir /usr/share/applications'

app() {
	sudo nano /usr/share/applications/$1.desktop;
}

syncdir() {
	echo 'Syncing directories...';
	read -p "Source dir: " _src;
	read -p "Destination dir: " _dest;
	sudo rsync -axHAWXS --numeric-ids --info=progress2 $_src $_dest;
}

	# OTHER

alias ggamma='~/Documents/ggamma.py'
alias lu='clear; lua /media/Dev/lua/test.lua'
alias tgbot='clear; node ~/Documents/tgbot/tgbot.js';
alias flan='nano ~/.config/geany/colorschemes/flan.conf';
alias nextjs='npx create-next-app@latest';
alias bkup='lua ~/Documents/shell/backup.lua';
alias bt='sh ~/Documents/shell/MISC/ditoo.sh';

pixv() {
	cp -rvpn ~/Downloads/Pixiv_new/* /media/Pixiv;
}

tgclear() {
	rm -f ~/Downloads/Telegram\ Desktop/*;
	rm -rf ~/.local/share/TelegramDesktop/tdata/user_data/*;
	echo 'Telegram cache cleared';
}

# Apache server
srv() {
	if [[ $1 == 'on' ]]; then
		sudo systemctl enable httpd;
		sudo systemctl start httpd;
		echo 'Apache status: ON';
	elif [[ $1 == 'off' ]]; then
		sudo systemctl stop httpd;
		sudo systemctl disable httpd;
		echo 'Apache status: OFF';
	else
		sudo systemctl stop httpd;
		sudo systemctl disable httpd;
		sudo systemctl enable httpd;
		sudo systemctl start httpd;
		sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches;
		echo 'Apache status: Cache cleared, Rebooted, ON';
	fi
}

# Recursively compress all images to .webp
webpr() {
	for path in $(find . -name '*.png' -or -name '*.jpg'); do
		echo "$path --> ${path%.*}.webp";
		cwebp -q 85 $path -o ${path%.*}.webp;
	done

	read -p "Delete original files? (y/N): " a;
	if [[ $a == "y" ]]; then
		for path in $(find . -name '*.png' -or -name '*.jpg'); do
			rm -v $path;
		done
	fi
}

# Burn Windows ISO images
winiso() {
	if [ "$*" == "" ]; then
		echo 'Usage: winiso (.iso file) (/dev/sd*)';
	else
		woeusb --device $1 $2;
	fi
}
