#!/bin/bash
#patch to change default storage class to use nfs
# default for k3s is local-path storage provisioner (unless it is disabled in k3s server parameters)

# 1. set nfs to default (true)
kubectl patch storageclass <your-class-name-in-deployment> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# 2 set local provisioner to false
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
