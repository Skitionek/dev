#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
__root="$__dev_root"
#==============================================================================
cd "$__root" && git pull && ./install.sh && ./dev.sh activate local_profile
