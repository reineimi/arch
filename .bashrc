# ~/.bashrc | @reineimi | github.com/reineimi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Sys management
alias own='sudo chmod u=rwx'
alias copy='sudo cp -v -n -p -r'

user() {
	sudo useradd -m $1;
	passwd $1;
	sudo echo "$1 ALL=(ALL:ALL) ALL" >> /etc/sudoers;
}

# Sys config
alias conf='nano ~/.bashrc'
alias fstab='sudo nano /etc/fstab'
alias grub='sudo nano /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias setenv='sudo nano /etc/environment'
alias setloc='sudo nano /etc/locale.gen && sudo locale-gen'
alias sethost='sudo nano /etc/hostname && sudo nano /etc/hosts'
alias setctl='sudo nano /etc/sysctl.conf && sudo sysctl --load=/etc/sysctl.conf'

# Sys info
alias log='nano /var/log/pacman.log'
alias info='neofetch --ascii ~/.ascii'

# Pkg management
alias add='sudo pacman -S'
alias del='sudo pacman -Rdd'
alias wipe='sudo pacman -Rcns'
alias upd='sudo pacman -Syy'
alias fupd='sudo pacman -Syu'
alias gpg='gpg --recv-keys'

dbfix() {
	printf 'Fixing pacman...\n';
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

# Desktop management
alias ssclear='rm -rfv ~/Pictures/Screenshots/* && echo "Screenshots cleared"'
alias apps='dir /usr/share/applications'

app() {
  sudo nano /usr/share/applications/$1.desktop;
}

#Apache
srv() {
	if [ $1 == 'on' ]; then
		sudo systemctl enable httpd;
		sudo systemctl start httpd;
		echo 'Apache status: ON';
	elif [ $1 == 'off' ]; then
		sudo systemctl stop httpd;
		sudo systemctl disable httpd;
		echo 'Apache status: OFF';
	else
		sudo systemctl stop httpd;
		sudo systemctl start httpd;
		echo 'Apache status: Rebooted, ON';
	fi
}
