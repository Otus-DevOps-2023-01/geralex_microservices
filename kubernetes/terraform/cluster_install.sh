#!/bin/bash

set -e

cd terraform
TF_IN_AUTOMATION=1 terraform init
TF_IN_AUTOMATION=1 terraform apply -auto-approve

#Обновляем kube config
yc managed-kubernetes cluster get-credentials k8s-master --external

#Устанавливаем ingress-controller
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml
helm list -n ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
#helm upgrade --reuse-values ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx

kubectl get ingress -n dev