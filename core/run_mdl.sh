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

#module/script runner
run_mdl() {
	local mdl="${md_path}${ld_md}"
	local arg="${arg[@]}"

	bash "${mdl}" "${@}"

}

src_mdl() {
	local md_name="$1"
	
	echo "$(grep "^$md_name" "$index_path")"
}
