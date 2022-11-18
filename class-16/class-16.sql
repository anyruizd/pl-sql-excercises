-- PACKAGES
-- overloading is when several procedures have the same name, they have to be in the same package
-- i can use packages to declare global variables: they have to be in the same file

-- package has two parts: specification and body

create or replace package order_package is
    global_inv_id number(6);
    global_quantity number(6);
end;
/

-- anonymous block and call name of package and variables
begin
    order_package.global_quantity := 32;
    order_package.global_quantity := 100;
end;
/

-- creeate procedure to display content of global variable in the package

create or replace procedure ex_1 as
begin
    dbms_output.put_line('inv_id ' || order_package.global_inv_id);
    dbms_output.put_line('qty ' || order_package.global_quantity);
end;
/

exec ex_1

-- the top is a bodyless package!!!

-- this is a package specification with two procedures

create or replace package order_package is
    global_inv_id number(6);
    global_quantity number(6);
    procedure create_new_order(current_c_id number,
        current_meth_pmt VARCHAR2,
        current_os_id number);
    procedure create_new_order_line(current_o_id number);
END;
/

desc order_package

desc orders
-- package body

-- create or repace PACKAGE BODY order_package is
--     private variable declaration
--     unit program code (body of procedure/function)
-- end;
-- /

-- oracle has sequences to add secuentialy after the o_id
-- it increases 1 by 1 by default
create sequence order_sequence start with 7;
select order_sequence.nextval from dual;

create or repace PACKAGE BODY order_package is
    procedure create_new_order(current_c_id number,
        current_meth_pmt VARCHAR2,
        current_os_id number);
        BEGIN
            select order_sequence.nextval
            into current_o_id
            from dual;
            insert into orders
            values(current_o_id, sysdate, current_meth_pmt,
                current_new_order_line(current_o_id))
    procedure create_new_order_line(current_o_id number);
end;
/

-- run the package by putting it in an anonimous line or you exec the package procedure

exec order_package.create_new_order


-----------------------------------------------------------------------------------------

-- lecture

Menu du jour
  Return midterm
Solve Midterm



CREATE OR REPLACE FUNCTION riya_f1(p_dob DATE) RETURN NUMBER AS
  BEGIN
    RETURN FLOOR((sysdate - p_dob)/365.25);
  END;
/

--b
  SELECT riya_f1(sysdate) FROM dual;
  0

--C 
   CREATE OR REPLACE FUNCTION riya_f2(p1 NUMBER, p2 NUMBER) RETURN NUMBER AS
     BEGIN
       RETURN p1 + p2;
     END;
   /
-- d
  select RIYA_F2(2,3) from dual;
5

  CREATE OR REPLACE PROCEDURE riya_p1(p_empno NUMBER, p_percent NUMBER) as
     v_ename VARCHAR2(60);
     v_sal NUMBER;
     v_hiredate DATE;
     v_year NUMBER;
     v_increase NUMBER;
     v_new_sal NUMBER;
     BEGIN
       IF  p_percent >= 0 AND  p_percent <= 100 THEN 
          DBMS_OUTPUT.PUT_LINE('p_percent IS OK' );
          SELECT ename, sal, hiredate
          INTO   V_ename, V_sal, V_hiredate
          FROM   emp
          WHERE  empno = p_empno;
            DBMS_OUTPUT.PUT_LINE('p_empno IS OK' );
            v_year := riya_f1(v_hiredate);
            v_increase := V_sal * P_PERCENT/100;
            v_new_sal := riya_f2(v_sal,v_increase);
           DBMS_OUTPUT.PUT_LINE('EMPLOYEE ' || p_empno ||' is ' || v_ename ||
              ' hire date ' || v_hiredate ||
        ' year ex ' || v_year || ' old sal' || v_sal || ' NEW sal ' || v_new_sal);
UPDATE emp SET sal = v_new_sal
                WHere empno = p_empno;
       ELSE
           DBMS_OUTPUT.PUT_LINE('Please inser number from 0 TO 100!' );
       END IF;
COMMIT;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         DBMS_OUTPUT.PUT_LINE('EMPLOYEE ' || p_empno ||' not exist');
    END;
   /
set serveroutput on
--  F 
exec riya_p1(2,50)

exec riya_p1(2,100)

empno = 2
ename = April
sal 2105
new sal 4210
hire date 


-- c
   

Q2

 CREATE OR REPLACE PROCEDURE riya_p1a(p_percent NUMBER)  AS
      CURSOR inv_curr IS
         SELECT inv_ID, INV_PRICE, INV_QOH, COLOR
         FROM   inventory;
      v_inv_row inv_curr%ROWTYPE;
      v_new_price NUMBER;
      v_value NUMBER ;
   BEGIN
     OPEN INV_curr ;
     FETCH inv_curr INTO  v_inv_row;
      WHILE inv_curr%FOUND LOOP
         v_new_price := v_inv_row.inv_price + v_inv_row.inv_price * p_percent/100;
         v_value := v_new_price * v_inv_row.inv_qoh;
 DBMS_OUTPUT.PUT_LINE('------------------------' );
         DBMS_OUTPUT.PUT_LINE('inventory id ' || v_inv_row.inv_id );

