NAME=scs-status-page
KIND_CLUSTER_CONFIG=kind-cluster-config.yaml

cluster:
	kind create cluster --name ${NAME} --wait 3m --config=${KIND_CLUSTER_CONFIG}

clean:
	-docker container rm -f scs-status-page-registry
	kind delete cluster --name ${NAME}
