#!/bin/sh
# https://github.com/reineimi/arch/blob/x/.bashrc

prompt() { zenity --entry --title "$1"; }

tag() {
	file="$(readlink -f $1)";
	for tag in "${@:2}"; do
		exiftool -P -overwrite_original -keywords+=$tag $file;
	done;
}

tag $1 $(prompt 'Tags (Keywords):');
