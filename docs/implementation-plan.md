# Secure Kubernetes Platform Golden Path Implementation Plan

**Goal:** Build a local Kubernetes demo/example that demonstrates platform engineering and security controls around a deliberately minimal service.

**Architecture:** A small dependency-free Node service is packaged as a container and deployed with hardened Kubernetes manifests. Platform concerns live in separate GitOps-ready directories for Gateway API, Argo CD, Kyverno, and supply-chain policy.

**Tech Stack:** Node.js 22, Docker, Kubernetes, kind, Helm, Gateway API, Envoy Gateway, Argo CD, Kyverno, Syft, Grype, Cosign, kubeconform.

## Global Constraints

- Use Syft for SBOM generation and Grype for vulnerability scanning.
- Keep branch and documentation naming neutral and demo-oriented.
- Frame the repository as a demo/example of platform engineering work.
- Keep the app minimal so platform and security controls are the focus.
- Keep the demo local-first and GKE-aligned without requiring GCP credentials.

## Tasks

- [x] Add a minimal HTTP service with tests.
- [x] Add hardened Kubernetes app manifests.
- [x] Add Gateway API and Argo CD manifests.
- [x] Add Kyverno baseline and supply-chain policies.
- [x] Add local bootstrap and verification scripts.
- [x] Add GitHub Actions workflows for app tests, manifest validation, policy tests, SBOM, scan, and signing.
- [x] Add architecture, threat-model, supply-chain, and walkthrough docs.
