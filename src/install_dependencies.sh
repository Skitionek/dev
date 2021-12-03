#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :07/11/2019
#email      :Skitionek@gmail.com
#==============================================================================
set -e #exit on single fail

check() {
	return command -v $1 >/dev/null 2>&1
}

echo "Installing missing dependencies"

if check pipenv; then
	echo "Install pipenv"
	pip install pipenv
fi

if check kubectl; then
	echo "Install kubectl"
	brew install kubectl
	kubectl version
	echo "\tInstall bash-completion@2"
	brew install bash-completion@2
	if [[ -z ${BASH_COMPLETION_COMPAT_DIR} ]]; then
		~/.bash_profile << EOF
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
EOF
	fi
	echo "\tEnable kubectl autocompletion"
	kubectl completion bash >/usr/local/etc/bash_completion.d/kubectl
fi

if check git; then
	echo "Install git (follow instructions)"
	git --version
fi

if check sentaku; then
	echo "Install sentaku"
	brew tap rcmdnk/rcmdnkpac
	brew install sentaku
fi

if check gcloud; then
	echo "Install gcloud"
	open https://cloud.google.com/sdk/docs/quickstart-macos
fi

echo "Finished without error"