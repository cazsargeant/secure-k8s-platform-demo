# Secure Kubernetes Platform Golden Path Design

## Goal

Build a local Kubernetes demo/example that highlights platform engineering and security controls rather than application complexity.

## Non-Goals

- The demo app is not a product.
- The platform does not require cloud credentials.
- The initial version does not include a service mesh, database, Terraform, or cloud IAM.
- The repository does not grant an open-source license unless a license is added.

## Architecture

The platform has four layers:

1. A minimal HTTP service in `apps/demo-api`.
2. Kubernetes application manifests in `platform/apps/demo-api`.
3. Cluster platform components in `platform/gateway`, `platform/argocd`, and `policies`.
4. CI workflows for test, validation, SBOM generation, vulnerability scanning, and artifact signing.

The local cluster path uses `kind`, Envoy Gateway, Kyverno, and standard Kubernetes manifests. The GitOps path uses Argo CD application manifests so the same layout can be reconciled by a controller.

## Security Model

The demo focuses on practical controls:

- Workloads run as non-root containers.
- Pods use `RuntimeDefault` seccomp.
- Privileged containers are rejected.
- CPU and memory requests/limits are required.
- Mutable image tags are rejected.
- GHCR images can be required to carry keyless Cosign signatures.
- CI generates an SBOM and scans images with Grype before signing.

## GKE Alignment

The local implementation maps to GKE without depending on GCP:

| Local implementation | GKE-aligned equivalent |
|---|---|
| `kind` | GKE Standard or Autopilot |
| Gateway API + Envoy Gateway | GKE Gateway controller |
| Argo CD manifests | Argo CD on GKE or Cloud Deploy/Skaffold |
| Syft SBOM | Artifact Analysis metadata |
| Grype scan | Artifact Analysis scanning |
| Cosign signatures | Binary Authorization-compatible artifact trust |
| Kyverno policies | Policy Controller, Binary Authorization, admission policy |
| Kubernetes service accounts | Workload Identity Federation for GKE |

## Implementation Plan

1. Add the minimal HTTP service and tests.
2. Add hardened Kubernetes manifests.
3. Add Gateway API and GitOps manifests.
4. Add Kyverno baseline and supply-chain policies.
5. Add local bootstrap and verification scripts.
6. Add CI workflows for app, manifests, policy, SBOM, scan, and signing.
7. Add docs for architecture, threat model, supply chain, and the demo walkthrough.
