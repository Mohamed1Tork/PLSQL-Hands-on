-- drop sequence and create them again 
DECLARE 
    CURSOR c IS 
        SELECT DISTINCT c.table_name, c.column_name
        FROM all_tab_columns a
        JOIN all_cons_columns c ON a.column_name = c.column_name
        JOIN all_constraints cn ON c.constraint_name = cn.constraint_name
        WHERE a.data_type = 'NUMBER'
          AND cn.constraint_type = 'P'
          AND a.owner = 'HR'
          AND (SELECT COUNT(DISTINCT column_name) 
               FROM all_cons_columns c2 
               WHERE c2.constraint_name = cn.constraint_name) = 1;
    
    v_start_value NUMBER;
BEGIN
    FOR seq_rec IN c LOOP
        EXECUTE IMMEDIATE 'SELECT MAX(' || seq_rec.column_name || ') + 1 FROM ' || seq_rec.table_name INTO v_start_value;
        
        -- Drop sequence if it exists
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || seq_rec.table_name || '_SEQ';
        EXCEPTION
            WHEN OTHERS THEN
                NULL; -- Ignore if sequence doesn't exist
        END;
        
        -- Create sequence
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || seq_rec.table_name || '_SEQ ' ||
                          'START WITH ' || v_start_value || ' ' ||
                          'MAXVALUE 999999999999999999999999999 ' ||
                          'MINVALUE 1 ' ||
                          'NOCYCLE ' ||
                          'CACHE 20 ' ||
                          'NOORDER';
    END LOOP;
END;
-------------------------------------------------------------------
-- procedure to add the cities that not exist in the locatios table 
CREATE OR REPLACE PROCEDURE add_city
IS
    CURSOR cities IS
        SELECT city
        FROM employees_temp;
    v_city_exists NUMBER;
BEGIN
    FOR v_rec IN cities LOOP
        -- Check if city exists in locations
        SELECT COUNT(*)
        INTO v_city_exists
        FROM locations
        WHERE city = v_rec.city;

        IF v_city_exists = 0 THEN
            INSERT INTO locations (location_id, city)
            VALUES (locations_seq.nextval, v_rec.city);
        END IF;
    END LOOP;
END;
--------------------------------------------------------------------------
-- procedure to add the jobs that not exist in the jobs table 
CREATE OR REPLACE PROCEDURE add_job
IS
    CURSOR job_titles IS
        SELECT job_title
        FROM employees_temp;
    v_job_exists NUMBER;
    v_job_title_short VARCHAR2(3);
BEGIN
    FOR v_rec IN job_titles LOOP
        -- Extract the first 3 characters of the job title
        v_job_title_short := upper(SUBSTR(v_rec.job_title, 1, 3));
        
        -- Check if job title exists in jobs table
        SELECT COUNT(*)
        INTO v_job_exists
        FROM jobs
        WHERE job_title = v_rec.job_title;

        IF v_job_exists = 0 THEN
            -- Insert the job title with the first 3 characters
            INSERT INTO jobs (job_id, job_title)
            VALUES (v_job_title_short, v_rec.job_title);
        END IF;
    END LOOP;
END;

-------------------------------------------------------------
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

--------------------------------------------------------------------------
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


BEGIN 
    ADD_EMP;
END;
