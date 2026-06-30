#!/usr/bin/env bash
set -euo pipefail

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require kubectl

kubectl -n demo-api get pods
kubectl -n demo-api rollout status deployment/demo-api --timeout=60s

kubectl -n demo-api port-forward service/demo-api 8080:80 >/tmp/demo-api-port-forward.log 2>&1 &
PORT_FORWARD_PID=$!
trap 'kill "$PORT_FORWARD_PID" >/dev/null 2>&1 || true' EXIT

sleep 3

curl --fail --silent http://127.0.0.1:8080/healthz
echo
curl --fail --silent http://127.0.0.1:8080/version
echo

if kubectl apply -f policies/tests/bad-latest-pod.yaml >/tmp/bad-latest.out 2>&1; then
  echo "Expected bad latest-tag pod to be rejected, but it was admitted." >&2
  kubectl delete pod bad-latest-pod --ignore-not-found >/dev/null 2>&1 || true
  exit 1
fi

echo "Admission policy rejected the latest-tag test pod as expected."

