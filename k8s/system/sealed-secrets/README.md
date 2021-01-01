## Secrets
Using bitnami sealed secrets (now has ARM build)

Quick process:
- create a k8s secret (base64 encoded)
- `kubeseal --format yaml <k8s-secrets.yaml >sealedsecrets.yaml`
- `kubectl apply -f sealedsecrets.yaml`

You can commit the sealedsecret to git

