#!/bin/bash
# Files are ordered in proper order with needed wait for the dependent custom resource definitions to get initialized.
# Usage: bash kubectl-apply.sh

logSummary(){
    echo ""
    echo "#####################################################"
    echo "Please find the below useful endpoints,"
    echo "Crawler Console - http://crawler-console.cooly-crawler"
    echo "#####################################################"
}

kubectl apply -f namespace.yml
kubectl apply -f registry/
kubectl label namespace cooly-crawler istio-injection=enabled --overwrite=true
kubectl apply -f authservice/
kubectl apply -f configurer/
kubectl apply -f fetcher/
kubectl apply -f indexer/
kubectl apply -f parser/
kubectl apply -f scheduler/
kubectl apply -f console/

logSummary
