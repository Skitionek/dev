#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#==============================================================================
__utils="$__dev_root/utils"
#==============================================================================
local_profile () {
	shift
	source ~/.bash_profile
}

env_path=".venv/bin/activate"
pipenv () {
	if [ -f "$env_path" ]; then
		source ${env_path}
	else
		"$__utils/error.sh" "Local virtual environment does not exist"
	fi
}

pipenv_venv () {
	pipenv
}


help() {
cat << EOF
Syntax:
	dev activate [cmd]
Where [cmd] is one of:
	local_profile       - rereads .bash_profile
	pipenv, pipenv_venv - activate pipenv virtual environment
EOF
}

functions="local_profile pipenv pipenv_venv help"
source "$__utils/completions.sh"

source "$__utils/call_first_argument.sh"
