# RRDCached

[RRDCached](https://oss.oetiker.ch/rrdtool/doc/rrdcached.en.html) is a daemon
that receives updates to existing RRD files, accumulates them and, if enough
have been received or a defined time has passed, writes the updates to the RRD file.

## TL;DR;

```bash
$ helm install incubator/rrdcached
```

## Introduction

This chart bootstraps a [RRDCached](https://hub.docker.com/r/crazymax/rrdcached) deployment
on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm update --install my-release incubator/rrdcached
```

The command deploys RRDCached on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured
during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redmine chart and their default values.

|            Parameter              |              Description                 |                          Default                        | 
| --------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `replicaCount`                    | Number of replicas to start              | `1`                                                     |
| `image.repository`                | RRDCache image name                      | `crazymax/rrdcached`                                    |
| `image.tag`                       | RRDCached image tag                      | `1.7.2`                                                 |
| `image.pullPolicy`                | RRDCached image pull policy              | `IfNotPresent`                                          |
| `service.type`                    | Desired service type                     | `ClusterIP`                                             |
| `service.port`                    | Service exposed port                     | `42217`                                                 |
| `persistence.enabled`             | Enable persistence using PVC for uploads | `false`                                                 |
| `persistence.annotations`         | An array of PVC annotations              | `{}`                                                    |
| `persistence.finalizers`          | An array of PVC finalizers               | `{}`                                                    |
| `persistence.storageClass`        | PVC Storage Class                        | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`          | PVC Access Mode                          | `ReadWriteOnce`                                         |
| `persistence.size`                | PVC Storage Request                      | `8Gi`                                                   |
| `persistence.existingClaim`       | If PVC exists & bounded                  | `nil` (when nil, new one is requested)                  |
| `ingress.enabled`                 | Enable or disable the ingress            | `false`                                                 |
| `ingress.hosts`                   | The virtual host name(s)                 | `{}`                                                    |
| `ingress.annotations`             | An array of service annotations          | `nil`                                                   |
| `ingress.tls[i].secretName`       | The secret kubernetes.io/tls             | `nil`                                                   |
| `ingress.tls[i].hosts[j]`         | The virtual host name                    | `nil`                                                   |
| `resources`                       | Resources allocation (Requests and Limits) | `{}`                                                  |

The above parameters map to the env variables defined in the [RRDCached image](https://hub.docker.com/r/crazymax/rrdcachd/).
For more information please refer to the [RRDCached](https://hub.docker.com/r/crazymax/rrdcached/)
image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm upgrade --install my-release \
  --set persistence.enabled=true \
    incubator/rrdcached
```

The above command enables persistence.

Alternatively, a YAML file that specifies the values for the above parameters can
be provided while installing the chart. For example,

```bash
$ helm upgrade --install my-release -f values.yaml incubator/rrdcached
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Replicas and persistence

RRDCached can write RRD data files to a persistent volume. By default that volume
cannot be shared between pods (RWO). In such a configuration the `replicas` option
must be set to `1`. If the persistent volume supports more than one writer
(RWX), ie NFS, `replicaCount` can be greater than `1`, but be aware that attempting a read 
against one replica before another replica has flushed all pending writes may return stale data

### Existing PersistentVolumeClaims

The following example includes two PVCs, one for uploads and another for misc. data.

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Create the directory, on a worker
1. Install the chart

```bash
$ helm upgrade --install test --set persistence.existingClaim=PVC_NAME incubator/rrdcached
```