## K3s on Raspberry Pi and Atomic Pi  - Home Cluster
This is just a local project that operates as a Kubernetes test bed.  Currently running on k3s (using k3os) on a 3 node "cluster" consisting of:
- (2) Raspberry Pi 4 (arm)
- (1) Atomic Pi (amd64)
- NFS server - FreeBSD 12.x on old laptop
  - provisioned k8s storage (via the NFS client provisioner running in the cluster)

ArgoCD is used to deploy/manage most apps and components

## Hardware
- Raspberry Pi 4
- Atomic Pi

### Load Balancer - Services
Currently using metallb for LoadBalancer in layer2 mode (not BGP)
https://metallb.universe.tf/

NOTE: Pi4 Wifi adapter has issues with ARP so when using MetalLB in Layer 2 mode (which is what I am doing), I have to set the wifi adapters to promiscous mode.  if you plan to use the wifi just note this.

```
sudo ip link set wlan0 promisc on
```
^^ set this to run at boot on the Pi4 if you have this problems


### Monitoring
Using grafana, prometheus helm charts
- https://github.com/helm/charts/tree/master/stable/grafana
- https://github.com/helm/charts/tree/master/stable/prometheus

Was going to use the prometheus-operator, but currently does not support ARM on Pi.


### ArgoCD
[ArgoCD deployment](/k8s/system/argocd)

https://argoproj.github.io/

The deployments in this project have been modified to deploy to the Atomic Pi (amd64 nodes) via affinity - see [install-x86.yaml](/k8s/system/argocd/install-x86.yaml)

You can use the [patch](k8s/system/argocd/patch-svc-to-lb.sh) to patch the argocd service to use metallb to expose the argocd web ui / api server.


### Polaris
https://github.com/FairwindsOps/polaris

Uses the Polaris Armv7 v1.0.3 binary here: https://github.com/FairwindsOps/polaris/releases/download/1.0.3/polaris_1.0.3_linux_armv7.tar.gz

Custom [Dockerfile](/k8s/system/polaris/Dockerfile) and [Makefile](/k8s/system/polaris/Makefile) to build ARM image since Polaris doesnt support yet (but they do have the ARM binary ^^)

Quick Setup:
Just swap out the image in the v1.0.3 [deployment yaml](https://github.com/FairwindsOps/polaris/releases/download/1.0.3/dashboard.yaml) for this my [custom image](https://hub.docker.com/r/warpigg/polaris-arm) and apply.  Already done [here](/k8s/system/polaris/dashboard.yaml)


### PiHole
[Deployment yaml](/k8s/apps/pihole)

Now using cloudflared sidecar to provide dns https support

- https://github.com/crazy-max/docker-cloudflared
- https://docs.pi-hole.net/guides/dns-over-https/


### Secrets (Bitnami Sealed Secrets and External Secrets)

#### Sealed Secrets
Trying [bitnami sealed secrets](https://github.com/bitnami-labs/sealed-secrets) (now has ARM build)

Quick process:
- create a k8s secret (base64 encoded)
- `kubeseal --format yaml <k8s-secrets.yaml >sealedsecrets.yaml`
- `kubectl apply -f sealedsecrets.yaml`

You can commit the sealedsecret to git

#### External Secrets
https://github.com/external-secrets/kubernetes-external-secrets


### Storage Classes (options)
Set the default storage class to the use the NFS client provisoner instead of local-path local storage provisioner that is default on k3s

You can change the storage class defaults with this [script](k8s/system/storage/nfs-client/patch-default-storageclass.sh)


#### Local storage provisioner (Local-Path)
https://github.com/rancher/local-path-provisioner

#### NFS provisioner
https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
