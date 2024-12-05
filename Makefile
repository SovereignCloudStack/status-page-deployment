NAME=status-page
KIND_CLUSTER_CONFIG=kind-cluster-config.yaml
K8S_CONTEXT=kind-status-page
LOCAL_FORWARDED_PORT=8080

cluster: check
	kind get clusters | grep -q status-page || \
		kind create cluster --name ${NAME} --wait 3m --config=${KIND_CLUSTER_CONFIG}
.PHONY: cluster

deploy: check cluster
	kubectl --context ${K8S_CONTEXT} apply -k kubernetes/environments/kind
	sleep 1
	kubectl wait --context ${K8S_CONTEXT} -n status-page --for=condition=Ready pod  --timeout=300s -l app
.PHONY: deploy

cleanup: check
	kind get clusters | grep -q status-page && \
		kind delete cluster --name ${NAME}
.PHONY: cleanup

forward: check deploy
	@echo "Opening forward for http://web.localhost:${LOCAL_FORWARDED_PORT}"
	kubectl --context ${K8S_CONTEXT} -n status-page port-forward \
		pods/$(shell kubectl get pods --context ${K8S_CONTEXT} -n status-page \
					-l app=status-page-reverse-proxy -o jsonpath='{.items[*].metadata.name}') ${LOCAL_FORWARDED_PORT}:8080
.PHONY: forward

check:
	@which kind &>/dev/null || (echo "ERROR: kind not installed"; exit 1)
	@which kubectl &>/dev/null || (echo "ERROR: kubectl not installed"; exit 1)
.PHONY: check


