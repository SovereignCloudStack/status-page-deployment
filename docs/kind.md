# `kind` - Local development environment

`kind` is a tool to quickly setup a local development environment, to test and debug the deployment.

**NOTE**: `kind` is not consindered to be used as any kind of produtive deployment.

## "Secrets"

All "secrets" shared in `kubernetes/environments/kind` are example values to get a local environment up and running. These values should be substituted by real and secure secrets.

## Install

Install `kind` from the [offical website](https://kind.sigs.k8s.io/).

## Setup

Create a local `kind` cluster with:

```bash
kind create cluster --name status-page --wait 3m --config=kind-cluster-config.yaml
# or
make cluster
```

## Deploy

All needed configurations and secrets are set up in a ready to use kustomization: `kubernetes/environments/kind/kustomization.yaml`, just assamble and deploy:

```bash
kubectl --context kind-status-page apply -k kubernetes/environments/kind
```

For further configuration see [`configuration.md`](configuration.md).

## Port forward

The local `kind` deployment uses [Caddy](https://caddyserver.com/) as reverse proxy, instead of `Ingress` and `IngressController`s, to the cluster services. Portforward to the reverse proxy to start using the deployment locally.

For example:

```bash
kubectl --context kind-status-page -n status-page port-forward pods/status-page-reverse-proxy-78d588d58b-7rdn6 8080:8080
```
