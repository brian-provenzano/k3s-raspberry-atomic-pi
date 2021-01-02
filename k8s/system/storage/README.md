### Storage provisioners

#### Local- path
The included k3s local-path provisioner for using local node storage for PVC/PV.  Not being used but have retained an example configmap for future use if needed

#### NFS client provisioner
Contains deployment for NFS client provisioner using my local NFS server (FreeBSD 12.x on an old laptop).  Optional script is also documented for changing the default storageClass to use NFS

Currently managed/deployed via argocd
