## K3s on Raspberry Pi and Atomic Pi  - Home Cluster
This is just a local project that operates as a Kubernetes test bed.  Currently running on k3s (using k3os) on a 3 node "cluster" consisting of:
- (2) Raspberry Pi 4 (arm)
- (1) Atomic Pi (amd64)
- NFS server - FreeBSD 12.x on old laptop
  - provisioned k8s storage (via the NFS client provisioner running in the cluster)

ArgoCD is used to deploy/manage most apps and components

## Hardware
- [Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/)
  - official power adapter
- [Atomic Pi](https://ameridroid.com/products/atomic-pi) - x86 SBC with 2GB RAM and 32GB eMMC...also available on Amazon
  - [power adapter](https://www.amazon.com/gp/product/B01N4HYWAM/ref=crt_ewc_title_dp_1?ie=UTF8&psc=1&smid=A2OCOGC9B25845)
  - [baby breakout board](https://ameridroid.com/products/baby-breakout-for-atomic-pi) - can also be sourced via Amazon
- [TP-Link 8 Port Gigabit Ethernet Network Switch](https://www.amazon.com/gp/product/B00A121WN6/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)
- [Argon One Raspberry Pi 4 Case](https://www.amazon.com/gp/product/B07WP8WC3V/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1) - excellent case!
- (2) SD cards
  - Decent quality cards that I am using [sandisk SD Extreme 64GB](https://www.amazon.com/gp/product/B07FCMBLV6/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- Lots of ethernet cables :)
- Legos to create Atomic Pi case :)
- Velcro 2 sided tape

## K3s (K3OS) Kubernetes Install
[K3s](https://k3s.io/) is used for kubernetes.  K3s is an awesome project for lightweight easy to configure, single binary kubernetes.

[K3OS](https://k3os.io/) - packages K3s and a minimal easily configurable OS with K3s - Rancher project
- Raspberry Pi4 - I used this excellent project to create the k3os images [picl-k3os-image-generator](https://github.com/sgielen/picl-k3os-image-generator)
  - Builds images already configured with k3os ready to boot your Pi from!
- Atomic Pi - used vanilla K3os installer on sd card to auto config/instal to the local eMMC on the Atomic Pi

`TODO - detail and include how to autoconfigure K3OS via config files etc`

## Repo Structure
- k8s - contains manifest for cluster - all managed by argocd
  - apps
  - system
- nfs - contains sample configuration for NFS on FreeBSD (quick setup)

### Load Balancer - Services
Currently using metallb for LoadBalancer in layer2 mode (not BGP)
https://metallb.universe.tf/

NOTE: Pi4 Wifi adapter has issues with ARP so when using MetalLB in Layer 2 mode (which is what I am doing), I have to set the wifi adapters to promiscous mode.  if you plan to use the wifi just note this.

```
sudo ip link set wlan0 promisc on
```
^^ set this to run at boot on the Pi4 if you have this problems


### Monitoring
- Prometheus helm chart
  - https://github.com/helm/charts/tree/master/stable/prometheus


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
- `kubeseal --format yaml <pihole-secrets.yaml >pihole-sealed.yaml --controller-name=sealed-secrets --controller-namespace=sealed-secrets`
- `kubectl apply -f pihole-sealed.yaml` (this is done using argocd in this cluster)

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
