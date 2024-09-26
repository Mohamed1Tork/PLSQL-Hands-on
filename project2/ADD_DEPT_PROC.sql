-- procedure to add the departments that not exist in the departments table 
CREATE OR REPLACE PROCEDURE add_department
IS
    CURSOR departments_cur IS
        SELECT department_name, city
        FROM employees_temp;
    v_department_exists NUMBER;
    v_loc_id NUMBER;
BEGIN
    FOR v_rec IN departments_cur LOOP
         -- Retrieve location_id based on city
        SELECT location_id INTO v_loc_id FROM locations WHERE city = v_rec.city;
        -- Check if department exists
        SELECT COUNT(*)
        INTO v_department_exists
        FROM departments
        WHERE department_name = v_rec.department_name
        and location_id = v_loc_id ;
      

        IF v_department_exists = 0 THEN
            INSERT INTO departments (department_id, department_name, location_id)
            VALUES (departments_seq.nextval, v_rec.department_name, v_loc_id);
        END IF;
    END LOOP;
END;

