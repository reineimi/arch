#!/bin/sh

# Compress image(s)
# https://github.com/reineimi/arch/blob/x/.bashrc
compr() {
	if [ "$*" == "" ]; then
		echo 'Usage: compr [options]
		Options:
			q=quality (int)
			f=filename (str)
			e=extension (str)
			v=verbose (true)
			d=delete_originals (true)

		Examples:
			(Compress png to jpg):
				compr f=test.png e=jpg q=95
			(Recursive batch compression to webp):
				compr e=webp q=85 v=1 d=1
		';
	fi;

	# Initial command line
	cmd=('magick mogrify -define preserve-timestamp=true');

	# (Options) KEY=VAL pairs
	declare -A args;

	for ARG in "$@"; do
		KEY=$(echo $ARG | cut -f1 -d=);
		KEY_LEN=${#KEY};
		VAL="${ARG:$KEY_LEN+1}";
		args["$KEY"]="$VAL";
	done;

	if [[ -v "args[v]" ]]; then
		echo verb = true;
		cmd+=(" -verbose");
	fi;

	if [[ -v "args[q]" ]]; then
		echo qual = ${args[q]};
		cmd+=(" -quality ${args[q]}");
	fi;

	if [[ -v "args[e]" ]]; then
		echo ext = ${args[e]};
		cmd+=(" -format ${args[e]}");
	fi;

	echo '';

	if [[ ! -v "args[f]" ]]; then
		formats=(jpg jpeg png webp tiff);
		for ext in ${formats[@]}; do
			for path in $(find ~+ -name "*.$ext"); do
				$(IFS=\ ;echo "${cmd[*]}") $path;
				if [[ -v "args[d]" ]]; then
					rm -v $path;
				fi;
				echo '';
			done;
		done;
	else
		file="$(readlink -f "${args[f]}")";
		$(IFS=\ ;echo "${cmd[*]}") $file;
		if [[ -v "args[d]" ]]; then
			rm -v $file;
		fi;
		echo '';
	fi;
}

compr f=$1 q=95 e=jpg d=1
