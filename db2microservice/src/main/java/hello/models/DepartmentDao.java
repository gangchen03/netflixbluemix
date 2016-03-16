package hello.models;

import javax.transaction.Transactional;

import org.springframework.data.repository.CrudRepository;

/**
 * JPA DOA Object
 * 
 * @author gchen
 */
@Transactional
public interface DepartmentDao extends CrudRepository<Department, Long> {

  /**
   * 
   */

}