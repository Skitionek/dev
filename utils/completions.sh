#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#==============================================================================
_completions () {
	if [[ "$#" -lt 3 ]]; then
		suggestions=($(compgen -W "${functions:-}" "${2}"))
	else
		suggestions=''
	fi
}
