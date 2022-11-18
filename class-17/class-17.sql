-- Overloading procedure

/*
    ename, job
    ename, sal
    empno, ename, job
    create ovdrloading procedure to insert a new employee using all the parameter 
    in case there is no empno provided, get a number from the sequence named employee_sequence 
    started with number 8000
*/

desc EMP

create or replace package employee_pkg is
    procedure emp_insert(p_ename VARCHAR2, p_job VARCHAR2);
    procedure emp_insert(p_ename VARCHAR2, p_sal NUMBER);
    procedure emp_insert(p_empno NUMBER, p_ename VARCHAR2, p_job VARCHAR2);
end;
/

-- desc employee_pkg
-- sequence for even numbers and no cached
create sequence emp_sequence start with 8000 increment by 2
nocache;

create or replace package body employee_pkg is
    procedure emp_insert(p_ename VARCHAR2, p_job VARCHAR2) as
        begin
            insert into emp(empno, ename, job)
            values(emp_sequence.nextval, p_ename, p_job);
            commit;
        end;
    procedure emp_insert(p_ename VARCHAR2, p_sal NUMBER) as
        begin
            insert into emp(empno, ename, job)
            values(emp_sequence.nextval, p_ename, p_sal);
            commit;
        end;
    procedure emp_insert(p_empno NUMBER, p_ename VARCHAR2, p_job VARCHAR2) as
        begin
            insert into emp(empno, ename, job)
            values(p_empno, p_ename, p_job);
            commit;
        end;
end;
/

exec employee_pkg.emp_insert('salomon', 5001)
exec employee_pkg.emp_insert('Tue', 'F.B.I')
exec employee_pkg.emp_insert(8888,'Thiago', 'Manager')

--------------------- RESTRICTION -----------------------
/*
    Overloading  procedure with the same name of parameters can not have the parameter of the same family
*/

Menu du jour
  OVERLOADING Procedure / Function
  Continue with Project Part 8

Ename, job
Ename, sal
Empno, Ename, job
...

Create an OVERLOADING procedure to insert a new employee
using all the parameter mentioned above.  In case there is
no empno provided, get a number from the sequence named
employee_sequence started with number 8000.

connect scott/tiger
CREATE OR REPLACE PACKAGE employee_package IS
  PROCEDURE emp_insert(p_Ename VARCHAR2, P_job VARCHAR2);
  PROCEDURE emp_insert(p_Ename VARCHAR2, P_sal NUMBER);
  PROCEDURE emp_insert(p_empno NUMBER ,p_Ename VARCHAR2,
                            P_job VARCHAR2);
END;
/

CREATE SEQUENCE emp_sequence START WITH 8000 INCREMENT BY 2
NOCACHE;

CREATE OR REPLACE PACKAGE BODY employee_package IS
  PROCEDURE emp_insert(p_Ename VARCHAR2, P_job VARCHAR2) AS
     BEGIN
       INSERT INTO emp(empno, ename, job)
       VALUES(emp_sequence.NEXTVAL, p_Ename, P_JOB);
       COMMIT;
     END;
  PROCEDURE emp_insert(p_Ename VARCHAR2, P_sal NUMBER)AS
     BEGIN
       INSERT INTO emp(empno, ename, sal)
       VALUES(emp_sequence.NEXTVAL, p_Ename, P_sal);
       COMMIT;
     END;
  PROCEDURE emp_insert(p_empno NUMBER ,p_Ename VARCHAR2,
                            P_job VARCHAR2)AS
     BEGIN
       INSERT INTO emp(empno, ename, job)
       VALUES(p_empno, p_Ename, P_JOB);
       COMMIT;
     END;
END;
/

exec employee_package.emp_insert(10,'Salomon','PROGRAM')
exec employee_package.emp_insert('Tue','F.B.I')
exec employee_package.emp_insert(8888,'Thiago','MANAGER')

------------------------- RESTRICTION ----------------
Overloading procedure with the same number of parameters
can not have the parameter of the same FAMILY

  PROCEDURE customer_insert (p_custname VARCHAR2, P_phone NUMBER);
  PROCEDURE customer_insert (p_address CHAR, P_phone NUMBER);

  exec X.custmer_insert('Salomon', 1234);
  exec X.custmer_insert('123 Street', 1234);

PROCEDURE customer_insert (p_custname VARCHAR2, P_phone NUMBER);
  PROCEDURE customer_insert (p_custname VARCHAR2, P_ID INTEGER);
 
  exec X.custmer_insert('Salomon', 5141234567);
  exec X.custmer_insert('Salomon', 1);

--------------------------------------
  Function with the same number of parameter can not be differenciate
by only the returning datatype

   FUNCTION  find_value(p_input NUMBER)  RETURN NUMBER;
   FUNCTION  find_value(p_input NUMBER)  RETURN DATE;
   
     v_variable :=  X.find_value(11);


This is ok

  PROCEDURE customer_insert (p_custname VARCHAR2, P_phone NUMBER);
  PROCEDURE customer_insert (P_ID NUMBER, p_address VARCHAR2);


exec X.custmer_insert('Salomon', 5141234567);
exec X.custmer_insert(5141234567, 'STREET');


   
 