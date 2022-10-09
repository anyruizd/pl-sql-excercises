--Menu du jour
--  UPDATE or INSERT ???? answer with pre-defined exception NO_DATA_FOUND
-- Create a procedure that accepts an employee number and a job the procedure will
--update the employee with the new job if the employee existed otherwise insert 
--Oleksandr with a default salary of $1. Print out the following:

--  Employee X is Y. He is a Z earning $M a month !
--Where X is the empno, Y is the ename, Z is job and M is the salary.


SELECT table_name FROM user_tables;
desc emp

CREATE OR REPLACE PROCEDURE p_s28_employee(p_empno NUMBER, p_job VARCHAR2) AS
  v_ename emp.ename%TYPE;
  v_sal   emp.sal%TYPE;
BEGIN
  SELECT ename, sal
  INTO   v_ename, v_sal
  FROM   emp
  WHERE  empno = p_empno;

  
  UPDATE emp SET job = p_job WHERE empno = p_empno; 
  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' UPDATED!');
  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' is '|| v_ename ||
    '. He is a '|| p_job || ' earning $'|| v_sal || ' a month !');
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    INSERT INTO emp(empno, ename, sal, job)
    VALUES(p_empno, 'Oleksandr',1,p_job);
  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || '  INSERTED!');
  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' is Oleksandr. He is a '|| 
             p_job || ' earning $1 a month !');
  COMMIT;
END;
/
set serveroutput on
exec p_s28_employee(7369,'CLERK')








  