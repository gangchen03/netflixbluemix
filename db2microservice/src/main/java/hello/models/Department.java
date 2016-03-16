package hello.models;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * Entity Ojbect mapping with JPA
 *
 * @author gchen
 */
@Entity
@Table(name = "DEPARTMENT")
public class Department {
    
  
    @Id
    private String deptno;
    
  
    private String deptname;
    
   
    private String mgrno;
    
    
    private String admrdept;
    

    private String location;
    
    public Department() { }
    
    public String getDeptno() {
        return deptno;
    }
    
    public String getDeptname() {
        return deptname;
    }
    
    public String getMgrno() {
        return mgrno;
    }
    
    public String getAdmrdept() {
        return admrdept;
    }
    
    public String getLocation() {
        return location;
    }
    
}