#!/bin/sh
# https://github.com/reineimi/arch/blob/x/.bashrc

alert() {
	title=${2:-'Information'};
	zenity --info --text $1 --title $title;
}

tags() {
	taglist=();
	for i in $(exiftool -P $1 -p '$keywords'); do
		taglist+=$i;
	done;
	printf "%s" "${taglist[@]}";
}

alert $(tags $1) 'Tags';
