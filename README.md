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
complements the functionality of the `bridge-cni` plugin with traffic shaping.
These configurations are:
- [unlimitedbandwidth](examples/bandwidth/10-unlimited.conflist): no traffic shaping
- [bandwidthlimiter](examples/bandwidth/10-limited.conflist): sets up an ingress rate & burst limiter

To execute the demo for the first part of the scenario (unlimited throughput):
```bash
NETCONFPATH=examples/bandwidth demo-scenarios/bandwidth-example.sh unlimitedbandwidth
```

To execute the demo for the second part of the scenario (bandwidth plugin
configures traffic shaping):
```bash
NETCONFPATH=examples/bandwidth demo-scenarios/bandwidth-example.sh bandwidthlimiter
```

**NOTE:** please ensure `cnitool` is in your PATH
