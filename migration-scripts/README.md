# K8s-Status-Dashboard-Config-Migration

K8s-Status-Dashboard is a reporting system used as part of monitoring Kubernetes Clusters.

The K8s-Status-Dashboard needs k8s credentials (client.key/client.crt) in order to make requests against the intended k8s api. 

This project has automated the process of migrating k8s credentials (client.key/client.crt) 

K8s-Status-Dashboard collects and dynamically reports on the status of the health of a cluster as well as various resources such as components (scheduler, controller-manager, etcd), nodes and namespaces.

K8s-Status-Dashboard is light weight and does not require a data-store but can be easily integrated with a database if necessary. 

## Pre-requisites 

- `kubectl`: This is the cli for controlling the Kubernetes cluster. See [here](https://kubernetes.io/docs/user-guide/prereqs/).
- `az`: This is the cli for controlling the AZ resources.

**NOTE:** Make sure you are using the context you want to deploy to.
## Running K8s-Status-Dashboard on Kubernetes

K8s-Status-Dashboard can run on a Kubernetes cluster. This is useful and effective when wanting to monitor more than one cluster.

    To update configs for K8s-Status-Dashboard on a Kubernetes cluster:

    ```
    $  bash migration-scripts/k8s_dashboard_migration_script.sh <vault-name> <environment-name> <namespace> 
    ```