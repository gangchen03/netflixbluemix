#!/usr/bin/env bash

##############################################################################
##
##  Wrapper sript to build all subproject
##
##############################################################################

echo 'Build all projects...'

echo 'Build Eureka Server ***'
cd eurekaserver
./gradlew build
cp build/libs/eureka-spring-boot-0.1.0.jar docker/app.jar
cd ..

echo 'Build Eureka DR Server ***'
cd eurekaserverdr
./gradlew build
cp build/libs/eureka-spring-boot-0.1.0.jar docker/app.jar
cd ..


echo 'Build Zuul Proxy ***'
cd zuulproxy
./gradlew build
cp build/libs/zuul-spring-boot-0.1.0.jar docker/app.jar
cd ..

echo 'Build MySQL microservice ***'
cd microservice
./gradlew build
cp build/libs/gs-spring-boot-0.1.0.jar docker/app.jar
cd ..


echo 'Build DB2 microservice ***'
cd db2microservice
./gradlew build
cp build/libs/gc-spring-boot-db2-0.1.0.jar docker/app.jar
cd ..

echo 'Build MQ microservice ***'
cd mqmicroservice
./gradlew build
cp build/libs/gc-rabbitmq-0.1.0.jar docker/app.jar
cd ..

echo 'Completed All Builds successfully!'