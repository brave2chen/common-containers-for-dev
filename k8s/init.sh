#!/bin/bash
echo "change kubectl context to docker-desktop"
kubectl config use-context docker-desktop
docker pull docker.io/istio/operator:1.9.2
echo "Deploy the Istio operator"
./istio-1.9.2/bin/istioctl operator init
kubectl apply -f 01.common
kubectl apply -f 02.istio
kubectl apply -f 03.monitoring
kubectl apply -f 04.infrastructure
kubectl apply -f 05.app