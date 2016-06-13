#!/usr/bin/env bash

##############################################################################
##
##  Wrapper sript to build all subproject
##
##############################################################################

BASEDIR=$(pwd)

echo 'Build all projects...'

echo 'Build Eureka Server ***'
cd ../netflixbluemix-core/eurekaserver
./gradlew build
cp build/libs/eureka-spring-boot-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build Eureka DR Server ***'
cd ../netflixbluemix-core/eurekaserverdr
./gradlew build
cp build/libs/eureka-spring-boot-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build Zuul Proxy ***'
cd ../netflixbluemix-core/zuulproxy
./gradlew build
cp build/libs/zuul-spring-boot-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build Turbine Server ***'
cd ../netflixbluemix-core/turbine
./gradlew build
cp build/libs/turbine-spring-boot-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build MySQL microservice ***'
cd ../netflixbluemix-mysql/microservice
./gradlew build
cp build/libs/gs-spring-boot-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build DB2 microservice ***'
cd ../netflixbluemix-db2/db2microservice
./gradlew build
cp build/libs/gc-spring-boot-db2-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build MQ microservice ***'
cd ../netflixbluemix-mq/mqmicroservice
./gradlew build
cp build/libs/gc-rabbitmq-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Build ElasticSearch Sample App ***'
cd ../netflixbluemix-elasticsearch/elasticsearchservice
./gradlew build
cp build/libs/gc-elasticsearch-0.1.0.jar docker/app.jar
cd ${BASEDIR}

echo 'Completed All Builds successfully!'
