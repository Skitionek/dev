#!/usr/bin/env bash
#author     :Dominik Maszczyk
#date       :2019-10-07
#email      :Skitionek@gmail.com
#==============================================================================
__error="$__dev_root/utils/error.sh"
__sentaku="$__dev_root/utils/sentaku.sh"
#==============================================================================

forward () {
	echo "Calling: kubectl port-forward -n ${3:-default} svc/${1:-} ${2:-}"
	kubectl port-forward -n ${3:-default} svc/${1:-} ${2:-}
}

help() {
cat << EOF
Syntax:
	dev port-forward [service-name] [port] [?namespace]
For more information check underlying function 'kubectl port-forward -h'.
EOF
}

_completions_namespace () {
	if [[ "$#" -lt 4 ]]; then
		namespaces=''
		for namespace in $(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers); do
			namespaces="$namespaces $(kubectl get svc/$1 -n ${namespace} -o custom-columns=NAME:.metadata.namespace --no-headers 2> /dev/null)"
		done
		suggestions=($(compgen -W "$namespaces" "${3}"))
	else
		suggestions=''
	fi
}

_completions_port () {
	if [[ "$#" -lt 3 ]]; then
		ports=''
		for namespace in $(kubectl get namespace -o custom-columns=NAME:.metadata.name --no-headers); do
			ports="$ports $(kubectl get svc/$1 -n ${namespace} -o custom-columns=NAME:.spec.ports..port --no-headers 2> /dev/null  | tr ',' ' ')"
		done
		suggestions=($(compgen -W "$ports" "${2}"))
	else
		_completions_namespace "${@}"
	fi
}

_completions () {
	if [[ "$#" -lt 2 ]] && [[ "${1:-1}" != ' ' ]]; then
		words="help $(kubectl get svc -A -o custom-columns=NAME:.metadata.name --no-headers | tr '\n' ' ')"
		suggestions=($(compgen -W "${words}" "${1}"))
	else
		_completions_port "${@}"
	fi
}


if [[ "${1:-}" == "_completions" ]]; then
 _completions "${@:2}"
elif [[ "${1:-}" == "help" ]]; then
 help
 else
	if [[ -z "$1" ]]; then
		echo "Service argument was not provided"
		services=$(kubectl get svc -A -o custom-columns=NAME:.metadata.name --no-headers | tr ' ' '\n' | sort | uniq)
		services=(${services[@]})
		if [ ${#services[@]} -lt 1 ]; then
			"$__error" "$1 could not found any service!"
			exit 1
		elif [[ ${#services[@]} -lt 2 ]]; then
			service=(${services[0]})
			echo "Defaults to only one: ${service}"
		else
		echo "${#services[@]}"
			service=$(
				"$__sentaku" "Select service to connect:" "${services[@]}"
			)
			echo "Chosen: ${service}"
		fi
	else
		service=$1
	fi
	if [[ -z "$2" ]]; then
		echo "Port argument was not provided"
		_completions_port $service "${@:2}"
		ports=$(echo "${ports[@]}" | tr ' ' '\n' | sort | uniq)
		if [ ${#ports[@]} -lt 1 ]; then
			"$__error" "$service could not found any exposed port!"
			exit 1
		elif [[ ${#ports[@]} -lt 2 ]]; then
			port=(${ports[0]})
			echo "Defaults to only one exposed port: ${port}"
		else
			port=$(
				"$__sentaku" "Service is exposed on multiple ports choose correct one:" "${ports[@]}"
			)
			echo "Chosen: ${port}"
		fi
	else
		port=$2
	fi
	if [[ -z "$3" ]]; then
		echo "Namespace argument was not provided"
		namespaces=$(kubectl get svc -A | grep "\s$service\s" | grep -Eo '^[^ ]+')
		namespaces=(${namespaces[@]})
		if [ ${#namespaces[@]} -lt 1 ]; then
			"$__error" "$service could not be found in any namespace!"
			exit 1
		elif [ ${#namespaces[@]} -lt 2 ]; then
			namespace=(${namespaces[0]})
			echo "Defaults to only one instance: ${namespace}"
		else
			namespace=$(
				"$__sentaku" "Service exist in multiple namespaces choose correct one:" "${namespaces[@]}"
			)
			echo "Chosen: ${namespace}"
		fi
	else
		namespace=$3
	fi
	forward ${service} ${port} ${namespace}
fi
