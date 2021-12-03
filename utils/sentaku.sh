#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :07/11/2019
#email      :Skitionek@gmail.com
#==============================================================================

(
	. sentaku -n
	_SENTAKU_KEYMODE=1
	_SENTAKU_NONUMBER=1
	header=${1}
	_sf_set_header () {
		_s_header=$header
	}

	_sf_main "${@:2}"
)
