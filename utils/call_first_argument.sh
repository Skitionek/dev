#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
__sentaku="$__dev_root/utils/sentaku.sh"
#==============================================================================

selected=$1
if [[ -n "${functions}" ]]; then
	options=$(echo "${functions[@]}" | tr ' ' '\n' | sort | uniq)
	if [[ -z "${1:-}" ]]; then
		selected=$("$__sentaku" "Choose one of options:" "${options[@]}")
	else
		if [[ ! " ${options[@]} _completions " =~ "${1}" ]]; then
			echo "$options"
			echo "Unknown command ${1}."
			help
		fi
	fi
fi

if [[ -z "${selected:-}" ]]; then
	echo "No enough arguments provided"
	help
else
	"$selected" "$@"
fi
