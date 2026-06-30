# Secure Kubernetes Platform Demo

This repository is an example of my platform engineering work: a small Kubernetes platform path that moves a deliberately minimal service from source code to a governed runtime.

The service is intentionally boring. The value is in the platform around it: GitOps layout, Gateway API, admission policy, signed artifacts, SBOMs, vulnerability scanning, and clear operational documentation.

This repository is published as a demonstration/example. It is not distributed as open source software, and no license is granted unless a `LICENSE` file is added.

## What This Demonstrates

- Local Kubernetes platform bootstrap with `kind`
- GitOps-ready cluster/app layout for Argo CD
- Gateway API routing
- Admission controls with Kyverno
- Image signing and attestations with Cosign
- SBOM generation with Syft
- Vulnerability scanning with Grype
- Kubernetes manifest validation with kubeconform
- CI policy checks before deployment
- GKE-aligned design without requiring GCP credentials

## Security Posture

This example uses practical platform controls rather than application complexity:

- non-root workloads with restricted pod security settings
- explicit CPU and memory requests/limits
- mutable image tag rejection
- privileged container rejection
- SBOM generation and vulnerability scanning before trusted artifact publication
- keyless image signing and SBOM attestation in CI
- optional Kyverno image verification policy for GHCR images

## Repository Layout

```text
.
├── .github/workflows/        # CI, manifest validation, image build/scan/sign
├── apps/demo-api/            # Minimal HTTP service
├── docs/                     # Architecture, threat model, walkthroughs
├── platform/                 # GitOps-oriented app and gateway manifests
├── policies/                 # Kyverno policies and policy test resources
└── scripts/                  # Local bootstrap and verification helpers
```

## Quick Start

Prerequisites:

- Docker
- `kind`
- `kubectl`
- Helm 3

Run:

```bash
./scripts/bootstrap-kind.sh
./scripts/install-platform.sh
./scripts/verify-demo.sh
```

The local path installs the platform components and deploys the demo API through Kubernetes manifests. Supply-chain signing is exercised in CI, where GitHub OIDC can be used for keyless signing.

## Platform Controls

| Control | Local demo implementation | GKE-aligned equivalent |
|---|---|---|
| Cluster runtime | `kind` | GKE Standard or Autopilot |
| Traffic entry | Gateway API + Envoy Gateway | GKE Gateway controller |
| GitOps | Argo CD manifests | Argo CD on GKE or Cloud Deploy/Skaffold |
| SBOM | Syft | Artifact Analysis metadata |
| Vulnerability scan | Grype | Artifact Analysis scanning |
| Signing | Cosign | Binary Authorization-compatible artifact trust |
| Admission policy | Kyverno | Policy Controller, Binary Authorization, admission policy |
| Service identity | Kubernetes service accounts | Workload Identity Federation for GKE |

## Demo Flow

1. Run CI checks for the app and Kubernetes manifests.
2. Build the demo API image.
3. Generate an SBOM.
4. Scan the image with Grype.
5. Sign the image and attestations with Cosign in GitHub Actions.
6. Reconcile Kubernetes state through the GitOps layout.
7. Use Kyverno policies to reject unsafe workload definitions.
8. Route traffic to the service through Gateway API.

## Licensing

No open source license is granted by this repository unless a `LICENSE` file is added.
