## Metal LB
Allows usage of a layer 2 LB (for my usage) in my pi4 cluster

```
kubectl apply -f metallb-deployment-v0.9.5.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
# apply configmap for your network - must be named `config`
kubectl apply -f metallb-configmap-layer2.yaml
```
