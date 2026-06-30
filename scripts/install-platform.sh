#!/usr/bin/env bash
set -euo pipefail

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require helm
require kubectl

helm repo add argo https://argoproj.github.io/argo-helm >/dev/null
helm repo add kyverno https://kyverno.github.io/kyverno/ >/dev/null
helm repo add envoy-gateway https://envoyproxy.github.io/gateway-helm >/dev/null
helm repo update >/dev/null

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --set configs.params."server\.insecure"=true \
  --wait

helm upgrade --install kyverno kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --wait

helm upgrade --install envoy-gateway envoy-gateway/gateway-helm \
  --namespace envoy-gateway-system \
  --create-namespace \
  --wait

kubectl wait --for=condition=Established crd/gateways.gateway.networking.k8s.io --timeout=120s
kubectl wait --for=condition=Established crd/httproutes.gateway.networking.k8s.io --timeout=120s
kubectl wait --for=condition=Established crd/clusterpolicies.kyverno.io --timeout=120s

kubectl apply -k platform/gateway
kubectl apply -k policies/baseline
kubectl apply -k platform/apps/demo-api

kubectl -n demo-api rollout status deployment/demo-api --timeout=180s
