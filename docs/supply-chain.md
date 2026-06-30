# Supply Chain Controls

The supply-chain path uses separate controls for separate questions:

| Question | Control |
|---|---|
| What is in the image? | Syft SBOM |
| Does the image contain known vulnerabilities? | Grype scan |
| Did the image come from the expected workflow? | Cosign keyless signing |
| Can Kubernetes reject untrusted images? | Kyverno image verification |
| Are manifests well-formed? | kubeconform |
| Do policies reject unsafe examples? | Kyverno CLI |

The CI workflow signs only on pushes and manual workflow runs. Pull requests run validation and scanning without publishing trusted artifacts.

## Why Grype And Syft

The demo separates SBOM generation from vulnerability evaluation. Syft produces the inventory; Grype evaluates that inventory or the built image. This keeps the control model easy to reason about and avoids tying every supply-chain step to one scanner.

