package hello;

import hello.models.Department;
import hello.models.DepartmentDao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

//import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
//import com.netflix.hystrix.contrib.javanica.annotation.HystrixProperty;

import org.springframework.web.client.RestTemplate;

/**
 * This is the main class interacts with ClearDB MySQL Database
 *
 * @author gchen
 */
@Controller
public class DepartmentController {

    @Autowired
  private DepartmentDao deptDao;

  
  /**
   * Add a new task
   * 
   * @param name Task name
   * @param description Task description
   * @return Add status
   */
/*  @RequestMapping("/create")
  @ResponseBody
  public String create(String description, String name) {
    Task task = null;
    try {
      task = new Task(description, name);
      deptDao.save(task);
    }
    catch (Exception ex) {
      return "Error adding task: " + ex.toString();
    }
    return "Task succesfully added! (id = " + task.getId() + ")";
  }*/
  
  /**
   * 
   * @param id task id
   * @return Delete status
   */
 /* @RequestMapping("/delete")
  @ResponseBody
  public String delete(long id) {
    try {
      Task task = new Task(id);
      deptDao.delete(task);
    }
    catch (Exception ex) {
      return "Error deleting the task:" + ex.toString();
    }
    return "Task succesfully deleted!";
  } */
  

  @RequestMapping("/department")
  @ResponseBody
  public String getAllDept() {
    String result = "";
    try {

    for (Department dept : deptDao.findAll()) {
        result = result + "<p>" + dept.getDeptno() + "-->" + dept.getDeptname() + "-->" + dept.getMgrno() + "</p>";
      }
    }
    catch (Exception ex) {
        ex.printStackTrace();    
      return "Department not found ";
    }
    return result;
  }

 /* public String failGood(String input) {
      return "Breaker, try later -> " + input;
    }

  @HystrixCommand(fallbackMethod="failGood")
  @RequestMapping("/circutbreaker")
  @ResponseBody
  public String testHystrix(String email) {
    RestTemplate restTemplate = new RestTemplate();
    String consumeJSONString = restTemplate.getForObject("http://169.44.1.151:8080/rest/v1/hello/to/IBM", String.class);
    return consumeJSONString;
  }*/

  /**
   *
   */
//  @RequestMapping("/update")
//  @ResponseBody
//  public String updateTask(long id, String description, String name) {
//    try {
//      Task task = deptDao.findOne(id);
//      task.setDescription(description);
//      task.setName(name);
//      deptDao.save(task);
//    }
//    catch (Exception ex) {
//      return "Error updating the task: " + ex.toString();
//    }
//    return "Task succesfully updated!";
//  }
  
}