package main

import (
	"fmt"

	"github.com/containernetworking/cni/pkg/skel"
	cniTypes "github.com/containernetworking/cni/pkg/types"
	cniVersion "github.com/containernetworking/cni/pkg/version"
	logging "github.com/k8snetworkplumbingwg/cni-log"

	"github.com/maiqueb/fosdem-2023-cni-chaining/pkg/config"
	"github.com/maiqueb/fosdem-2023-cni-chaining/pkg/version"
)

func main() {
	skel.PluginMain(
		cmdAdd,
		nil, // debug-cni only prints the `prevResult`, which is only available on CNI add
		nil, // debug-cni only prints the `prevResult`, which is only available on CNI add
		cniVersion.All,
		"Debug CNI "+version.Version)
}

func cmdAdd(args *skel.CmdArgs) error {
	n, err := config.LoadNetConf(args.StdinData)
	if err != nil {
		err = fmt.Errorf("error parsing CNI configuration %q: %v", args.StdinData, err)
		return err
	}

	if n.PrevResult == nil {
		return fmt.Errorf("missing prevResult from earlier plugin")
	}
	logging.Infof("previous result: %v", n.PrevResult)

	return cniTypes.PrintResult(n.PrevResult, n.CNIVersion)
}
