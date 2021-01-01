## Monitoring
Using the official stable helm charts for grafana and prometheus

- https://github.com/helm/charts/tree/master/stable/grafana
- https://github.com/helm/charts/tree/master/stable/prometheus

1. Create the requisite PVCs first (uses local-provisioner for Prometheus; NFS provisioner for grafana - only bc Prometheus has issues with NFS locking)
2. Run the helm charts 
3. update the services to use MetalLB (manual right now).  TODO configure the custom_values.yaml to use the metalLB services out of the box.

TODO: configure custom_values.yaml overrides to setup the services as LBs for Grafana instead of default ClusterIP.  I am currently applying a [secondary service manifest](/k8s/monitoring/grafana-lb-svc.yaml) to update the default helm clusterip service to use MetalLB after the helm chart is deployed.  It is hacky to say the least...
