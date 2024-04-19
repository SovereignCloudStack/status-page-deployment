# status-page-deployment

Setup all services needed for the SCS Status Page.

## Local deployment

The local deployment uses [`kind`](https://kind.sigs.k8s.io/) to set up a local k8s cluster to deploy to.

```bash
kind create cluster --name status-page --wait 3m --config=kind-cluster-config.yaml
# or
make cluster
```

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

## Usage

### Receive auth code

Visit the [openid-configuration](https://status-idp.k8s.scs.community/.well-known/openid-configuration) of the running Dex and build an auth URL from the provided information and your desired paramters.

For example:

```txt
https://status-idp.k8s.scs.community/auth?client_id=status-page-web&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Flogin&response_type=code&scope=openid+profile+email+offline_access
```

And visit the generated URL to start the Authorization Code Flow.

After authentication you get redirect to `http://localhost:3000/login?code=<your-code>&state=`

### Exchange token

Copy your code and send it to the token URL.

For example:

```bash
$ curl -sL \
-X POST \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'client_id=status-page-web' \
-d 'client_secret=<your-secret>' \
-d 'code=<your-code>' \
-d 'redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Flogin' \
-d 'grant_type=authorization_code' \
https://status-idp.k8s.scs.community/token

{
  "access_token": "<your-access-token>",
  "token_type": "bearer",
  "expires_in": 86399,
  "refresh_token": "<your-refresh-token>",
  "id_token": "<your-id-token>"
}
```

**NOTE**: Be **extremely careful** with your **code** and **client secret** as they represent **credentials**!

### Use API

Copy your id token and use it as bearer token in writing requests.

For example creating a new component:

```bash
curl -sL \
-X POST \
-H 'Authorization: Bearer <your-id-token>' \
-H 'Content-Type: application/json' \
-d '{"displayName":"Test-Component"}'\
https://status-api.k8s.scs.community/components
```

**NOTE**: Be **extremely careful** with your **id token** and **access token** as they represent **credentials**!
