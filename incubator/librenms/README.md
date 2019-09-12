# LibreNMS

[LibreNMS](https://www.librenms.org) is a fully featured network monitoring system
that provides a wealth of features and device support.

## TL;DR;

```bash
$ helm install incubator/librenms
```

## Introduction

This chart bootstraps a [LibreNMS](https://hub.docker.com/r/crazymax/librenms) deployment
on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MaridaDB chart](https://github.com/helm/charts/tree/master/stable/mariadb) for database
support, the [RRDCached chart](https://github.com/helm/charts/tree/master/incubator/librenms) for RRD file storage,
and the [redis chart](https://github.com/helm/charts/tree/master/stable/redis) for distributed poller queues and locking.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm update --install my-release incubator/librenms
```

The command deploys LibreNMS on the Kubernetes cluster in the default configuration.
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

The following table lists the configurable parameters of the chart and their default values.

|            Parameter              |              Description                 |                          Default                        | 
| --------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `gui.enabled`                     | Create a GUI deployment                  | `true`                                                  |
| `gui.replicaCount`                | Number of GUI replicas to start          | `1`                                                     |
| `gui.username`                    | Username to create if initializing       | `librenms`                                              |
| `gui.password`                    | Password used if initializing            | Random 10-character alphanumeric string                 |
| `gui.nginx.image.repository`      | GUI nginx container image name           | `librenms/librenms`                                     |
| `gui.nginx.image.tag`             | GUI nginx image tag                      | `1.54`                                                  |
| `gui.nginx.image.pullPolicy`      | GUI nginx image pull policy              | `IfNotPresent`                                          |
| `gui.php7fpm.opcacheMemSize`      | PHP-FPM opcache memory size, in Mb       | `128`                                                   |
| `gui.php7fpm.memoryLimit`         | PHP-FPM memory limit                     | `256M`                                                  |
| `gui.php7fpm.image.repository`    | GUI php7fpm container image name         | `librenms/librenms`                                     |
| `gui.php7fpm.image.tag`           | GUI php7fpm image tag                    | `1.54`                                                  |
| `gui.php7fpm.image.pullPolicy`    | GUI php7fpm image pull policy            | `IfNotPresent`                                          |
| `poller.enabled`                  | Create a poller deployment               | `true`                                                  |
| `poller.replicaCount`             | Number of poller replicas to start       | `1`                                                     |
| `poller.group`                    | Group number for poller deployment       | `0`                                                     |
| `poller.image.repository`         | Poller image name                        | `librenms/librenms`                                     |
| `poller.image.tag`                | LibreNMS image tag                       | `1.54`                                                  |
| `extraConfig`                     | See [upstream documentation](https://github.com/librenms/librenms/blob/1.54/includes/defaults.inc.php) | `nil` |
| `image.pullPolicy`                | LibreNMS image pull policy               | `IfNotPresent`                                          |
| `mariadb.enabled`                 | Whether to use the MariaDB chart         | `true`                                                  |
| `mariadb.*`                       | MariaDB chart configuration              | See [upstream documentation](https://github.com/helm/charts/tree/master/stable/mariadb) |
| `externalDatabase.host`           | Host of the external database            | `nil` - If set, overrides all mariadb config            |
| `externalDatabase.port`           | Port of the external database            | `3306`                                                  |
| `externalDatabase.user`           | Existing username in the external db     | `bookstack`                                             |
| `externalDatabase.password`       | Password for the above username          | `nil`                                                   |
| `externalDatabase.database`       | Name of the existing database            | `bookstack`                                             |
| `rrdcached.enabled`               | Whether to use the MariaDB chart         | `true`                                                  |
| `rrdcached.*`                     | RRDCached chart configuration            | See [upstream documentation](https://github.com/helm/charts/tree/master/incubator/librenms) |
| `externalRrdcached.host`          | Host of external RRDCached server        | `nil` - If set, overrides all librenms config          |
| `externalRrdcached.port`          | Port of external RRDcached server        | `42217`                                                 |
| `redis.enabled`                   | Whether to use the redis chart           | `true`                                                  |
| `redis.*`                         | redis chart configuration                | See [upstream documentation](https://github.com/helm/charts/tree/master/stable/redis) |
| `externalRedis.host`              | Host of external redis master/sentinel   | `nil` - if set, overrides all redis config              |
| `externalRedis.port`              | Port of external redis master/sentinel   | `nil`                                                   |
| `externalRedis.sentinel.enabled`  | Use sentinel protocol                    | `false`                                                   |
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

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm upgrade --install my-release \
  --set persistence.enabled=true \
    incubator/librenms
```

The above command enables persistence.

Alternatively, a YAML file that specifies the values for the above parameters can
be provided while installing the chart. For example,

```bash
$ helm upgrade --install my-release -f values.yaml incubator/librenms
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Replicas and persistence

Enabling `redis` automatically configures the poller for distributed polling.  Do not scale the poller deployment higher
than a single replica if redis is not enabled.

LibreNMS relies on RRDCached and MariaDB to provide its persistence.  Review documentation for those charts regarding
enabling persistence.  Care should be taken when enabling persistence given the performance requirements of larger
environments -- high IOPS persistence drivers such as
[Local Persistent Volumes](https://kubernetes.io/blog/2019/04/04/kubernetes-1.14-local-persistent-volumes-ga/) are
recommended for RRD storage

