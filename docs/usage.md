# Usage

You can use and test the API via any API client ([Bruno](https://www.usebruno.com/), built in Swagger UI, etc.), CLI tool (like `curl`) or the web frontend.

All examples provided use `curl`, the most manual methods and the public SCS release.

## Receive auth code

Visit the [openid-configuration](https://status-idp.k8s.scs.community/.well-known/openid-configuration) of the running Dex and build an auth URL from the provided information and your desired paramters.

For example:

```txt
https://status-idp.k8s.scs.community/auth?client_id=status-page-web&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Flogin&response_type=code&scope=openid+profile+email+offline_access
```

And visit the generated URL to start the Authorization Code Flow.

After authentication you get redirect to `https://status.k8s.scs.community/login?code=<your-code>&state=`

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

More usage examples can be found at [SovereignCloudStack/status-page-api/docs/example-requests.md](https://github.com/SovereignCloudStack/status-page-api/blob/main/docs/example-requests.md)
