#!/bin/bash

#variables
cntr=0
req=5
file="/home/tgrd/pen/bash/.ntfr01"

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
			run_mdl "$arg[@]"
			;;
		use)
			scrp_ld "$arg[@]"
			;;
		search)
			src_scrp "$arg[@]"
			;;
		*)
			echo "Not a real $cmd or $arg[@]"
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
		echo -n "fw# "
		read -r cmd arg
		set -- $line
		
		cmd_hdlr "$cmd" "$arg[@]"

	done
}


#check if its first run
t_first_run() {
	if [ -f "$file" ]; then
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
		touch "$file"
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

