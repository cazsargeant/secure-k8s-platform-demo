#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-secure-k8s-demo}"
IMAGE_NAME="${IMAGE_NAME:-demo-api:local}"

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require docker
require kind
require kubectl

if ! kind get clusters | grep -qx "$CLUSTER_NAME"; then
  kind create cluster --name "$CLUSTER_NAME" --config platform/bootstrap/kind-cluster.yaml
fi

docker build -t "$IMAGE_NAME" apps/demo-api
kind load docker-image "$IMAGE_NAME" --name "$CLUSTER_NAME"

kubectl config use-context "kind-$CLUSTER_NAME"
kubectl cluster-info

