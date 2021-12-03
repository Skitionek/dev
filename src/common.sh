#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#==============================================================================
__src="$__dev_root/src"
__utils="$__dev_root/utils"
#==============================================================================

connect () {
	"$__src/port-forward.sh" ${HOST} ${PORT} ${NAMESPACE}
}

kill () {
	"$__src/kill.sh" ${PORT}
}


help() {
echo "Available commands:"
if [[ ${0##*/} == "common.sh" ]]; then
cat << EOF
Syntax:
	dev common [cmd]
Where [cmd] is one of:
	connect \$HOST \$PORT \$NAMESPACE - calls kubernetes port forward with args from env vars
	kill \$PORT                       - kill process listening on \$PORT
EOF
else
	_help
cat << EOF
	connect - calls kubernetes port forward for ${HOST:-\$HOST}:${PORT:-\$PORT} $([[ -n ${NAMESPACE:-} ]] && echo "(namespace:${NAMESPACE})")
	kill    - kill process listening on ${PORT}
EOF
fi
}

functions="${functions:-} connect kill"

source "$__utils/completions.sh"
source "$__utils/call_first_argument.sh"
