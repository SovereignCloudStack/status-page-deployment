# Configure status page

A minimal configuration of the status page deployment.

## API server

Configure the allowed origins via `api/api.env` to include the domain from the web frontend. CORS origins need to include the protocol, too. Example: `https://frontend.<your-domain>`.

## Database

Set a password for the database at `database/db-secrets.env` and configure the connection string in `api/api-secrets.env`

## Dex

Dex needs a GitHub Applications Client Secret in `dex/dex-secrets.env`, please refer to `dex/dex-secrets-example.env`.

Set the `issuer` and `redirectURI` at `dex/config.yaml` to your domain. Keep in mind, that dex needs it's own domain or subdomain.

Other Dex related configuration is located in `dex/dex.env`, `web/web-secrets.env` and `web/web.env` to fill the configuration template `dex/config.yaml`.

## Oathkeeper

Set your domain in `oathkeeper/config.yaml` at `authenticators.jwt.config.jwks_urls` and `authenticators.jwt.config.trusted_issuers` to point towards Dex.

## Web frontend

In `web/web.env` configure the OIDC authentication callback and the API url. The API URL must be pointing to the external domain, not the K8s service name.

## Ingress

In `ingress.yaml` set your domains for Dex, Oathkeeper and the web frontend respectivly. Oathkeeper acts as the auth proxy for the API server. Exposing the API server directly, opens up the possibilty of unsupervised write actions.

## Issuer

Set the e-mail address in `issuer.yaml` to your desired e-mail address.
