package hello;

import com.google.common.collect.Lists;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@RestController
public class EmployeeRest
{
    private static final Logger logger = LoggerFactory.getLogger(EmployeeRest.class);

    @Autowired
    private EmployeeRepository employeeRepository;

    @RequestMapping("/rest/allemployees")
    public List<Employee> employees()
    {
        List<Employee> employees = new ArrayList<Employee>();

        Iterable<Employee> emps = employeeRepository.findAll();
        Iterator empIterator = emps.iterator();

        while (empIterator.hasNext())
        {
            employees.add((Employee)empIterator.next());
        }

        return employees;
    }

    @RequestMapping("/rest/allemployees/full")
    public Iterable<Employee> employeesInFull()
    {
        Iterable<Employee> emps = employeeRepository.findAll();
        Iterator empIterator = emps.iterator();

        return emps;
    }
}