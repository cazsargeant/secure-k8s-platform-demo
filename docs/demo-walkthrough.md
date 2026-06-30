# Demo Walkthrough

## Local Runtime Path

1. Create the cluster:

   ```bash
   ./scripts/bootstrap-kind.sh
   ```

2. Install platform components and the demo app:

   ```bash
   ./scripts/install-platform.sh
   ```

3. Verify the service:

   ```bash
   ./scripts/verify-demo.sh
   ```

4. Apply a bad manifest and confirm admission rejects it:

   ```bash
   kubectl apply -f policies/tests/bad-latest-pod.yaml
   ```

   Expected result: the API server rejects the pod because the image uses `latest`.

## CI Path

The GitHub Actions workflows:

- run API tests
- validate Kubernetes manifests
- test Kyverno policies
- build the container image
- generate an SBOM with Syft
- scan with Grype
- sign images with Cosign when publishing trusted artifacts

