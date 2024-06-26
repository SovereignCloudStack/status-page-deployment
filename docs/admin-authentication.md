# Admin authentication

As the write operations of the [API server](https://github.com/SovereignCloudStack/status-page-api) are protected by [Oathkeeper](https://www.ory.sh/docs/oathkeeper) and use identities provided by [Dex](https://dexidp.io/) an Administrator is considered to be a person that can authenticate on Dex.

On the public SCS deployment, these persons are members of the SovereignCloudStack organization.

This sequence diagram displays a simplified flow how an administrator authenticates himself with Dex and GitHub, to authorize using the write operations.

```mermaid
sequenceDiagram
actor admin as Admin
participant useragent as User Agent
participant web as Web Frontend
participant dex as Dex IdP
participant idp as Upstream IdP
participant oathkeeper as Oathkeeper
participant api as API Server
participant db as API Database

admin->>useragent: enters status page url
useragent->>web: request status page
note over web: simplified
web-->>useragent: app view
useragent-->>admin: presents app view

rect rgba(0,127,255,0.8)
    note right of admin: Login
    admin->>useragent: enters login flow
    useragent->>web: login request
    web->>dex: login request
    dex->>idp: actual login
    idp-->>dex: user info
    dex-->>web: id-token
    web-->>useragent: login successful
    useragent-->>admin: login successful
end

rect rgba(64,127,0, 0.8)
    note right of admin: Authenticated Request
    admin->>useragent: enters operation
    useragent->>web: operation request
    web->>+oathkeeper: operation request with id-token
    oathkeeper->>dex: id-token verification
    dex-->>oathkeeper: verified
    oathkeeper->>api: proxy operation request
    api->>db: request data
    db-->>api: data
    api-->>oathkeeper: data
    oathkeeper-->>-web: data
    web-->>useragent: data
    useragent-->>admin: presents new data
end
```
