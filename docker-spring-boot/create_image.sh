#!/bin/bash

version="1.0.1"

build_and_run () {
    #build the docker image
    docker build -t spring-boot-headers:${version} .

    #run the image
    sudo docker run -d -p 8080:8080 -t spring-boot-headers:${version}
}

test_it () {
    curl -i -H  "traceID:1234" http://localhost:8080/test
    echo
}
upload_it () {
  docker tag 9afb395dd81f hepmkj1/java:spring-boot-headers
  docker push hepmkj1/java:spring-boot-headers
}


#build_and_run
#test_it
upload_it
