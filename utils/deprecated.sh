#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
echo "This service has been deprecated"
if [[ -n "${1:-}" ]]; then
	echo "Please use ${1} instead!"
fi
