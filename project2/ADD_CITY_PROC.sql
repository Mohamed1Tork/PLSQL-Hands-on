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
