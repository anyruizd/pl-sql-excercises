SPOOL './holi.txt'
SELECT to_char(SYSDATE, 'DD Month YYYY Day HH:MI:SS Am')
FROM dual;
-- Ex1: Anonymous block: no name, no saved into the DB
BEGIN
    null;
END;
/

-- EX2: A block with a name can be procedure or function and can be saved
-- into the database

CREATE OR REPLACE PROCEDURE my_first AS
BEGIN
    null;
END;
/

-- I need to figure out how to connect as a different user
-- SELECT object_name, object_type FROM user_objects;

-- EXECUTE my_first 
EXEC my_first

CREATE OR REPLACE PROCEDURE my_second AS
-- declaration section
v_variable1 NUMBER;
BEGIN
    v_variable1 := 5;
END;
/

EXEC my_second

CREATE OR REPLACE PROCEDURE my_third AS
-- declaration section
v_variable NUMBER;
BEGIN
    v_variable := 59985;
    DBMS_OUTPUT.PUT_LINE('The content of my variable is ' || v_variable || ' !');
END;
/
-- For the new user you need to turn on the package DBMS_...
-- SET SERVEROUTPUT ON
EXEC my_third

CREATE OR REPLACE PROCEDURE p_3_time(p_num_in IN NUMBER) AS
    v_num_in NUMBER;
    v_result NUMBER;
BEGIN
    v_num_in := p_num_in;
    v_result := v_num_in * 3;
    DBMS_OUTPUT.PUT_LINE('Three time of ' || v_num_in || ' is ' || v_result || ' !');
END;
/

EXEC p_3_time(26387448)

SPOOL OFF;