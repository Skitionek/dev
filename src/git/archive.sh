#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :07/11/2019
#email      :Skitionek@gmail.com
#==============================================================================
__sentaku="$__dev_root/utils/sentaku.sh"
#==============================================================================

help() {
cat << EOF
Syntax:
	dev git archive [branch]
Tags branch as archive/[branch] then deletes it locally and remotely.
EOF
}

_completions () {
	if [[ "$#" -lt 3 ]] && [[ "${2:-1}" != ' ' ]]; then
		words="$(git branch -a --format='%(refname:short)' | tr '\n' ' ')"
		suggestions=($(compgen -W "${words}" "${2}"))
	else
		suggestions=''
	fi
}

if [[ "${1:-}" == "_completions" ]]; then
 _completions "${@:2}"
elif [[ "${1:-}" == "help" ]]; then
 help
else
	if [[ -z ${1} ]]; then
		_completions "${@}"
		selected_branch=$("$__sentaku" "Please select branch to archive:" ${words[@]})
	else
		selected_branch=$1
	fi
	origin_branch=($(echo ${selected_branch} | tr "/" "\n"))
	if [[ ${#origin_branch[@]} -lt 2 ]]; then
		origin_branch=($(
			git show-ref "${origin_branch[0]}" |
			grep -E "refs/remotes/" |
			grep -Eo "[^/]+/[^/]+$" |
			tr "/" "\n"
		))
	fi
	origin=${origin_branch[0]}
	branch=${origin_branch[1]}
	echo "branch: ${branch} origin: ${origin}"
	echo "Tag branch:" &&
	git tag "archive/${2:-$branch}" "${origin_branch}" "${@:3}" &&
	git push --tags && (
	echo "Delete remote branch" &&
	git push "${origin}" ":${branch}" &&
	echo "Delete local branch" &&
	git branch -d "${branch}" ) &&
	cat << EOF
To recover this branch from archive call:
	git checkout -b ${branch} archive/${branch}
EOF
fi
