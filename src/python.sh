#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#==============================================================================
__utils="$__dev_root/utils"
__error="$__dev_root/utils/error.sh"
#==============================================================================

###########################################
# Map accidental pip invocations to pipenv
# Arguments:
#   pipenv args
# Returns:
#   None
###########################################
pip() {
	pipenv --skip-lock "$@"
}

###########################################
# Run python tests
# Arguments:
#   pipenv args
# Returns:
#   None
###########################################
unittest() {
	python -m unittest "$@"
}


export_requirements() {
	pipenv lock -r > requirements.txt
}

virtual_env() {
	python -c 'import sys; print (sys.real_prefix)' 2>/dev/null || \
		(pipenv shell) || \
		"$__error" "No virtual environment set."
	pipenv check
}

help() {
cat << EOF
Syntax:
	dev python [cmd]
Where [cmd] is one of:
	unittest            - run tests
	export_requirements - list dependencies to requirements.txt
	virtual_env         - activate/create venv
EOF
}

functions="pip unittest export_requirements virtual_env help"
_completions () {
	if [[ "$#" -lt 3 ]]; then
		suggestions=($(compgen -W "${functions}" "${2}"))
	else
		_command
		suggestions=''
	fi
}

source "$__utils/call_first_argument.sh"
