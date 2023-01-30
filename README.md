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
