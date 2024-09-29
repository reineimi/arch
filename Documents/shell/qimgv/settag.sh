#!/bin/sh
# https://github.com/reineimi/arch/blob/x/.bashrc

prompt() { zenity --entry --title "$1"; }

tag() {
	file="$(readlink -f $1)";
	args=();
	for tag in "${@:2}"; do
		args+=("-keywords+=$tag ");
	done;
	exiftool -P -overwrite_original $(IFS=\ ;echo "${args[*]}") $file;
}

tag $1 $(prompt 'Tags (Keywords):');
