#func to check the hash value and if different then fix broken/corupted files
fw_fix() {
	local crnth="${script_hm}/core/.crntmnfst.txt"
	find core -type f ! -name ".crntmnfst.txt" ! -name "manifest.txt" -exec sha256sum {} + | sort > ${crnth}
	chngs="$(diff $mnfstf $crnth)"
	if [[ -n "$chngs" ]]; then
		echo "There is something wrong"
		echo "Fixing broken files"
		echo "This will reset all core files to the latest version"
		read -e -p "Do you want to continue(Y/n) " ans
		if [[ "${ans}" == "n" ]]; then
			echo "Ok not fixing the files"
		else	
			git fetch origin
			git checkout origin/main -- core/
		fi
	else
		echo "All files are good"
	fi
	rm -f "$crnth"
}

#func to update/fix the cli
fw_upd() {
	echo "Updating ${fw_name} please wait..."
	sleep 1
	git pull origin main

}

#func to create manifest so this shit actually wokrs
crt_mnfst() {
	if [[ -f "${mnfstf}" ]]; then
		echo Manifest already exists
		read -p "Are you sure you want to recreate the manifest(y/N)" -i "n" ans
		if [[ "$ans" == "y" ]]; then
			echo Ok creating manifest
			cp $mnfstf manifest.old
			find core -type f ! -name "manifest.txt" -exec sha256sum {} + | sort > "${mnfstf}"
			sleep 1
			echo manifest created
		else
			echo OK not creating manifest
		fi
	else
		echo Ok creating manifest
		find core -type f ! -name "manifest.txt" -exec sha256sum {} + | sort > "${mnfstf}"
		sleep 1
		echo manifest created
	fi
}
