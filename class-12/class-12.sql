-- cursor with parameter
/*
STEP 1
CURSOR name_of_the_cursor (name_of_parameter DATATYPE ) IS 
    select column1, column2, ...
    from name_of_table
    where column x = name_of_parameter;

*/

CURSOR EMP_CURR(PC_DEPTNO NUMBER) IS
    SELECT EMPNO, ENAME, SAL, DEPTNO
    FROM EMP
    WHERE DEPTNO = PC_DEPTNO;

-- STEP 2
/*
OPEN name_of_the_cursor (VALUE);

*/

OPEN EMP_CURR(30);

-- EX1: CREATE A PROCEDURE NAMED P_SHOW_ALL TO DISPLAY ALL DEPARTMENTS 
-- AND UNDER EACH DEPARTMENT DISPLAY ALL EMPLOYEES WORKING IN IT AS FOLLOW:
-- EMPLOYEE NUMBER X IS Y EARNING $Z FROM DEPARTMENT N 
-- WHERE X IS EMPNO
-- Y IS ENAME
-- Z IS SAL
-- N IS DEPTNO

CREATE OR REPLACE PROCEDURE P_SHOW_ALL AS
    -- STEP 1: DECLARE THE CURSOR
    CURSOR DEPT_CURR IS
        SELECT DEPTNO, DNAME, LOC
        FROM DEPT;
    V_DEPT_ROW DEPT_CURR%ROWTYPE;
    -- inner cursor with parameter STEP1
        CURSOR EMP_CURR(PC_DEPTNO NUMBER) IS
        SELECT EMPNO, ENAME, SAL, DEPTNO
        FROM EMP
        WHERE DEPTNO = PC_DEPTNO;
    V_EMP_ROW EMP_CURR%ROWTYPE;
BEGIN
    -- STEP 2: OPEN THE CURSOR
    OPEN DEPT_CURR;
    -- STEP 3: FETCH
    FETCH DEPT_CURR INTO V_DEPT_ROW;
        WHILE DEPT_CURR%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Department ' || V_DEPT_ROW.DEPTNO || ' is ' || 
            V_DEPT_ROW.DNAME || ' located in the city of ' || V_DEPT_ROW.LOC || '!');
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
                -- INNER CURSOR STEP 2
                    OPEN EMP_CURR(V_DEPT_ROW.DEPTNO) ;
                    -- step 3
                    FETCH EMP_CURR INTO V_EMP_ROW;
                    WHILE EMP_CURR%FOUND LOOP
                        DBMS_OUTPUT.PUT_LINE('Employee number ' || v_emp_row.empno || ' is ' || 
                        v_emp_row.ename || ', earning $' || v_emp_row.sal || ' from department number ' ||
                        v_emp_row.deptno || '.');
                        fetch emp_curr into v_emp_row;
                    END LOOP;
                    -- step 4
                    CLOSE EMP_CURR;
            FETCH DEPT_CURR INTO V_DEPT_ROW;
       END LOOP;
    -- STEP 4: CLOSE THE CURSOR
    CLOSE DEPT_CURR;
END;
/

exec P_SHOW_ALL

update emp set deptno = 40 where empno = 7844;
update emp set deptno = 40 where empno = 7900;

/*
    cursor name_of_cursor is
        select column1, column2, ...
        from name_of_table
        for update of name_of_column;
*/

cursor emp_curr is
select ename, sal
from emp
for update of sal;

use the where current of name_of_cursor to locate the row to be updated.

-- example 2: create a procedure to accept a number represent the percentage
-- increase or decrease in salary. The procedure will lock, update the slary and dsplay the following:

/*
Employee x, with %y increase in salary will bring home $z instead of $o
where z is new salary
o is old salary
x is name
y is percentage increase
*/

CREATE OR REPLACE PROCEDURE P_UPDATE_EMP (P_INCREASE NUMBER) AS
    CURSOR EMP_CURR IS
        SELECT ENAME, SAL
        FROM EMP
        FOR UPDATE OF SAL; -- LOCK THE SALARY TO AVOID UPDATES WHILE I DO THE CALCULATIONS
    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;
    V_NEW_SAL EMP.SAL%TYPE;
BEGIN
    OPEN EMP_CURR;
    FETCH EMP_CURR INTO V_ENAME, V_SAL;
    WHILE EMP_CURR%FOUND LOOP
        V_NEW_SAL := V_SAL + V_SAL*P_INCREASE / 100;
        UPDATE EMP 
        SET SAL = V_NEW_SAL
        WHERE CURRENT OF EMP_CURR;
        DBMS_OUTPUT.PUT_LINE('Employee ' || v_ename || ', with %' || 
        p_increase || ' increase in salary, will bring home $' || 
        v_new_sal || ' instead of $' || v_sal || '.');
        FETCH EMP_CURR INTO V_ENAME, V_SAL;
    end loop;
    CLOSE EMP_CURR;
commit;
END;
/

exec P_UPDATE_EMP(10)
