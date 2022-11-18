SPOOL './midterm.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;

-- Question 1 scott
-- A
CREATE OR REPLACE FUNCTION any_ruiz_f1 (p_date DATE)
RETURN NUMBER AS
BEGIN
    RETURN FLOOR((sysdate - p_date) / 365);
END;
/

-- B 
SELECT any_ruiz_f1('5 Jan 2017') as result from DUAL;

-- C 
CREATE OR REPLACE FUNCTION any_ruiz_f2 (p1 NUMBER, p2 NUMBER)
RETURN NUMBER AS
BEGIN
    RETURN p1 + p2;
END;
/
-- D
SELECT any_ruiz_f2(3,5) as result from DUAL;

-- E
CREATE OR REPLACE PROCEDURE any_p1 (P_EMPNO NUMBER, P_INCREASE NUMBER) AS
    CURSOR EMP_CURR IS
        SELECT empno, ename, sal, hiredate 
        FROM EMP
        WHERE empno = p_empno
        FOR UPDATE OF sal;
    v_emp_row emp_curr%rowtype;
    V_NEW_SAL EMP.SAL%TYPE;
    v_yexp number;
BEGIN
    OPEN EMP_CURR;
    FETCH EMP_CURR INTO v_emp_row;
    IF emp_curr%notfound THEN
        DBMS_OUTPUT.PUT_LINE('Eemployee number: ' || p_empno || ' not found!');
    else 
        v_yexp := any_ruiz_f1(v_emp_row.hiredate);
        DBMS_OUTPUT.PUT_LINE('Employee number'|| p_empno || '. Name: ' ||
            v_emp_row.ename || '. Salary: ' || v_emp_row.sal || '. Hire date: ' ||
            v_emp_row.hiredate || '. Has ' || v_yexp || ' years of experience.');
        if p_increase > 0 and p_increase <= 100 then
            V_NEW_SAL := any_ruiz_f2(v_emp_row.sal, v_emp_row.sal*P_INCREASE/100);
            UPDATE EMP 
            SET SAL = V_NEW_SAL
            WHERE CURRENT OF emp_curr;
            DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ', with ' || 
            p_increase || '% increase in salary, will bring home $' || 
            v_new_sal || ' instead of $' || v_emp_row.sal || '.');
        else 
            DBMS_OUTPUT.PUT_LINE('Percentage increase is invalid');
        end if;
    end if;
    CLOSE EMP_CURR;
commit;
END;
/

-- F 
exec any_p1(7839, 20);

-- G
exec any_p1(7369, 100);

-- Question 2 des02

CREATE OR REPLACE PROCEDURE any_p2 (P_INCR IN NUMBER) AS
    CURSOR INCR_CUR IS
        SELECT INV_ID, INV_PRICE,COLOR, INV_QOH
        FROM INVENTORY;
    V_INCR_ROW INCR_CUR%rowtype;

    V_NEW_PRICE NUMBER;
    V_VALUE NUMBER;
    V_NEW_VALUE NUMBER;
    v_case varchar(20);
BEGIN
    OPEN INCR_CUR;
    FETCH INCR_CUR INTO V_INCR_ROW;
    WHILE INCR_CUR%FOUND LOOP
        V_VALUE := V_INCR_ROW.INV_PRICE*V_INCR_ROW.INV_QOH;
        V_NEW_PRICE := V_INCR_ROW.INV_PRICE*(1 + P_INCR/100);
        V_NEW_VALUE := V_NEW_PRICE*V_INCR_ROW.INV_QOH;
        IF P_INCR > 0 THEN
            v_case := 'increase';
        ELSE
            v_case := 'decrease';
        END IF;
        DBMS_OUTPUT.PUT_LINE('For inv ID: ' || V_INCR_ROW.INV_ID || '. Price: ' || V_INCR_ROW.INV_PRICE ||
        '. Color: ' || V_INCR_ROW.COLOR || '. QUANTITY ' || V_INCR_ROW.INV_QOH ||
        '. Value ' || V_VALUE || '. For a ' || v_case || ' of ' || P_INCR || 
        '%. New price is: ' || V_NEW_PRICE || '. New value: ' || V_NEW_VALUE);

        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        FETCH INCR_CUR INTO V_INCR_ROW;
    END LOOP;
    CLOSE INCR_CUR;
END;
/

exec any_p2(20);
exec any_p2(-20);

-- Question 3
CREATE OR REPLACE PROCEDURE any_p3 (P_INCR IN NUMBER) AS
    CURSOR INCR_CUR IS
        SELECT INV_ID, INV_PRICE,COLOR, INV_QOH
        FROM INVENTORY
        FOR UPDATE OF INV_PRICE;
    V_INCR_ROW INCR_CUR%rowtype;

    V_NEW_PRICE NUMBER;
    V_VALUE NUMBER;
    V_NEW_VALUE NUMBER;
    v_case varchar(20);
BEGIN
    OPEN INCR_CUR;
    FETCH INCR_CUR INTO V_INCR_ROW;
    WHILE INCR_CUR%FOUND LOOP
        V_VALUE := V_INCR_ROW.INV_PRICE*V_INCR_ROW.INV_QOH;
        V_NEW_PRICE := V_INCR_ROW.INV_PRICE*(1 + P_INCR/100);
        V_NEW_VALUE := V_NEW_PRICE*V_INCR_ROW.INV_QOH;
        IF P_INCR > 0 THEN
            v_case := 'increase';
        ELSE
            v_case := 'decrease';
        END IF;
        UPDATE INVENTORY 
        SET INV_PRICE = V_NEW_PRICE
        WHERE CURRENT OF INCR_CUR;
        DBMS_OUTPUT.PUT_LINE('For inv ID: ' || V_INCR_ROW.INV_ID || '. Price: ' || V_INCR_ROW.INV_PRICE ||
        '. Color: ' || V_INCR_ROW.COLOR || '. QUANTITY ' || V_INCR_ROW.INV_QOH ||
        '. Value ' || V_VALUE || '. For a ' || v_case || ' of ' || P_INCR || 
        '%. New price is: ' || V_NEW_PRICE || '. New value: ' || V_NEW_VALUE);

        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        FETCH INCR_CUR INTO V_INCR_ROW;
    END LOOP;
    CLOSE INCR_CUR;
commit;
END;
/

exec any_p3(20);
exec any_p3(-20);
spool off;