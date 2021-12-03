#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#==============================================================================
__error="$__dev_root/utils/error.sh"
#==============================================================================
help() {
cat << EOF
Syntax:
	dev kill [port]
Where [port] is port expressed by number or name
EOF
}

_completions () {
	echo "--- ${@} ---"
	if [[ "$#" -lt 2 ]]; then
		processes=$(lsof -n -i  | grep LISTEN | sed -E 's/([^ ]+)[^:]*:([^: ]*) [^ ]*$/\2\(\1\)/' | tr '\n' ' ')
		echo "pro $processes"
		suggestions=($(compgen -W "$processes" "${1}"))
		echo "sug $suggestions"
		if [ "${#suggestions[@]}" == "1" ]; then
			local number=$(echo ${suggestions[0]} | sed 's/(.*)/ /')
			echo "$number"
			COMPREPLY=("$number")
		else
			# more than one suggestions resolved,
			# respond with the suggestions intact
			COMPREPLY=("${suggestions[@]}")
		fi
	fi
	suggestions=''
}

if [[ -z "${1:-}" ]]; then
	echo "Type port to free:"
	read port
else
	port=$1
fi

if [[ "${1:-}" == "_completions" ]]; then
	_completions "${@:2}"
elif [[ "${port:-}" == "help" ]]; then
	help
else
	lsof=$(lsof -n -i:$port)
	if [ ! -z "${lsof// }" ]; then
	    echo "Found process listening on port $port:"
	    lsof -n -i:$port
	    echo "Killing"
	    kill $(lsof -nti:$port)
	else
		echo "No process is listening on port $port."
	fi
	lsof=$(lsof -n -i:$port)
	if [ ! -z "${lsof// }" ]; then
	    echo "Process did not exit trying with SIGTERM"
	    kill -s SIGTERM $(lsof -nti:$port)
	fi
	lsof=$(lsof -n -i:$port)
	if [ ! -z "${lsof// }" ]; then
	    "$__error" "Process did not exit!"
	fi
fi
