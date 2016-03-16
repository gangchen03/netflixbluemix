package hello;

import java.util.Arrays;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.ApplicationContext;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

//import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;

@SpringBootApplication
@EnableDiscoveryClient
@EnableZuulProxy
public class ZuulProxy {

    public static void main(String[] args) {
        ApplicationContext ctx = SpringApplication.run(ZuulProxy.class, args);

        System.out.println("Start Spring Boot Zuul Reverse Proxy on IBM Bluemix");

    }

}
