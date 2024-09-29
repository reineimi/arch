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
	echo 'Memory to free:' `du -h /var/cache/pacman/pkg/`;
	sudo rm -f /var/cache/pacman/pkg/*;
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

# Zenity dialogs
prompt() { zenity --entry --title "$1"; }
alert() {
	title=${2:-'Information'};
	zenity --info --text $1 --title $title;
}

	# OTHER

alias ggamma='~/Documents/ggamma.py'
alias lu='clear; lua /media/Dev/lua/test.lua'
alias tgbot='clear; node ~/Documents/tgbot/tgbot.js';
alias flan='nano ~/.config/geany/colorschemes/flan.conf';
alias nextjs='npx create-next-app@latest';
alias bkup='lua ~/Documents/shell/backup.lua';
alias bt='sh ~/Documents/shell/MISC/ditoo.sh';

pixv() { cp -rvpn ~/Downloads/Pixiv_new/* /media/Pixiv; }

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

# Search for files that contain specified <string>
search() {
	if [ "$*" == "" ]; then
		echo 'Usage: search "<what>" <extension>';
		return 1;
	else
		find . -name \*.$2 -print0 | xargs -0 grep -nF "$1";
	fi
}

# Compress image(s)
compr() {
	if [ "$*" == "" ]; then
	echo 'Compress image(s)
	Usage: compr [options]

	Options:
	 (integer)
		q=quality
		s=size (KB) !(Does not work currently)!
		t=threshlod_size (KB) (Minimal required size)

	 (string)
		f=filename
		e=extension
		r=resize (100 = Width) (x100 = Height) (100x100 = All)

	 (binary bool)
		v=verbose
		d=delete_originals

	Examples:
		(Compress png to jpg):
			compr f=test.png e=jpg q=95

		(Recursive batch compression to webp):
			compr e=webp q=85 v=1 d=1
		
		(Recursive batch compression for files larger than 1MB):
			compr q=95 t=1000
	';
	return 1;
	fi;

	cmd=('magick mogrify -define preserve-timestamp=true');
	declare -A args;

	for ARG in "$@"; do
		KEY=$(echo $ARG | cut -f1 -d=);
		KEY_LEN=${#KEY};
		VAL="${ARG:$KEY_LEN+1}";
		args["$KEY"]="$VAL";
	done;

	if [[ -v "args[v]" ]]; then
		echo verbose = true;
		cmd+=(" -verbose");
	fi;

	if [[ -v "args[q]" ]]; then
		echo quality = ${args[q]};
		cmd+=(" -quality ${args[q]}");
	fi;

	if [[ -v "args[e]" ]]; then
		echo extension = ${args[e]};
		cmd+=(" -format ${args[e]}");
	fi;

	if [[ -v "args[d]" ]]; then
		echo overwrite = true
	fi;

	if [[ -v "args[r]" ]]; then
		echo resize = ${args[r]};
		cmd+=(" -resize ${args[r]}");
	fi;

	if [[ -v "args[s]" ]]; then
		echo size = ${args[s]};
	fi;

	if [[ -v "args[t]" ]]; then
		echo threshlod_size = ${args[t]};
	fi;

	echo '';

	if [[ ! -v "args[f]" ]]; then
		formats=(jpg jpeg png webp tiff);
		for ext in ${formats[@]}; do
			for path in $(find ~+ -name "*.$ext"); do
				if [[ -v "args[t]" ]]; then
					if (( $(du $path | cut -f 1) >= ${args[t]} )); then
						$(IFS=\ ;echo "${cmd[*]}") $path;
					fi;
				else
					$(IFS=\ ;echo "${cmd[*]}") $path;
				fi;

				if [[ $path != *.${args[e]} ]] && [[ -v "args[d]" ]]; then
					rm -v $path;
				fi;
			done;
		done;

	else

		file="$(readlink -f "${args[f]}")";

		if [[ -v "args[t]" ]]; then
			if (( $(du $file | cut -f 1) >= ${args[t]} )); then
				$(IFS=\ ;echo "${cmd[*]}") $file;
			fi;
		else
			$(IFS=\ ;echo "${cmd[*]}") $file;
		fi;

		if [[ ${args[f]} != *.${args[e]} ]] && [[ -v "args[d]" ]]; then
			rm -v $file;
		fi;
	fi;
}

# Add EXIF tag(s) to the image:  tag img.jpg some thing
tag() {
	file="$(readlink -f $1)";
	for tag in "${@:2}"; do
		exiftool -P -overwrite_original -keywords+=$tag $file;
	done;
}

# Get a list of EXIF tags from the image
tags() {
	taglist=();
	for i in $(exiftool -P $1 -p '$keywords'); do
		taglist+=$i;
	done;
	printf "%s" "${taglist[@]}";
}

# Find images with EXIF tag; optionally copy them to DIR
tagf() {
	if [ "$*" == "" ]; then
	echo 'Get images with EXIF tag; optionally copy them to DIR
	Usage:
		ftag my_tag
		ftag my_tag ~/Pictures/my_tag
	';
	return 1;
	fi;

	files=();
	for file in "$(exiftool -P -if '$keywords =~ /'$tag'/' -p '$directory/$filename' -r .)"; do
		files+=("$(readlink -f $file)");
	done;

	if [ "$2" ]; then
		mkdir -p $2;
		for file in ${files[@]}; do
			cp -vpn $file $2;
		done;
	else
		echo files: $(IFS=\ ;echo "${files[*]}");
	fi;
}

# Burn Windows ISO images
winiso() {
	if [ "$*" == "" ]; then
		echo 'Usage: winiso <.iso file> </dev/sdX>';
		return 1;
	else
		woeusb --device $1 $2;
	fi
}

# Notes (bash syntax)
# (var = $1 || 'test') --> var=${1:-'test'};
# (array concat) --> $(IFS=\ ;echo "${arr[*]}")
