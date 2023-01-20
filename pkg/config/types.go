package config

import (
	"encoding/json"
	"fmt"
	current "github.com/containernetworking/cni/pkg/types/100"
	"github.com/containernetworking/cni/pkg/version"

	cniTypes "github.com/containernetworking/cni/pkg/types"
)

type NetConf struct {
	cniTypes.NetConf
}

func LoadNetConf(bytes []byte) (*NetConf, error) {
	n := &NetConf{}
	if err := json.Unmarshal(bytes, n); err != nil {
		return nil, fmt.Errorf("failed to load netconf: %s", err)
	}

	if n.RawPrevResult != nil {
		var err error
		if err = version.ParsePrevResult(&n.NetConf); err != nil {
			return nil, fmt.Errorf("could not parse prevResult: %v", err)
		}

		_, err = current.NewResultFromResult(n.PrevResult)
		if err != nil {
			return nil, fmt.Errorf("could not convert result to current version: %v", err)
		}
	}

	return n, nil
}
