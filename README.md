# fosdem2023-cni-unchained

Demo scripts / config for the "CNI unchained" talk at FOSDEM2023

## Demo scenarios

### Bandwidth

The [bandwidth CNI](https://www.cni.dev/plugins/current/meta/bandwidth/)
provides a way to use and configure Linux’s Traffic control (tc) subsystem,
providing traffic shaping between the interfaces using it.

This demo scenario is composed of two net namespaces, interconnected by a linux
bridge.

```

                         ┌──────────┐
                         │          │
             ┌──────────►│  mybr0   │◄──────────┐
             │           │          │           │
             │           └──────────┘           │
    ┌────────┴────────┐                ┌────────┴────────┐
    │                 │                │                 │
    │  192.168.200.2  │                │  192.168.200.3  │
    │                 │                │                 │
    │   client netns  │                │   server netns  │
    └─────────────────┘                └─────────────────┘
```

We will use two different CNI configurations, to show how the bandwidth CNI
complements the functionality of the
[bridge CNI](https://www.cni.dev/plugins/current/main/bridge/) plugin with
traffic shaping.
These configurations are:

- [unlimitedbandwidth](examples/10-unlimited.conflist): no traffic shaping
- [bandwidthlimiter](examples/10-limited.conflist): sets up an ingress rate & burst limiter

#### Requirements

This demo requires the following software installed in your system:

- [golang](https://go.dev/doc/install)
- iperf3

Run the following script to build the
[reference CNI plugins](https://github.com/f1-outsourcing/plugins/blob/master/plugins/)
along with
[cnitool](https://github.com/containernetworking/cni/tree/main/cnitool):

```bash
./setup_dependencies.sh
```

#### Demo steps

To execute the demo for the first part of the scenario (unlimited throughput):

```bash
demo-scenarios/bandwidth-example.sh unlimitedbandwidth
```

To execute the demo for the second part of the scenario (bandwidth plugin
configures traffic shaping):

```bash
demo-scenarios/bandwidth-example.sh bandwidthlimiter
```

### Debug-cni

This
[chained CNI plugin](https://github.com/containernetworking/cni/blob/main/SPEC.md#overview-1)
does one thing: it prints the result of the previous plugin in the chain; it is
helpful for debugging purposes, allowing the user to inspect a step-by-step
result of each plugin in the chain, thus helping to realize where in the chain
did things go wrong.

This demo scenario is composed of a single net namespace, interconnected by a
linux bridge.

```

                         ┌──────────┐
                         │          │
             ┌──────────►│  mybr0   │
             │           │          │
             │           └──────────┘
    ┌────────┴────────┐
    │                 │
    │   dummy netns   │
    └─────────────────┘
```

We will use a
[single chained configuration](https://github.com/maiqueb/fosdem2023-cni-unchained/blob/main/examples/20-debug-cni.conflist)
to create the aforementioned scenario, after which we'll print the result from the bridge plugin, then
use the tuning-cni plugin to mutate the sandbox interface MAC address.

#### Demo steps

To execute the demo:

```bash
demo-scenarios/debug-cni.sh debug-bridge-config
```
