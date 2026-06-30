# Threat Model

## Assets

- Deployed workload definitions
- Container images
- SBOMs and attestations
- Cluster admission controls
- GitOps source of truth

## Trust Boundaries

- Source code enters the delivery path through GitHub.
- Container images enter the runtime through the registry.
- Kubernetes admits workloads only after API server and admission policy checks.
- GitOps reconciles declared state into the cluster.

## Threats And Controls

| Threat | Control |
|---|---|
| Mutable image tag deploys an unexpected artifact | Kyverno rejects `latest` and missing tags |
| Privileged workload escapes expected runtime constraints | Kyverno rejects privileged containers and Pod Security Admission enforces restricted mode |
| Resource exhaustion from unconstrained workloads | Kyverno requires CPU and memory requests/limits |
| Image is modified outside the expected delivery path | Cosign signs images and Kyverno can verify GHCR signatures |
| Known vulnerable image is promoted | Grype scan runs before signing |
| Manifest drift from expected state | Argo CD reconciles declared state |
| Inconsistent traffic entry configuration | Gateway API defines route ownership explicitly |

## Residual Risk

This local demo does not provide cloud IAM, production-grade secret management, or a managed control plane. Those concerns are documented as GKE extensions rather than simulated locally.

