#!/usr/bin/env bash
#source     :https://stackoverflow.com/questions/57006043/get-the-git-commit-hash-of-the-last-commit-which-affected-files-not-listed-in-a
#maintain   :Dominik Maszczyk
#date       :2019-07-31
#email      :Skitionek@gmail.com
#url        :https://gist.github.com/Skitionek/0ec84a7d70436bde635e14661779cf87
#==============================================================================
DIR=$(mktemp -d)
pushd $DIR > /dev/null
# Set up a temporary git repository so we can use
# git check-ignore with .dockerignore
git init > /dev/null
popd > /dev/null
cp .dockerignore $DIR/.gitignore 2> /dev/null

for commit in $(git log --pretty=%h)
do
	# Get the changed file names for the commit.
	# Use `sed 1d` to remove the first line, which is the commit description
	files=$(git show $commit --oneline --name-only | sed 1d)

	pushd $DIR > /dev/null
	for file in $files
	do
		match=$(git check-ignore $file -v)
		# Store the error code
		ERROR=$?
		if [ $ERROR -gt 0 ] || [[ -z $match ]] || [[ $match == *:!* ]]
		then
			popd > /dev/null
			rm -rf $DIR
			echo $commit
			exit 0
		fi
	done
	popd > /dev/null
done

rm -rf $DIR
exit $ERROR
exit 1


# Example - determine image tag for Jenkins:
#   def lastCommitAffectingDockerImage = sh(script: './lastCommitAffectingDockerImage.sh', returnStdout: true).trim()
#   def tagOrHash = sh(script: "git describe ${lastCommitAffectingDockerImage} --tags 2> /dev/null || echo ${lastCommitAffectingDockerImage}", returnStdout: true).trim()