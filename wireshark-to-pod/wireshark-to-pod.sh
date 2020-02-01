#!/usr/bin/env bash

# Show Pod's traffic in Wireshark
# (needs ssh sudo access)
#
# Author: Victor Yagofarov

set -e
set -o pipefail

NAMESPACE="${1}"
POD="${2}"

if [[ -z "${NAMESPACE}" || -z "${POD}" ]]; then
  echo "USAGE: <namespace> <pod>" >&2
  exit 1
fi

if ! which wireshark >/dev/null 2>&1; then
  echo "ERROR: Please install Wireshark" >&2
  exit 2
fi

NODE=$(kubectl get po -n ${NAMESPACE} -o wide ${POD} | awk '{print $7}' | grep -v NODE)

if [[ -z "$NODE" ]]; then
  echo "POD not found"
  exit 3
fi

CONTAINER_ID=$(ssh ${NODE} "sudo docker ps | grep -F ${POD} | grep -v pause | awk '{print \$1}'")

ssh ${NODE} sudo docker run --rm --net container:${CONTAINER_ID} nicolaka/netshoot 'tcpdump -nnpi eth0 -w -' | wireshark -k -i -

