-- drop sequence and create the sequence trigger pairs 
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
    v_sql varchar2(1000);
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
        
        -- Create sequence using dynamic SQL
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || seq_rec.table_name || '_SEQ ' ||
                          'START WITH ' || v_start_value || ' ' ||
                          'increment by 1' ||
                          'MAXVALUE 999999999999999999999999999 ' ||
                          'MINVALUE 1 ' ||
                          'NOCYCLE ' ||
                          'CACHE 20 ' ||
                          'NOORDER';
       -- Create the trigger using dynamic SQL
        v_sql := 'CREATE OR REPLACE TRIGGER ' || seq_rec.table_name || '_TRG ' ||
             'BEFORE INSERT ' ||
             'ON "HR"."' || seq_rec.table_name || '" ' || -- Fixed this line
             'REFERENCING NEW AS New OLD AS Old ' ||
             'FOR EACH ROW ' ||
             'BEGIN ' ||
               ':new.' || seq_rec.column_name || ' := ' || seq_rec.table_name || '_SEQ.nextval; ' ||
             'END ' || seq_rec.table_name || '_TRG;';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;