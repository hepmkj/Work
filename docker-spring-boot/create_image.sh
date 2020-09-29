#!/bin/bash
#build the docker image
#sudo docker  build -t spring-boot:1.0.0 .

#run the image
#sudo docker run -d -p 8080:8080 -t spring-boot:1.0.0

create_docker_registry () {
kubectl create secret docker-registry regcred --docker-username=hepmkj1 --docker-password=Amit1718@ --docker-email=manojkumar.jha@equifax.com -n default
} 

create_docker_registry
