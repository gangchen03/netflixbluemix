package hello;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Controller
public class EmployeeController
{
    private static final Logger logger = LoggerFactory.getLogger(EmployeeController.class);

    @Autowired
    private EmployeeRepository employeeRepository;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String listProducts(Model model)
    {
        List<Employee> employees = new ArrayList<Employee>();

        Iterable<Employee> emps = employeeRepository.findAll();
        Iterator empIterator = emps.iterator();

        while (empIterator.hasNext())
        {
            employees.add((Employee)empIterator.next());
        }

        model.addAttribute("employees", employees);
        model.addAttribute("employeesCount", employees.size());
        model.addAttribute("searchStr", "");

        return "welcome";
    }

    @RequestMapping(value="/search", method = RequestMethod.POST)
    public String searchAlbums(@RequestParam(value="firstname") String firstname, Model model)
    {

        List<Employee> employees = new ArrayList<Employee>();

        Iterable<Employee> emps = employeeRepository.findByFirstNameContaining(firstname);
        Iterator empIterator = emps.iterator();

        while (empIterator.hasNext())
        {
            employees.add((Employee)empIterator.next());
        }

        model.addAttribute("employees", employees);
        model.addAttribute("employeesCount", employees.size());
        model.addAttribute("searchStr", firstname);

        return "welcome";
    }

}