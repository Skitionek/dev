#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
__src="$__dev_root/src"
#==============================================================================
<SERVICE>_HOST="<service>"

HOST=${<SERVICE>_HOST}
PORT=${<SERVICE>_PORT}

_help() {
cat << EOF
Syntax:
	dev <service> [cmd]
Where [cmd] is one of:
	automated - connects to <service>s and opens website
EOF
}

automated() {
	connect & sleep 3 && open 'http://localhost:$PORT' & wait
}

functions="connect kill help automated"
source "$__src/common.sh"

connect () {
	"$__src/port-forward.sh" <service> $PORT
}

kill () {
	"$__src/kill.sh" $PORT
}
