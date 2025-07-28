# Django celery queue demo

## Run project

Open dictory "dockers"

```shell
docker compose up
```

## Launching a local production-like environment

```bash
#Installing the cluster and necessary utilities
make local:cluster-install
```

```bash
# Configuring a Cluster
make local:cluster-setup
```

```bash
# Build and deploy to a local cluster
make local:deploy
```

```bash
# Deleting a local registry and cluster
make local:cluster-delete
```