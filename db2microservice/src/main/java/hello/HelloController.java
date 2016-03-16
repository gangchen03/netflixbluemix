package hello;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {

    @RequestMapping("/helloboot")
    public String index() {
        return "Hello from Spring Boot micro-service deployed in IBM Bluemix Container!";
    }

}
