#!/bin/bash

PLUGINS_REPO_URL="https://github.com/containernetworking/plugins"
CNI_REPO_URL="https://github.com/containernetworking/cni"
function build_plugins {
    git clone $PLUGINS_REPO_URL
    pushd plugins
    ./build_linux.sh
    popd
}

function build_cni_tool {
    git clone $CNI_REPO_URL
    pushd cni
    go build -o ../plugins/cnitool cnitool/cnitool.go
    popd
}

if [[ ! -d plugins ]]; then
    build_plugins
fi

if [[ ! -d cni ]]; then
    build_cni_tool
fi

