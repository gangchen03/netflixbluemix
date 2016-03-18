package hello;


import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.ApplicationContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


import javax.annotation.PostConstruct;

@SpringBootApplication
@EnableDiscoveryClient
public class Application {
    
    @Autowired
    private EmployeeRepository employeeRepository;

    public static void main(String[] args)
    {
        SpringApplication.run(Application.class, args);
    }

    @PostConstruct
    private void init()
    {
        employeeRepository.save(new Employee("1", "Lucia", "apicella", "Manager", 10));
        employeeRepository.save(new Employee("2", "Ted", "apicella", "Team Leader", 20));
        employeeRepository.save(new Employee("3", "Siena", "apicella", "Clerk", 30));
        employeeRepository.save(new Employee("4", "Lucas", "apicella", "Clerk", 30));
        employeeRepository.save(new Employee("5", "Gang", "Chen", "Clerk", 40));
        employeeRepository.save(new Employee("6", "Debbie", "Keys", "Clerk", 40));
    }
}