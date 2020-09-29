#!/bin/bash

deploy_app_with_opa () {
    echo 'Deleting the cluster: '
    minikube delete

    echo 'Starting the cluster: '
    minikube start

    echo "Creating config map 'proxy-config'  from the file 'envoy.yaml':  "
    kubectl create configmap proxy-config --from-file envoy.yaml

    echo "Creating secret for deploying policy  file  from 'policy.rego': "
    kubectl create secret generic opa-policy --from-file policy.rego

    echo "Deploying app with  opa and envoy sidecar: "
    kubectl apply -f deployment.yaml

    echo "Creating a service to expose HTTP  server"
    kubectl expose deployment example-app --type=NodePort --name=example-app-service  --port=8080

    echo ""
    echo ""
    echo ""
    echo "Wait for all contianers to  come up"
    kubectl  get po
}

SERVICE_URL=""
get_service_url () {
    export SERVICE_PORT=$(kubectl get service example-app-service -o jsonpath='{.spec.ports[?(@.port==8080)].nodePort}')
    export SERVICE_HOST=$(minikube ip)
    export SERVICE_URL=$SERVICE_HOST:$SERVICE_PORT
    echo "SERVICE URL:  $SERVICE_URL"
}

test_it () {

    export ALICE_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiZ3Vlc3QiLCJzdWIiOiJZV3hwWTJVPSIsIm5iZiI6MTUxNDg1MTEzOSwiZXhwIjoxNjQxMDgxNTM5fQ.K5DnnbbIOspRbpCr2IKXE9cPVatGOCBrBQobQmBmaeU"
    export BOB_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYWRtaW4iLCJzdWIiOiJZbTlpIiwibmJmIjoxNTE0ODUxMTM5LCJleHAiOjE2NDEwODE1Mzl9.WCxNAveAVAdRCmkpIObOTaSd0AJRECY2Ch2Qdic3kU8"
    
    echo ""
    echo ""
    echo "Alice can do  the GET request: "
    echo "curl -i -H \"Authorization: Bearer \"$BOB_TOKEN\"\" http://$SERVICE_URL/people"
    curl -i -H "Authorization: Bearer "$BOB_TOKEN"" http://$SERVICE_URL/people

    echo ""
    echo ""
    echo "Alice cannot do  the POST request: "

    echo "curl -i -H \"Authorization: Bearer \"$BOB_TOKEN\"\" -d '{\"firstname\":\"Bob\", \"lastname\":\"Rego\"}' -H \"Content-Type: application/json\" -X POST  http://$SERVICE_URL/people"
    curl -i -H "Authorization: Bearer "$BOB_TOKEN"" -d '{"firstname":"Bob", "lastname":"Rego"}' -H "Content-Type: application/json" -X POST  http://$SERVICE_URL/people

}

test_spring_boot () {
get_service_url
curl -i -X GET http://${SERVICE_URL}/test
echo
curl -i -X POST http://${SERVICE_URL}/test
echo
}

#deploy_app_with_opa
test_spring_boot
#test_it
