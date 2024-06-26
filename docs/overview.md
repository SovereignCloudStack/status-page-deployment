# Overview

The status page needs some components additional to the [API server](https://github.com/SovereignCloudStack/status-page-api) to be usable by operators and customers. As the API server [does not implement any kind of authorization or authentication](https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0402-v1-status-page-openapi-spec-decision.md#authentication-and-authorization) some components need to be deployed to protect the write operations of the API from unauthorized access.

## Components

These components are picked as examples and can be exchanged with any technology that is fitting the use case.

The used components are [Oathkeeper](https://www.ory.sh/docs/oathkeeper) and [Dex](https://dexidp.io/) to implement AuthN[^1] and AuthZ[^2]. Oathkeeper is a proxy that handles incoming requests and authorization, while Dex is used as an identity broker, used for authentication, to be used in conjunction with Oathkeeper to secure the API server.

[^1] Authentication
[^2] Authorization

Furthermore the API server needs a running database, for this [PostgreSQL is used](https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0401-v1-status-page-reference-implementation-decision.md#database).

Last but not least the the status page is completed by a web front. For this the reference implementation from the [`status-page-web` repository](https://github.com/SovereignCloudStack/status-page-web).

Some deployments use reverse proxies, ingress controllers or can even use the gateway API. These are deployment specific and can be used as the use case requires.

### Component overview

```mermaid
    C4Container
    title Component overview status page

    Person(user, User, "A user who wants to know about the status.")
    Person(admin, Admin, "An administrator who can update the status.")

    Container_Boundary(status-page, "Status Page") {
        Container(web, "Web Frontend", "JavaScript, Angular", "Provides all the status page functionality to persons via their web browser")
        Container(dex, "Dex IdP", "", "Intermediate IdP to retrieve user data.")
        Container(api, "API Server", "Go", "Delivers data to the Web Frontend")
        ContainerDb(api-db, "API Database", "SQL Database", "Stores components, incidents, severities, phases, etc.")
        Container(oathkeeper, "Oathkeeper", "AuthN, AuthZ", "Authentication proxy for write operations on the API Server.")

        Rel(api, api-db, "Request data")
        Rel(web, oathkeeper, "Request data", "Unauthenticated read, authenticated write")
        Rel(oathkeeper, api, "Proxy and protect",)
        Rel(web, dex, "Authentication")
        Rel(oathkeeper, dex, "Authenticate user requests")
    }

    Rel(user, web, "Reads status")
    Rel(admin, web, "Writes status")
    Rel(admin, dex, "Authenticate")
```

## Deployment repository

The [deployment repository](https://github.com/SovereignCloudStack/status-page-deployment) contains a [local development environment using `KinD`](./kind.md), templates for other deployments, in [example using k3s](./k3s.md) and the skeleton of the deployment for the [public SCS cluster](./scs-public.md).
