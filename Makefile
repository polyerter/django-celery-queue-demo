export:

.EXPORT_ALL_VARIABLES:
APP_NAME=djangotutorial
TYPE_ENV=local
NAMESPACE=${APP_NAME}-${TYPE_ENV}
REGISTRY_ADDR=registry.localhost
REGISTRY_PORT=5000
REGISTRY=${REGISTRY_ADDR}:${REGISTRY_PORT}
TAG = latest

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	KUBECTL_URL = "https://storage.googleapis.com/kubernetes-release/release/v1.27.1/bin/linux/amd64/kubectl"
else
	KUBECTL_URL = "https://storage.googleapis.com/kubernetes-release/release/v1.27.1/bin/darwin/amd64/kubectl"
endif

.ONESHELL:
.PHONY: local\:cluster-install
local\:cluster-install:
	# Download and install k3s cluster
	@#echo "Downloading cluster."
	curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

	# Download and install k3d lightweight cluster https://k3d.io/v5.3.0/#install-current-latest-release
	@#echo "Downloading k3d lightweight cluster."
	@#sudo wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

	# Download and install kubectl
	@echo "Downloading /usr/bin/kubectl for managing k8s resources."
	@curl -LOsS $(KUBECTL_URL)
	sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl
	sudo rm kubectl

.SILENT:
.ONESHELL:
.PHONY: local\:cluster-setup
local\:cluster-setup:
	# Create local container registry
	k3d registry create $(REGISTRY_ADDR) --port $(REGISTRY_PORT)

	# Delete app cluster if exists
	k3d cluster delete $(APP_NAME)

	# Create cluster
	k3d cluster create $(APP_NAME) --registry-use k3d-$(REGISTRY) --api-port 127.0.0.1:6555 -p "80:80@loadbalancer" --agents 2

	# Create app namespace
	kubectl create namespace $(NAMESPACE)

	# Set app namespace as default
	kubectl config set-context --current --namespace=$(NAMESPACE)


.PHONY: local\:cluster-delete
local\:cluster-delete:
	k3d registry delete $(REGISTRY_ADDR)
	k3d cluster delete $(APP_NAME)

.PHONY: local\:cluster-build
local\:build:
	docker build -t $(APP_NAME):$(TAG) ./$(APP_NAME) path to project
	docker tag $(APP_NAME):$(TAG) k3d-$(REGISTRY)/$(APP_NAME):$(TAG)
	docker push k3d-$(REGISTRY)/$(APP_NAME):$(TAG)
	echo "Built and pushed k3d-$(REGISTRY)/$(APP_NAME):$(TAG)"

.PHONY: local\:deploy
local\:deploy: local\:build
	helm upgrade $(APP_NAME) ./.helm --install

