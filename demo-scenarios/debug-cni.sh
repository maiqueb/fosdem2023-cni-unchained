#!/bin/bash -xe

if [ "$#" -ne 1 ]; then
    echo "$0 <name of the network configuration to use>"
    exit 1
fi

net_name="$1"
netns_name="debugns"

export NETCONFPATH="${NETCONFPATH:-$(pwd)/examples}"
export CNI_PATH="${CNI_PATH:-$(pwd)/plugins/bin}"
export CNI_DIR=$(pwd)/plugins
export CNI_PATH="${CNI_PATH:-$CNI_DIR/bin}"
export CNITOOL_BINARY=$CNI_DIR/cnitool

trap "sudo ip netns del $netns_name" EXIT

sudo ip netns add $netns_name
sudo NETCONFPATH=$NETCONFPATH \
    CNI_PATH=$CNI_PATH \
    CNI_IFNAME=ens123 \
    CNI_CONTAINERID=$(uuidgen) \
    $CNITOOL_BINARY add $net_name "/var/run/netns/$netns_name"

