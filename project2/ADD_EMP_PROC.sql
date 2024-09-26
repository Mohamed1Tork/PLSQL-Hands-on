CREATE OR REPLACE PROCEDURE add_emp 
IS 
    CURSOR employees_cur IS
        SELECT * FROM employees_temp;
    
    v_email VARCHAR2(25); 
    v_date DATE;
    v_job_id VARCHAR2(10); 
    v_dept_id NUMBER;
    v_sal number;
    v_loc_id NUMBER;
BEGIN
    FOR v_rec IN employees_cur LOOP 
       -- convert the salary data type to numeric
       v_sal := TO_NUMBER(v_rec.salary);
        -- Convert hire_date to DATE format
        v_date := TO_DATE(v_rec.hire_date, 'DD/MM/YYYY');    
        -- Convert email  format in employees_temp  to email format in emolyees
       v_email := upper(SUBSTR(v_rec.first_name, 1, 1))||upper(v_rec.last_name);
        IF INSTR(v_rec.email , '@') > 0 THEN
            add_city;
            add_department;
            add_job;
            -- Retrieve location_id based on city
        SELECT location_id INTO v_loc_id FROM locations WHERE city = v_rec.city;
        -- Retrieve job_id based on job_title
        SELECT job_id INTO v_job_id FROM jobs WHERE job_title = v_rec.job_title;
        -- Retrieve department_id based on department_name
        SELECT department_id INTO v_dept_id FROM departments WHERE department_name = v_rec.department_name  and location_id = v_loc_id;
            INSERT INTO employees 
            (employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id)
            VALUES 
            (employees_seq.nextval, v_rec.first_name, v_rec.last_name, v_email, v_date, v_job_id, v_sal, v_dept_id);
        END IF;
    END LOOP;
END;
