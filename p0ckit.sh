#!/bin/bash

#variables
cntr=0
req=5
tst_file=".ntfr01"
md_path="modules/"
index_path="${md_path}index.txt"

#module/script runner
run_mdl() {
	local mdl="${md_path}${ld_md}"
	local arg="${arg[@]}"

	bash "${mdl}" "${arg[@]}"

}

#func for searching the index file for modules/scripts
src_mdl() {
	local md_name="$1"
	
	echo "$(grep "^$md_name" "$index_path")"
}


#module/script loader
scrp_ld() {
	local script="$1"
	
	#to see if the script actually exists
	entry="$(grep -E "$script" "$index_path")"

	if [ -z "$entry" ]; then
		echo "Script/Module doesn't exist"
	fi

	path="$(echo "$entry" | awk '{ print $2 }')"

	if [ -z "$path" ]; then
		echo "Script/Module is indexed but not found at $path"
	fi

	ld_md="$path"

}


#cmd handler
cmd_hdlr() {
	local cmd="$1"
	shift
	local arg="$@"

	case "$cmd" in
		exit|quit|q)
			exit 0
			;;
		help)
			help_menu
			;;
		run)
			run_mdl "${arg[@]}"
			;;
		use)
			scrp_ld "${arg[@]}"
			;;
		search)
			src_mdl "${arg[@]}"
			;;
		*)
			echo "Not a real $cmd or ${arg[@]}"
	esac
}


#help menu
help_menu() {
	echo Help menu:
	echo help -- This help menu
	echo exit/quit -- to quit the script

}

#menu
menu() {
	while true; do
		echo -n "fw(${ld_md})# "
		read -r cmd arg
		
		[[ -z "$cmd" ]] && continue

		cmd_hdlr "$cmd" "${arg[@]}"

	done
}


#check if its first run
t_first_run() {
	if [ -f "$tst_file" ]; then
		echo "Test file found"
	else
		app_chk
	fi
}

#check if apps exists
app_chk() {
	apps=("wireshark" "git" "python" "nmap" "aircrack-ng")

	echo "Testing for apps"
		
	for app in "${apps[@]}"; do
		if which "$app" &>/dev/null; then
			((cntr++))
			echo "$app is installed"
		else
			echo "$app is not installed"
			echo "Do you want to install $app (y/N)"
			read -p "=> " -i "n" ans
			if [ "$ans" = "y" ]; then
				sudo pacman -S "$app"
			else
				echo "Ok how you say"
			fi
		fi
		sleep 1
	done
	
	if [ "$cntr" -ge "$req" ]; then
		echo "Testing done all apps are installed($cntr/$req)"
		touch "$tst_file"
	else
		echo "Something went wrong some apps are not installed($cntr/$req)"
	fi

}

if [ $USER != "root" ]; then
	echo "Run as root!"
	exit 0
fi

t_first_run
menu

