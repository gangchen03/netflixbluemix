package hello;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

@Document(indexName = "employee", type = "employee", shards = 1, replicas = 0, refreshInterval = "-1")
public class Employee
{
    @Id
    private String id;
    private String firstName;
    private String lastName;
    private String job;
    private int deptNo;

    public Employee()
    {
    }

    public Employee(String id, String firstName, String lastName, String job, int deptNo) {
        this.deptNo = deptNo;
        this.firstName = firstName;
        this.id = id;
        this.job = job;
        this.lastName = lastName;
    }

    public int getDeptNo() {
        return deptNo;
    }

    public void setDeptNo(int deptNo) {
        this.deptNo = deptNo;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "deptNo=" + deptNo +
                ", id='" + id + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", job='" + job + '\'' +
                '}';
    }
}