#!/bin/bash -xe

if [ "$#" -ne 1 ]; then
    echo "$0 <name of the network configuration to use>"
    exit 1
fi

bandwidth_net_name="$1"

export NETCONFPATH="${NETCONFPATH:-$(pwd)/examples}"
export CNI_PATH="${CNI_PATH:-$(pwd)/plugins/bin}"
export CNI_DIR=$(pwd)/plugins
export CNI_PATH="${CNI_PATH:-$CNI_DIR/bin}"
export CNITOOL_BINARY=$CNI_DIR/cnitool

trap "sudo ip netns del server ; sudo ip netns del client" EXIT
clientIP="192.168.200.2"
serverIP="192.168.200.3"

# start the server "pod"
sudo ip netns add server
sudo NETCONFPATH=$NETCONFPATH \
    CNI_PATH=$CNI_PATH \
    CNI_ARGS="IgnoreUnknown=true;IP=$serverIP/24" \
    CNI_IFNAME=ens123 \
    CNI_CONTAINERID=$(uuidgen) \
    $CNITOOL_BINARY add $bandwidth_net_name "/var/run/netns/server"
sudo ip netns exec server bash -c "iperf3 -s -p 9000 -1 &"

# start the client "pod"
sudo ip netns add client
sudo NETCONFPATH=$(echo $NETCONFPATH) \
    CNI_PATH=$CNI_PATH \
    CNI_ARGS="IgnoreUnknown=true;IP=$clientIP/24" \
    CNI_IFNAME=ens123 \
    CNI_CONTAINERID=$(uuidgen) \
    $CNITOOL_BINARY add $bandwidth_net_name "/var/run/netns/client"
sudo ip netns exec client iperf3 -c "$serverIP" -p 9000

