package hello;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.List;

public interface EmployeeRepository extends ElasticsearchRepository<Employee, String>
{

    public List<Employee> findByFirstNameContaining(String firstName);
}