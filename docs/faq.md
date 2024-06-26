# FAQ

## Dex needs a GitHub client secret. Where can I get it?

The examples are directly linked to the **SCS Gatekeeper** OAuth app that allows access for SovereignCloudStack members. It's recommended to create an own OAuth app in GitHub or any other supported provider. If you need quick and easy access as developer or tester, get in contact on matrix.

## I want to deploy on XY, can you do that?

Yes, all ways that are shown here to deploy the status page can be seen as examples and templates. Fork the repository and build your own deployment. Maybe start a pull request to share your way.

## I want to deploy another database, reverse proxy, ingress, AuthN, AuthZ, etc. Can you do that?

Yes, see above.

## I want another web frontend and API server, can you do that?

Currently no. The reference implementation only supplies one API server and one web frontend. You can implement your own, when conforming to [SovereignCloudStack/status-page-openapi](https://github.com/SovereignCloudStack/status-page-openapi).
