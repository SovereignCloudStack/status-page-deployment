# `kind` - Local development environment

`kind` is a tool to quickly setup a local development environment, to test and debug the deployment.

**NOTE**: `kind` is not considered to be used as any kind of productive deployment.

## "Secrets"

All "secrets" shared in `kubernetes/environments/kind` are example values to get a local environment up and running. These values should be substituted by real and secure secrets.

## Per Installation  Steps

* Install `kind` from the [official website](https://kind.sigs.k8s.io/).
* Clone the [status-page-deployment](https://github.com/SovereignCloudStack/status-page-deployment) repository
  ```
  git clone git@github.com:SovereignCloudStack/status-page-deployment.git
  ```
* Create a [Github OAuth app](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app) for testing, see example data:
  (Note: It is **not critical** to share the data listed here, as this is only a test application which is reachable from localhost)
  * Name: SCS Gatekeeper Test DEV
  * Homepage URL: https://scs.community/
  * Authorization callback URL: http://localhost:8080/
  * Client ID: `<generated>`
  * Client Secret: `<generated>`

## Setup

Create a local `kind` cluster with:

```bash
make cluster
```

## Deploy

All needed configurations and secrets, except Dex's GitHub app secrets, are set up in a ready to use kustomization: `kubernetes/environments/kind/kustomization.yaml`, just assemble and deploy:

* Create Github application
* Create and configure OAUTH config files
  ```bash
  cp kubernetes/environments/kind/dex/dex-secrets-example.env kubernetes/environments/kind/dex/secrets.env
  vim kubernetes/environments/kind/dex/dex.env # configure GITHUB_CLIENT_ID
  vim kubernetes/environments/kind/dex/secrets.env # configure GITHUB_CLIENT_SECRET
  ```
* Deploy Application
  ```bash
  make deploy
  ```

For further configuration see [`configuration.md`](configuration.md).

## Port forward

The local `kind` deployment uses [Caddy](https://caddyserver.com/) as reverse proxy, instead of `Ingress` and `IngressController`s, to the cluster services. 
Port forward to the reverse proxy to start using the deployment locally.

For example:

```bash
make forward
```
