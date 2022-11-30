    -- to connect to the DBA account do:
connect sys/sys as sysdba
   -- to create a spool file do:
SPOOL C:\BD2\s14_spool.txt
SELECT to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am')
FROM   dual;

    -- to display the current connection
show user
    -- to remove a user do:
    -- Syntax:  DROP USER name_of_user CASCADE ;
DROP USER any1 CASCADE;
    -- to create a user do:
    -- Syntax:  CREATE USER name_of_user IDENTIFIED BY password ;
CREATE USER any1 IDENTIFIED BY 123;
    -- to provide needed privileges to a user do:
    -- Syntax:  GRANT connect, resource TO name_of_user;
GRANT connect, resource, UNLIMITED TABLESPACE TO any1;
    -- to connect a normal user to the database do:
    -- Syntax:  connect name_of_user/password
connect any1/123

  -- PL/SQL is a block language:
  --  Syntax:
  --   BEGIN
  --     executable statement ;
  --   END;
  --   /
  -- Ex1:  Create an anonimous block that does nothing
BEGIN
  null;
END;
/
  -- Ex2:  Create a procedure named my_first that does nothing
  -- Syntax:  CREATE OR REPLACE PROCEDURE name_of_procedure
                    [(name_of_parameter MODE datatype, ...)] AS
  --   BEGIN
  --     executable statement ;
  --   END;
  --   /
CREATE OR REPLACE PROCEDURE my_first AS
  BEGIN
    null;
  END;
  /
  -- to find out the obects belonged to the current user do"
SELECT object_name, object_type FROM user_objects;
SELECT text FROM user_source;
  -- to run or execute a procedure do:
  -- Syntax:   EXECUTE name_of_procedure OR EXEC name_of_procedure
EXEC my_first

  -- Example 3:  Create a procedure named my_second with a variable
  -- of type NUMBER.  Assign number 5 to the variable just declared.
  -- (hint: declare the variable in the optional declaration section
  -- which is between the keyword AS and BEGIN
  -- Use the assigning operator := in the executable section
CREATE OR REPLACE PROCEDURE my_second AS
  -- declaration section
    v_variable1 NUMBER;
 BEGIN
   v_variable1 := 5 ;
 END;
/
  
-- Example 4:  Create a procedure named my_third with a variable
  -- of type NUMBER.  Assign any number to the variable just declared
  -- then display the contend of the variable EXACTLY as follow:
  --  The content of my variable is X !
  -- (hint: declare the variable in the optional declaration section
  -- which is between the keyword AS and BEGIN
  -- Use the assigning operator := in the executable section
  -- Use the build-in function PUT_LINE of the package DBMS_OUTPUT
  -- To display the content of the variable and use the concatenation
  -- operator || to join text and variable together.

CREATE OR REPLACE PROCEDURE my_third AS
  v_variable NUMBER;
  BEGIN
    v_variable := 59985;
    DBMS_OUTPUT.PUT_LINE('The content of my variable is ' || v_variable ||
                            ' !');
  END;
 /
-- We have to turn on the package DBMS_OUTPUT as follow:
SET SERVEROUTPUT ON

exec my_third

-- Example 5:  Create a procedure named p_3_time that accepts a number
  -- to display 3 time the input value as follow:
  --  Three time of X is Y !
  -- where X is the input , Y is 3 time the input value.

CREATE OR REPLACE PROCEDURE p_3_time (p_num_in IN NUMBER) AS
  v_num_in NUMBER;
  v_result NUMBER;
BEGIN
  v_num_in := p_num_in ;
  v_result := v_num_in * 3;
  DBMS_OUTPUT.PUT_LINE('Three time of '|| v_num_in || ' is '|| v_result ||' !');
END;
/

EXEC p_3_time (2)


SPOOL OFF;