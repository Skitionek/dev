#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-08
#email      :Skitionek@gmail.com
#==============================================================================
__src="$__dev_root/src"
__utils="$__dev_root/utils"
#==============================================================================

LOCAL_HOST=""
LOCAL_USERNAME=""

tunnel () {
  # Tunnel kubectl access port through ssh
  ssh -fNTL 16443:localhost:16443 $LOCAL_USERNAME@$LOCAL_HOST
}

connect () {
	# Copy login certs to server
  ssh-copy-id $LOCAL_USERNAME@$LOCAL_HOST || (ssh-keygen -t rsa && ssh-copy-id $LOCAL_USERNAME@$LOCAL_HOST)

  # Tunnel kubectl access port through ssh
  tunnel

  # Get config with cert for remote connection
  mkdir -p $HOME/.kube/
  touch $HOME/.kube/remote-config
  ssh $LOCAL_USERNAME@$LOCAL_HOST '/snap/bin/microk8s.kubectl config view --raw' > $HOME/.kube/remote-config

  # Use just downloaded config
  export KUBECONFIG=$HOME/.kube/remote-config:$HOME/.kube/config
  touch $HOME/.kube/config
  kubectl config view --raw > $HOME/.kube/config
  kubectl config use-context microk8s

  echo "Done"
}

kill () {
	"$__src/kill.sh" 16443
}

help() {
cat << EOF
Syntax:
	dev local [cmd]
Where [cmd] is one of:
  connect - tunnel to and set kubectl for local cluster
  tunnel  - just tunnel 16443 over ssh (22) to bypass local firewall for kubectl
	kill    - kill process which uses kubectl port
EOF
}

functions="connect tunnel kill"
_completions () {
	if [[ "$#" -lt 3 ]]; then
		suggestions=($(compgen -W "${functions:-}" "${2}"))
	fi
}

source "$__utils/call_first_argument.sh"