DBMS_OUTPUT.PUT_LINE('color ' || v_inv_row.color );
DBMS_OUTPUT.PUT_LINE('price ' || v_inv_row.inv_price );
DBMS_OUTPUT.PUT_LINE('new price' || v_new_price );
DBMS_OUTPUT.PUT_LINE('quantity ' || v_inv_row.inv_qoh );
DBMS_OUTPUT.PUT_LINE('VALUE ' || v_value );
       FETCH inv_curr INTO  v_inv_row;
       END LOOP;
     CLOSE inv_curr;
  END;
  /
SET SERVEROUTPUT ON
exec riya_p1A(-50)





CREATE OR REPLACE PROCEDURE riya_p3(p_percent NUMBER)  AS
      CURSOR inv_curr IS
         SELECT inv_ID, INV_PRICE, INV_QOH, COLOR
         FROM   inventory
        FOR UPDATE OF inv_price;
      v_inv_row inv_curr%ROWTYPE;
      v_new_price NUMBER;
      v_value NUMBER ;
   BEGIN
     OPEN INV_curr ;
     FETCH inv_curr INTO  v_inv_row;
      WHILE inv_curr%FOUND LOOP
         v_new_price := v_inv_row.inv_price + v_inv_row.inv_price * p_percent/100;
         v_value := v_new_price * v_inv_row.inv_qoh;
 DBMS_OUTPUT.PUT_LINE('------------------------' );
         DBMS_OUTPUT.PUT_LINE('inventory id ' || v_inv_row.inv_id );

DBMS_OUTPUT.PUT_LINE('color ' || v_inv_row.color );
DBMS_OUTPUT.PUT_LINE('price ' || v_inv_row.inv_price );
DBMS_OUTPUT.PUT_LINE('new price' || v_new_price );
DBMS_OUTPUT.PUT_LINE('quantity ' || v_inv_row.inv_qoh );
DBMS_OUTPUT.PUT_LINE('VALUE ' || v_value );
            UPDATE inventory SET inv_price = v_new_price
            WHERE CURRENT OF inv_curr;

       FETCH inv_curr INTO  v_inv_row;
       END LOOP;
     CLOSE inv_curr;
   COMMIT;
  END;
  /
SET SERVEROUTPUT ON
exec riya_p3(10)





  Lecture on Package
 




Nov 11    Lecture on Packages
     16  Project Part 8
     18  Lecture OverLoading 
     23  Project Part 9    
     25  Lecture Database trigger
     30  Project Part 10
  Dec 2     Lecture Instead of trigger   +  Projet part BONUS 
     6  SIMULATION FINAL  
    7  Solve Simulation Final + answer last minute questions

Dec     9     FINAL EXAM   time   9:00     room














------------------- PACKAGE -----------------------------

   Package has 2 parts   -- Package Specification
                         -- Package BODY
a/
     Specification
                  Syntax:
    CREATE OR REPLACE PACKAGE name_of_package IS
      declaration variable
      declaration cursor
      declaration procedure or function
    END;
/

Ex:
    CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
    END;
    /




BEGIN
  order_package.global_inv_id := 25;
  order_package.global_quantity := 1;
END;
/

-- Ex1:  Create a procedure to display the content of the 
-- global variable of the package ORDER_PACKAGE

   CREATE OR REPLACE PROCEDURE ex1 AS
     BEGIN
       DBMS_OUTPUT.PUT_LINE('inv id ' || 
              order_package.global_inv_id);
       DBMS_OUTPUT.PUT_LINE('Quantity ' ||
              order_package.global_quantity);
     END;
   /

SET serveroutput on
exec ex1;

Add procedure to the package

  CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
      PROCEDURE create_new_order(current_c_id NUMBER, 
              current_meth_pmt VARCHAR2, 
              current_os_id NUMBER);
      PROCEDURE create_new_order_line(current_o_id NUMBER);
    END;
    /

--------------- Package BODY  -----------
   Syntax:
        CREATE OR REPLACE PACKAGE BODY name_of_package IS
              private variable declaration
              UNIT PROGRAM CODE (body of procedure/function)
        END;
        /

CREATE SEQUENCE order_sequence START WITH 7;

SELECT order_sequence.NEXTVAL from DUAL;

CREATE OR REPLACE PACKAGE BODY order_package IS

    PROCEDURE create_new_order(current_c_id NUMBER, current_meth_pmt VARCHAR2, 
                                current_os_id NUMBER) AS
            current_o_id NUMBER;
        BEGIN
            SELECT order_sequence.NEXTVAL
            INTO   current_o_id
            FROM   dual;
            INSERT INTO orders 
            VALUES(current_o_id, sysdate, current_meth_pmt,
                    current_c_id, current_os_id);
            create_new_order_line(current_o_id);
            COMMIT;
    END create_new_order;

    PROCEDURE create_new_order_line(current_o_id NUMBER) AS
            BEGIN
               INSERT INTO order_line 
               VALUES(current_o_id, global_inv_id, global_quantity);
               COMMIT;
    END create_new_order_line;
END;
/

BEGIN
  order_package.global_inv_id := 32;
  order_package.global_quantity := 2000;
END;
/ 

CREATE OR REPLACE PROCEDURE riya_p5 AS
BEGIN
  order_package.create_new_order(3,'Cash',1);
END;
/

EXEC order_package.create_new_order(4,'FAVOR',6)