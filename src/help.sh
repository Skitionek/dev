#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
cat << EOF
Syntax:
	dev [cmd]
Where [cmd] is one of:
	activate     - helpers to init shell
	common       - low level functions commonly used for interacting with deployments
	help         - this information message
	kill         - used to kill processes listening on given port (useful to kill detached processes)
	local        - manage connection to local cluster
	port-forward - wrapper around kubectl port-forward focused on forwarding into services (not pods)
	python       - helper functions to work with python
	self_check   - simple auto-diagnostic tests
	install_dependencies - tries to automatically install missing programs (on mac)
	git          - useful git command based scripts
	update       - updates this toolset
EOF
