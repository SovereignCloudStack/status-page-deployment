#!/bin/sh
# set -euo pipefail

contains() {
  [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1
}

# Get paramters
cluster_name="${1:-kind}"
cluster_config="${2:-./kind-cluster-config.yaml}"
reg_name="${3:-kind-registry}"
reg_port="${4:-5001}"

echo "** creating cluster with container registry"
echo "** cluster name:   ${cluster_name}"
echo "** cluster config: ${cluster_config}"
echo "** registry name:  ${reg_name}"
echo "** registry port:  ${reg_port}"

# Create registry container unless it already exists
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  echo "** create cluster registry"
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
else
  echo "** use existing cluster registry"
fi

# Create kind cluster unless it already exists
contains "$(kind get clusters)" ${cluster_name}
if [ "x$?" == "x1" ]; then
  echo "** create new cluster ${cluster_name}"
  kind create cluster --name ${cluster_name} --wait 3m --config=${cluster_config}
else
  echo "** use existing cluster ${cluster_name}"
fi

# Add the registry config to the nodes
echo "** add registry config to nodes"
REGISTRY_DIR="/etc/containerd/certs.d/localhost:${reg_port}"
for node in $(kind get nodes --name ${cluster_name}); do
  docker exec "${node}" mkdir -p "${REGISTRY_DIR}"
  cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${reg_name}:5000"]
EOF
done

# Connect the registry to the cluster network if not already connected
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  echo "** connect registry to cluster network"
  docker network connect "kind" "${reg_name}"
else
  echo "** registry is connected to cluster network"
fi

# Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
echo "** apply registry config to cluster"
cat <<EOF | kubectl --context kind-${cluster_name} apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

echo "** status"
kubectl --context kind-${cluster_name} cluster-info

echo "** everything done. enjoy"
