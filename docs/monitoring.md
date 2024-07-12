# Monitoring

All backend components of the status page can be instrumented to supply metrics. These metrics can be collected and visualized by monitoring technologies like [Prometheus](https://prometheus.io/) and [Grafana](https://grafana.com/).

## Endpoints

The services expose there metrics endpoints on different ports.

| Service      | Port (Name)          | Endpoint   |
| ------------ | -------------------- | ---------- |
| `api-db`     | `9187` (`metrics`)   | `/metrics` |
| `api`        | `9000` (`metrics`)   | `/metrics` |
| `dex`        | `5558` (`telemetry`) | `/metrics` |
| `oathkeeper` | `9000` (`metrics`)   | `/metrics` |

## Dashboards

To visualize the supplied metrics, some dashboards are needed.

For the used database and exporter the [PostgreSQL Database](https://grafana.com/grafana/dashboards/9628-postgresql-database/) dashboard is recommended.

Go runtime metrics can be visualized by the [Go Metrics](https://grafana.com/grafana/dashboards/10826-go-metrics/) dashboard.

Hand crafted dashboard for Dex, Oathkeeper and the status-page-api are located at `kubernetes/feature/monitoring/grafana/dashboards` and have according prefixes.

## KinD

The KinD deployment deploys Grafana and Prometheus pods and sets up the datasource and dashboards, to work with the rest of the deployment out of the box.

The Grafana frontend can be accessed by port forwarding the reverse proxy:

```bash
kubectl --context kind-status-page -n status-page port-forward pods/status-page-reverse-proxy-78d588d58b-7rdn6 8080:8080
```

Afterwards Grafana can be accessed by navigating to `monitoring.test:8080`. Use the username `admin` and password `s3cr3t`.
