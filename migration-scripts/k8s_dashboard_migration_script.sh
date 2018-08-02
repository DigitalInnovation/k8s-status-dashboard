#!/usr/bin/env bash
# shellcheck disable=SC2016
# shellcheck disable=SC1090

# This script will create the k8s secrets needed for the k8s-status-dashboard.
#
# - A KeyVault for the environment
# - A Cluster name
# - A K8s Namespace
#
# Once it has created these resources, ServicePrincipal Client ID and Client
# Secret will be saved in KeyVault and optionally, synced to k8s secret.


# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail
echo "VAULT_NAME is $@"
echo "ENVIRONMENT_NAME is $2"
echo "NAMESPACE is $3"

#repo_root="$( cd "$(dirname "$0")" ; pwd -P )"

VAULT_NAME="$1"
ENVIRONMENT_NAME="$2"
NAMESPACE="$3"

#VAULT_NAME=k8s-vault-upephflwk5tvq
rm -rf ./client.*
echo $VAULT_NAME

echo "Downloading secrets from $1 keyvault. This may take a few minutes...... "
az keyvault secret download -f client.key  --vault-name ${VAULT_NAME} --name client--key
az keyvault secret download -f client.crt  --vault-name ${VAULT_NAME} --name client--crt

echo "Base64 decoding the secrets retrieved from $1 keyvault. This may take a few minutes...... "
mv ./client.key ./client.key.temp
mv ./client.crt ./client.crt.temp
cat ./client.crt.temp | base64 --decode > ./client.crt
cat ./client.key.temp | base64 --decode > ./client.key

secret_name="k8s-status-$ENVIRONMENT_NAME-configs"
echo $secret_name

echo "DELETING secrets in kubernetes cluster. This may take a few minutes...... "
kubectl delete secret $secret_name --namespace=${NAMESPACE}

echo "Creating secrets in kubernetes cluster. This may take a few minutes...... "
kubectl create secret generic $secret_name  --from-file=./client.key  --from-file=./client.crt --namespace=${NAMESPACE}

echo "Removing secrets from local machine. This may take a few minutes...... "
rm -rf ./client.*

echo "The secrets have now been created. We are all DONE"
