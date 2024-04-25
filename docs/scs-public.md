# SCS Public

Data present in `kubernetes/environments/scs-public` is the deployment specified for the provided SCS Cluster, which is already fully setup to run k8s workloads.

Configure the provided `.env`s. For secrets, the provided examples drop the `-example` part of their file names to be used as `.env` for that secret.

For in depth configuration see [`configuration.md`](configuration.md).

Deploy [`kubernetes/environments/scs-public/kustomization.yaml`](../kubernetes/environments/scs-public/kustomization.yaml) to your desired cluster.
