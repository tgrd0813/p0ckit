#func to check the hash value and if different then fix broken/corupted files
fw_fix() {
	local crnth="core/.crntmnfst.txt"
	find core -type f ! -name "${crnth}"! -name "${mnfstf}" -exec sha256sum {} + | sort > ${crnth}
	chngs="$(diff $mnfstf $crnth)"
	if [[ -n "$chngs" ]]; then
		echo "There is something wrong"
		echo "Fixing broken files"
		echo "This will reset all core files to the latest version"
		read -e -p "Do you want to continue(Y/n) " -i "y" ans
		if [[ "${ans}" == ^[Nn]$ ]]; then
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
