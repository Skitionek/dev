#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
__src="$__dev_root/src"
__utils="$__dev_root/utils"
#==============================================================================

last_commit_affecting_docker_image() {
	"$__src/git/last_commit_affecting_docker_image.sh" "${@:2}"
}

status() {
	"$__src/git/git_status.sh" "${@:2}"
}

archive() {
	"$__src/git/archive.sh" "${@:2}"
}

log1() {
	git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all "${@:2}"
}

log2() {
	git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all "${@:2}"
}

log() {
	log1 "${@}"
}

help() {
cat << EOF
Syntax:
	dev git [cmd]
Where [cmd] is one of:
	last_commit_affecting_docker_image  - based on .dockerignore file finds last commit hash which potentially affect build process
	status                              - recursively check git status and show differences if repositories was cloned more than once
	log, log1, log2                     - colorfull human friendly take on git logs
EOF
}

functions="last_commit_affecting_docker_image status log log1 log2 archive"
_completions () {
	if [[ "$#" -lt 3 ]]; then
		suggestions=($(compgen -W "${functions:-}" "${2}"))
	else
		if [[ "${2}" == 'archive' ]]; then
			source "$__src/git/archive.sh" _completions "${@:2}"
		else
			suggestions=''
		fi
	fi
}

source "$__utils/call_first_argument.sh"
