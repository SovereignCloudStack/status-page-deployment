# status-page-deployment

Setup all services needed for the SCS Status Page.

## Local deployment

The local deployment uses [`kind`](https://kind.sigs.k8s.io/) to set up a local k8s cluster to deploy to.

```bash
kind create cluster --name status-page --wait 3m --config=kind-cluster-config.yaml
# or
make cluster
```

### Prerequisites

Please deploy the [`kubernetes/environments/kind/prerequisites/kustomization.yaml`](kubernetes/environments/kind/prerequisites/kustomization.yaml) to set up the local `kind` cluster to work with the deployment.

```bash
kubectl --context kind-status-page apply -k kubernetes/environments/kind/prerequisites
```

#### Persistent Volume Claims

`kind` does not provide a way to create a persistent volume for persistent volume claims. To be able to satisfy volume claims, rancher's `local-path-storage` is deployed locally.

### "Secrets"

All "secrets" shared in `kubernetes/environments/kind` are example values to get a local environment up and running. These values should be substituted by real and secure secrets.

### Setup Dex

Dex needs the GitHub Client Secret in `kubernetes/environments/kind/dex/dex-secrets.env`, please refer to [`kubernetes/environments/kind/dex/dex-secrets-example.env`](kubernetes/environments/kind/dex/dex-secrets-example.env).

Other Dex related configuration is located in [`kubernetes/environments/kind/dex/dex.env`](kubernetes/environments/kind/dex/dex.env), [`kubernetes/environments/kind/web/web-secrets.env`](kubernetes/environments/kind/web/web-secrets.env) and [`kubernetes/environments/kind/web/web.env`](kubernetes/environments/kind/web/web.env) to fill the configuration template at [`kubernetes/environments/kind/dex/config.yaml`](kubernetes/environments/kind/dex/config.yaml).

### Deploy on `kind`

All needed configurations and secrets are set up in a ready to use kustomization: [`kubernetes/environments/kind/kustomization.yaml`](kubernetes/environments/kind/kustomization.yaml), just assamble and deploy:

```bash
kubectl --context kind-status-page apply -k kubernetes/environments/kind
```

### Port forward

The local deployment uses [Caddy](https://caddyserver.com/) as reverse proxy to the cluster services. Portforward to the reverse proxy to start using the API locally.

For example:

```bash
kubectl --context kind-status-page -n status-page port-forward pods/status-page-reverse-proxy-78d588d58b-7rdn6 8080:8080
```

## SCS Public

Data present in `kubernetes/environments/scs-public` is the deployment specified for the provided SCS Cluster, which is already fully setup to run k8s workloads.

Configure the provided `.env`s. For secrets, the provided examples drop the `-example` part of their file names to be used as `.env` for that secret.

Deploy [`kubernetes/environments/scs-public/kustomization.yaml`](kubernetes/environments/scs-public/kustomization.yaml) to your desired cluster.
