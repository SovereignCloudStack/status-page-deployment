# status-page-deployment

Setup all services needed for the SCS Status Page.

## Secrets

### Database

Database credentials in [`kubernetes/environments/kind/database/database.env`](kubernetes/environments/kind/database/database.env) are purely used as example or local debug credentials.

### Dex

Dex needs the GitHub Client ID and Client Secret in `kubernetes/environments/kind/dex/dex.env`:

```env
GITHUB_CLIENT_ID=<client_id>
GITHUB_CLIENT_SECRET=<client_secret>
```

As well as a client config in [`kubernetes/environments/kind/dex/config.yaml`](kubernetes/environments/kind/dex/config.yaml):

```yaml
staticClients:
  - id: <client_id>
    redirectURIs:
      - <client_redirect_url>
    name: <client_name>
    secret: <custom_secret>
```

The `client_redirect_url` is not the same URL as defined by the GitHub App. It's the URL where Dex should redirect to, after successful authentication.

## Local deployment

### Loadbalancer

`kind` does not provide a way to create a load balancer, bound to local addresses. [MetalLB](https://metallb.universe.tf/) is used to provide a configuration for a local address.

[`overlays/develop/metallb.yaml`](overlays/develop/metallb.yaml) defines an `IPAddressPool`. This pool must lay within the network used by kind. Check and change appropriately:

```bash
$ docker network inspect kind
[
  {
    "Name": "kind"
    "IPAM": {
      "Config": [
        {
          "Subnet": "172.18.0.0/16",
        },
      ]
    }
  }
]
```

### Persistent Volume Claims

`kind` also does not provide a way to create a persistent volume for persistent volume claims. To be able to satisfy volume claims, rancher's `local-path-storage` is deployed locally, too.
