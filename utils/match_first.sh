#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
if [ "${#suggestions[@]}" == "1" ]; then
	# if there's only one match, we remove the command literal
	# to proceed with the automatic completion of the number
	number=$(echo ${suggestions[0]/%\ */})
	COMPREPLY=("$number")
else
	# more than one suggestions resolved,
	# respond with the suggestions intact
	COMPREPLY=("${suggestions[@]}")
fi
