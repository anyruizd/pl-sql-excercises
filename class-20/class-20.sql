-- Dec 2      Solve Part 9, Part 10 + Continue with part Bonus
--  Tuesday Dec 6  4:00 Pm  SIMULATION FINAL    
--  Wednesday Dec   7  Solve Simulation Final + answer last minute questions

-- Dec     9     FINAL EXAM   time   9:00     room

---------------------------------
-- What is a View?
--   Is a SELECT statement looks like a table
-- Why view?
--   -- For sensitive data
--   -- To make the select statement simpler
-- Example 1:  Create a view named employee with column empno,
-- ename,job, and deptno of table emp. Give User Prachi full
-- access to the view created so that Prachi  can manipulate the
-- data of the view.

  -- scott
connect scott/tiger
CREATE OR REPLACE VIEW employee AS
  SELECT empno, ename, job, deptno
  FROM   emp;
GRANT SELECT, INSERT, UPDATE, DELETE ON employee TO Prachi;

connect sys/sys as sysdba;
GRANT CREATE VIEW TO scott;


-- Prachi
   SELECT * FROM scott.employee;
   UPDATE scott.employee
   SET ename = 'Prachi', job = 'MANAGER'
   WHERE empno = 7934;


-- Example 2: Create a view name emp_dept_view with column 
-- empno, ename, sal, deptno from table emp and dname from table dept

CREATE OR REPLACE VIEW	 emp_dept_view AS
SELECT empno, ename, sal, dept.deptno, dname
FROM   emp ,dept
WHERE  emp.deptno = dept.deptno;

-- scott
GRANT SELECT , INSERT, UPDATE, DELETE ON emp_dept_view 
TO Prachi;
-- Prachi
  SELECT * FROM scott.emp_dept_view;
  UPDATE scott.emp_dept_view
  SET   sal = 5001
  WHERE empno = 7934;  ok

  UPDATE scott.emp_dept_view
  SET   dname = 'SALES'
  WHERE deptno = 10;  Not ok

------------------ INSTEAD OF TRIGGER ----------------
--   Syntax:
--     CREATE OR REPLACE TRIGGER name_of_trigger
--     INSTEAD OF INSERT | UPDATE | DELETE ON name_of_view
--     FOR EACH ROW
--       BEGIN
--          executable statement;
--       END;
--     /
-- Second Last example of the course databases II
--   Create an instead of trigger for the view of example 2
-- so that the user can update the data of the view
-- emp_dept_view.

CREATE OR REPLACE TRIGGER instead_emp_dept
INSTEAD OF UPDATE ON emp_dept_view
FOR EACH ROW
  BEGIN
    UPDATE emp
    SET ename = :NEW.ename, sal = :NEW.sal, 
        deptno  = :NEW.deptno
    WHERE empno = :NEW.empno;

    UPDATE dept
    SET    dname = :NEW.dname
    WHERE  deptno = :NEW.deptno;
  END;
/
Testing

UPDATE scott.emp_dept_view
  SET   dname = 'COOKING'
  WHERE deptno = 10;   ok now


------------------------------------- USER DEFINED EXCEPTION ----------------
  -- Predefined EXCEPTION
--         NO_DATA_FOUND , TOO_MARY_ROWS ,...


--      Create a procedure that accept an employee number to display the employee
--  name, salary, and job.  If the employee earns less than 1000 , it is considered
-- as an error (EXCEPTION) .  Handle this error with the follwing message:

--    Emloyee working under the minimal salary. Can not reveal name.

   CREATE OR REPLACE PROCEDURE last_procedure_f22(p_empno NUMBER) AS
     v_sal NUMBER;
     v_ename VARCHAR2(50);
     v_job VARCHAR2(50);
     e_under_1000 EXCEPTION;
      BEGIN
        SELECT ename, sal, job
        INTO   v_ename, v_sal, v_job
        FROM   emp
        WHERE  empno = p_empno;

        IF v_sal < 1000 THEN
           RAISE e_under_1000;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Employee '|| v_ename || ' is a ' || v_job ||
              ' earning $'  || v_sal || ' a month.');

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' NOT exist');
        WHEN e_under_1000 THEN

           DBMS_OUTPUT.PUT_LINE('Emloyee working under the minimal salary. Can not reveal name.');

      END;
      /
set serveroutput on
EXEC last_procedure_f22(7934)