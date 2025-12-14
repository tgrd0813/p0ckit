#cmd handler
cmd_hdlr() {
	local cmd="$1"
	shift
	local arg="$@"
	local mdl="${ld_md}"

	case "$cmd" in
		exit|quit|q)
			if [[ -z "$mdl" ]]; then
				echo "Ok quitting..."
				exit 0
			else
				ld_md=""
			fi
			;;
		help) help_menu;;
		run) run_mdl "${arg[@]}";;
		use)
			ld_md=""
			if [[ -z "${arg[@]}" ]];then
				echo "No module/script specified please specify one"
			elif [[ "${arg[@]}" ]]; then
				scrp_ld "${arg[@]}"
			fi
			;;
		search) src_mdl "${arg[@]}";;
		update) fw_upd;;
		fix) fw_fix;;
		*)
			if command -v "${cmd}" >/dev/null 2>&1; then
				$cmd $arg
			else
				echo "Unknown framwork or system command: ${cmd}"
			fi
	esac
}

#menu
menu() {
	while true; do
		echo -n "fw(${ld_md})# "
		read -e -r line
		set -- $line
		cmd="$1"
		shift
		arg="$@"


		[[ -z "$cmd" ]] && continue

		cmd_hdlr "$cmd" "${arg[@]}"

	done
}

#check if its first run
t_first_run() {
	if [ -f "$tst_file" ]; then
		echo "Test file found"
	else
		app_chk "${1}"
	fi

	if [[ -f "${mnfstf}" ]];
		
}

#check if apps exists
app_chk() {

	echo "Testing for apps"
	
	if [[ "$1" == "--no-test" ]]; then
		echo "${0} runned with ${1} so not testing if apps are instaled"
	elif [[ "$1" == "--mo-test" && -f "$tst_file" ]]; then
		echo "${0} runned with ${1}, the test was already done [test file found: ${tst_file}]"
	else
		for app in "${apps[@]}"; do
			if which "$app" &>/dev/null; then
				((cntr++))
				echo "$app is installed"
			else
				echo "$app is not installed"
				echo "Do you want to install $app (y/N)"
				read -p "=> " -i "n" ans
				if [[ "$ans" = "y" ]]; then
					sudo pacman -S "$app"
					((cntr++))
				else
					echo "Ok how you say"
				fi
			fi
			sleep 1
		done
	fi
	if [[ "$cntr" -ge "$req" && -z "$1" ]]; then
		echo "Testing done all needed apps are installed($cntr/$req)"
		touch "$tst_file"
	elif [[ "$1" ]]; then
		echo ""
	else
		echo "Something went wrong some apps are not installed($cntr/$req)"
	fi

}

#help menu
help_menu() {
	echo "Help menu:"
	echo "help -- This help menu"
	echo "use -- Use a module/script (modules by name | scritps by path)"
	echo "fix -- Fix the tool if something is broken (if you have made chages to the tool they will not be saved)"
	echo "update -- Update the tool to the lates release"
	echo "serach -- Search a module/script by name or path"
	echo "exit/quit -- to quit the script"

}
