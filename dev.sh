#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#based_on   :https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
#			      :https://stackoverflow.com/questions/1537673/how-do-i-forward-parameters-to-other-command-in-bash-script
#           :https://stackoverflow.com/questions/33961229/how-to-source-additional-file-when-launching-bash
#           :https://stackoverflow.com/questions/29231639/bash-completion-from-another-completion
#           :http://linuxcommand.org/lc3_wss0140.php
#           :https://stackoverflow.com/questions/15454174/how-can-a-shell-function-know-if-it-is-running-within-a-virtualenv
#           :http://kvz.io/blog/2013/11/21/bash-best-practices/
#describtion:This file is meant to be run as "rcfile" while starting bash console `bash --rcfile ${THIS_FILE_PATH}`
#           :Optionally you can just source it in running shell `source ${THIS_FILE_PATH}`
#           :Worst case encapsulated commands can be called directly `${THIS_FILE_PATH} ${COMMAND}`
#           :It contains autocompletion and default scripts used in project

# Set magic variables for current file & dir
__root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export __dev_root="$__root"
#==============================================================================


if [[ -n "${1:-}" ]]; then
	# if argument given use it as function call
	"$__root/src/${1}.sh" "${@:2}"
else
	# otherwise sourcing
	dev () {
		__dev_scripts=$(find "$__root/src" -maxdepth 1 -type f -iname "*.sh" -execdir sh -c 'printf "%s " "${0%.*}"' {} ';')
		if [[ -z $1 ]]; then
			selected_script=$("$__root/utils/sentaku.sh" "Choose the option to run:" "${__dev_scripts}")
		else
			selected_script=$1
		fi
		if [[ " ${__dev_scripts[@]} " =~ "${selected_script}" ]]; then
			"$__root/src/${selected_script}.sh" "${@:2}"
		else
			echo "Unknown command ${selected_script}."
			"$__root/src/help.sh"
		fi
	}
	_dev_completions() {
		if [ ${#COMP_WORDS[@]} -gt 2 ]; then
			source "$__root/src/${COMP_WORDS[1]}.sh" _completions "${COMP_WORDS[@]:2}"
		else
      words="activate common database help kill local port-forward python self_check install_dependencies git	update"
#			words=$(find "$__root/src" -maxdepth 1 -type f -iname "*.sh" -execdir sh -c 'printf "%s " "${0%.*}"' {} ';')
      suggestions=($(compgen -W "${words}" "${COMP_WORDS[1]}"))
		fi
		if [ "${#suggestions[@]}" == "1" ]; then
			if [[ -z "${suggestions[0]}" ]]; then
				return
			fi
			# if there's only one match, we remove the command literal
			# to proceed with the automatic completion of the number
			local number=$(echo ${suggestions[0]/%\ */})
			COMPREPLY=("$number")
		else
			# more than one suggestions resolved,
			# respond with the suggestions intact
			COMPREPLY=("${suggestions[@]}")
		fi
	}
	complete -F _dev_completions dev
fi
