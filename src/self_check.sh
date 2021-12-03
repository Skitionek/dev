#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
__error="$__dev_root/utils/error.sh"
#==============================================================================

check_command() {
	command -v $1 >/dev/null 2>&1 || \
	"$__error" "Command $1 is required but not installed."
}

check_command cat
check_command echo
check_command source
check_command pipenv
check_command gcloud
check_command kubectl
check_command python
check_command lsof
check_command kill
check_command compgen
check_command find
check_command complete
check_command git
check_command sentaku

CURRENT_CLUSTER=""
check_cluster() {
	if [[ $(kubectl config get-contexts | grep "*" | awk '{ print $3 }') != "$CURRENT_CLUSTER" ]]; then
		"$__error" "kubectl config points to wrong cluster!"
	fi
}

echo "Self check done."
