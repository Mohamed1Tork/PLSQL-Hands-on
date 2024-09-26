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

