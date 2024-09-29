#!/bin/sh

# Compress image(s)
# https://github.com/reineimi/arch/blob/x/.bashrc
compr() {
	cmd=('magick mogrify -define preserve-timestamp=true');
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
				if [[ -v "args[d]" ]] && [[ ${args[f]} != *\.${args[e]} ]]; then
					rm -v $path;
				fi;
				echo '';
			done;
		done;
	else
		file="$(readlink -f "${args[f]}")";
		$(IFS=\ ;echo "${cmd[*]}") $file;
		if [[ -v "args[d]" ]] && [[ ${args[f]} != *\.${args[e]} ]]; then
			rm -v $file;
		fi;
		echo '';
	fi;
}

compr f=$1 q=95 e=jpg d=1
