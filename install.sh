#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#==============================================================================
if [[ -n "${DEV_UTILITIES_PATH:-}" ]]; then
	"$__dir/src/self_check.sh"
	sed -i "" "s~DEV_UTILITIES_PATH=.*~DEV_UTILITIES_PATH=\"$__dir/../dev.sh\"~g" ~/.bash_profile
	echo "Update complete"
else
	"$__dir/src/self_check.sh"
cat << EOF >> ~/.bash_profile
# Added by https://github.com/Skitionek/dev install script
	export DEV_UTILITIES_PATH="$__dir/dev.sh"
	source \$DEV_UTILITIES_PATH
#################################################################
EOF
	echo "Installation complete."
	echo "To start using command 'dev' please open a new terminal window."
fi
