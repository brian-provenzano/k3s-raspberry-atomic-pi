# patches to use metalb LB to expose externally, instead of plain in-cluster ClusterIP
#
kubectl patch svc polaris-dashboard -n polaris -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc polaris-dashboard -n polaris -p '{"metadata": {"annotations": {"metallb.universe.tf/address-pool": "network-services"}}}'
