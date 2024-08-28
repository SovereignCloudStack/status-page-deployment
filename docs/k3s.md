# k3s - A simple deployment on a single host

From a new machine to a working status page in ~15 minutes.

## Prerequisites

A VM or bare metal host with a public IP. Optional: A domain pointing to the public IP.

## k3s setup

Setting up k3s to run k8s workloads on the machine.

### Firewall settings

Allow communication to and from the cluster.

Incoming:

- 6443 Kubernetes API server
- 80 HTTP ingress
- 443 HTTPS ingress

Internal:

- 10.42.0.0/16 - Pod communication
- 10.43.0.0/16 - Service communication

#### `ufw` example

```bash
ufw allow 6443/tcp # api server
ufw allow from 10.42.0.0/16 to any # pods
ufw allow from 10.43.0.0/16 to any # services

ufw allow 80/tcp # http
ufw allow 443/tcp # https
```

### Install

Configure and install k3s directly via install script. See the [k3s server config](https://docs.k3s.io/cli/server).

```bash
curl -sfL https://get.k3s.io | sh -s - server \
--tls-san <your-ip> \
--tls-san <your-domain>
```

Setting the SANs enables the k3s server to be available via your domain and server ip.

## Deployment

Deploy services to the cluster, to get the status page running.

If you don't have access to a domain name, consider using [nip.io](https://nip.io/) to use as (sub)domains for Dex, Oathkeeper (API server) and the web frontend.

### Kube config

The newly generated kube config for the cluster is located at `/etc/rancher/k3s/k3s.yaml`. Copy to your machine to configure access to the cluster.

Change the URI at `.clusters[0].cluster.server` to the URI you added to the SAN config.

### Deploy cert manager

Deploy [cert-manager](https://cert-manager.io/docs/installation/kubectl/) on the cluster to automatically receive LetsEncrypt certificates.

See `issuer.yaml` for settings.

### Configure and deploy status page

For in depth configuration see [`configuration.md`](configuration.md).

Assemble and deploy the k3s deployment.

```bash
kubectl kustomize kubernetes/environments/k3s/ > k3s_out.yaml
kubectl apply -f k3s_out.yaml
# or
kubectl apply -k kubernetes/environments/k3s/
```

The deployment creates a namespace called `status-page` where all services, ingress, etc. gets deployed.
