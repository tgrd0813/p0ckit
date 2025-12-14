#!/bin/bash

#variables
mnfstf="manifest.txt"
gtmnfst="$(find . -type f ! -path "./.git/" ! -name "${mntfstf}" -exec sha256sum {} + | sort > "${mnfstf}")"
fw_name="p0ckit"
apps=("wireshark" "git" "python" "nmap" "aircrack-ng")
nt="$1"
cntr=0
req=5
hm_path="/home/${USER}/p0ckit/"
tst_file="${hm_path}.ntfr01"
md_path="${hm_path}modules/"
index_path="${md_path}index.txt"

#module/script runner
run_mdl() {
	local mdl="${md_path}${ld_md}"
	local arg="${arg[@]}"

	bash "${mdl}" "${@}"

}

#func for searching the index file for modules/scripts
src_mdl() {
	local md_name="$1"
	
	echo "$(grep "^$md_name" "$index_path")"
}

#func to update/fix the cli
fw_upd() {
	echo "Updating ${fw_name} please wait..."
	sleep 1
	git pull origin main

}

#module/script loader
scrp_ld() {
	local script="$1"
	
	#to see if the script actually exists
	entry="$(grep -F "$script" "$index_path")"

	if [ -z "$entry" ]; then
		echo "Script/Module doesn't exist"
		return 1
	fi

	path="$(echo "$entry" | awk '{ print $2 }')"
	rpath="${md_path}${path}"

	if [[ -z "$rpath" ]]; then
		echo "Script/Module is indexed but path found empty: ${path}"
		return 1
	elif [[ ! -f "$rpath" ]]; then
		echo "Script/Module is indexed but not found at $path"
		return 1
	else
		ld_md="${path}"
	fi


}


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

#func for banner/s (planning to add more)
banner() {
	echo "                                                                                                            
                                                                                                            
                         000000000                         kkkkkkkk             iiii          tttt          
                       00:::::::::00                       k::::::k            i::::i      ttt:::t          
                     00:::::::::::::00                     k::::::k             iiii       t:::::t          
                    0:::::::000:::::::0                    k::::::k                        t:::::t          
ppppp   ppppppppp   0::::::0   0::::::0    cccccccccccccccc k:::::k    kkkkkkkiiiiiiittttttt:::::ttttttt    
p::::ppp:::::::::p  0:::::0     0:::::0  cc:::::::::::::::c k:::::k   k:::::k i:::::it:::::::::::::::::t    
p:::::::::::::::::p 0:::::0     0:::::0 c:::::::::::::::::c k:::::k  k:::::k   i::::it:::::::::::::::::t    
pp::::::ppppp::::::p0:::::0 000 0:::::0c:::::::cccccc:::::c k:::::k k:::::k    i::::itttttt:::::::tttttt    
 p:::::p     p:::::p0:::::0 000 0:::::0c::::::c     ccccccc k::::::k:::::k     i::::i      t:::::t          
 p:::::p     p:::::p0:::::0     0:::::0c:::::c              k:::::::::::k      i::::i      t:::::t          
 p:::::p     p:::::p0:::::0     0:::::0c:::::c              k:::::::::::k      i::::i      t:::::t          
 p:::::p    p::::::p0::::::0   0::::::0c::::::c     ccccccc k::::::k:::::k     i::::i      t:::::t    tttttt
 p:::::ppppp:::::::p0:::::::000:::::::0c:::::::cccccc:::::ck::::::k k:::::k   i::::::i     t::::::tttt:::::t
 p::::::::::::::::p  00:::::::::::::00  c:::::::::::::::::ck::::::k  k:::::k  i::::::i     tt::::::::::::::t
 p::::::::::::::pp     00:::::::::00     cc:::::::::::::::ck::::::k   k:::::k i::::::i       tt:::::::::::tt
 p::::::pppppppp         000000000         cccccccccccccccckkkkkkkk    kkkkkkkiiiiiiii         ttttttttttt  
 p:::::p                                                                                                    
 p:::::p                                                                                                    
p:::::::p                                                                                                   
p:::::::p                                                                                                   
p:::::::p                                                                                                   
ppppppppp"

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
}

#func to check the hash value and if different then fix broken/corupted files
fw_fix() {
	local crnth=".crntmnfst.txt"
	find . -type f ! -path "./.git/" ! -name "${mnfstf}" -exec sha256sum {} + | sort > ${crnth}
	chngs="$(diff $mnfstf $crnth)"
	if [[ -n "$chngs" ]]; then
		echo "There is something wrong"
		echo "Fixing broken files"
		echo "This will reset all files to the latest version"
		read -e -n "Do you want to continue(Y/n) " -i "y" ans
		if [[ "${ans}" == "n" ]]; then
			echo "Ok not fixing the files"
		else
			git fetch origin
			git reset --hard origin/main
		fi
	else
		echo "All files are good"
	fi
	rm ${crnth}
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

#if [ $USER != "root" ]; then
#	echo "Run as root!"
#	exit 0
#fi

banner
t_first_run "${1}"
menu
