# netflixbluemix

This project tracks the activities and artifacts of deploying Netflix OSS based Micro-servcie solution to IBM Cloud (Bluemix). 
It is maintained by IBM Cloud Lab Services and Cloud Solution Engineering team. 
The overall project consists of multiple sub projects:

 - Customized Netflix docker image build files
 - Sample Spring Boot applications to access DB2 and other Bluemix services such as RabbitMQ, ElasticSearch
 - Docker compose solution


 * Build the Spring Boot apps:

 - Build the microservice app to access MySQL service and demonstrate Hystrix circuit breaker:

 	$ cd microservice
 	$ ./gradlew build

 	To run the app:
 	$ ./gradlew build && java -jar build/libs/gs-spring-boot-0.1.0.jar

- Build the Eureka Server:

 	$ cd eurekaserver
 	$ ./gradlew build

 	To run the server:
 	$ ./gradlew build && java -jar build/libs/eureka-spring-boot-0.1.0.jar

 - Build the Zuul Proxy:

 	$ cd zuulproxy
 	$ ./gradlew build

 	To run the Proxy:
 	$ ./gradlew build && java -jar build/libs/zuul-spring-boot-0.1.0.jar

 - Build the microservice app to access DB2 instance on SoftLayer:

 	$ cd db2microservice
 	$ ./gradlew build

 	To run the app:
 	$ ./gradlew build && java -jar build/libs/gc-spring-boot-db2-0.1.0.jar

 - Build the microservice app to access RabbitMQ Bluemix Service:

 	$ cd mqmicroservice
 	$ ./gradlew build

 	To run the app:
 	$ ./gradlew build && java -jar build/libs/gc-rabbitmq-0.1.0.jar

 
 
