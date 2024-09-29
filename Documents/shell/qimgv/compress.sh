#!/bin/sh
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

compr f=$1 q=95 e=jpg d=1;
