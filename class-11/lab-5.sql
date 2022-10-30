SPOOL './lab-5.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
-- Question 1 :
-- Run script 7northwoods. DES03
-- Using cursor to display many rows of data, create a procedure to display
-- all the rows of table term.

CREATE OR REPLACE PROCEDURE L5Q1 AS
-- STEP 1
    CURSOR TERM_CUR IS
        SELECT TERM_ID, TERM_DESC, STATUS
        FROM  TERM;
    V_TERMID TERM.TERM_ID%TYPE;
    V_TERMDESC TERM.TERM_DESC%TYPE;
    V_STATUS TERM.STATUS%TYPE;
BEGIN
    -- STEP 2
    OPEN TERM_CUR;

    -- STEP 3
    FETCH TERM_CUR INTO V_TERMID, V_TERMDESC, V_STATUS;
        WHILE TERM_CUR%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('TERM ID ' || V_TERMID || ' TERM_DESC ' || V_TERMDESC || ' STATUS ' || V_STATUS || '.');
            
        FETCH TERM_CUR INTO V_TERMID, V_TERMDESC, V_STATUS;
    END LOOP;

    -- STEP 4
    CLOSE TERM_CUR;
    -- COMMIT; 
END; 
/

EXEC L5Q1

-- Question 2 :
-- Run script 7clearwater. - DES02
-- Using cursor to display many rows of data, create a procedure to display 
-- the following data from the database: Item description, price, color,
-- and quantity on hand. 
CREATE OR REPLACE PROCEDURE L5Q2 AS
-- STEP 1
    CURSOR INV_CUR IS
        select ITEM_DESC, INV_PRICE, COLOR, INV_QOH 
        FROM ITEM IT
        JOIN INVENTORY INV ON IT.ITEM_ID = INV.ITEM_ID;
    V_ITEM_DESC ITEM.ITEM_DESC%TYPE;
    V_INV_PRICE INVENTORY.INV_PRICE%TYPE;
    V_COLOR INVENTORY.COLOR%TYPE;
    V_INV_QOH INVENTORY.INV_QOH%TYPE;
BEGIN
    -- STEP 2
    OPEN INV_CUR;
    -- STEP 3
    FETCH INV_CUR INTO V_ITEM_DESC, V_INV_PRICE, V_COLOR, V_INV_QOH;
        WHILE INV_CUR%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Item: ' || V_ITEM_DESC || '. Price: ' || V_INV_PRICE || '. Color: ' || V_COLOR || '. Quantity: ' || V_INV_QOH || '.');
        FETCH INV_CUR INTO V_ITEM_DESC, V_INV_PRICE, V_COLOR, V_INV_QOH;
    END LOOP;
    -- STEP 4
    CLOSE INV_CUR; 
END; 
/
EXEC L5Q2


-- Question 3 :
-- Run script 7clearwater. - DES02
-- Using cursor to update many rows of data, create a procedure that accepts a 
-- number represent the percentage increase in price. The procedure will 
-- display the old price, new price and update the database with the new price.

CREATE OR REPLACE PROCEDURE L5Q3 (P_INCR IN NUMBER) AS
-- STEP 1
CURSOR INCR_CUR IS
    SELECT INV_ID, INV_PRICE 
    FROM INVENTORY;
V_INVID INVENTORY.INV_ID%TYPE;
V_INVPRICE INVENTORY.INV_PRICE%TYPE;
V_NEW_PRICE INVENTORY.INV_PRICE%TYPE;

BEGIN
    -- STEP 2
    OPEN INCR_CUR;

    -- STEP 3
    FETCH INCR_CUR INTO V_INVID, V_INVPRICE;
    WHILE INCR_CUR%FOUND LOOP
        V_NEW_PRICE := V_INVPRICE*(1 + P_INCR/100);
        UPDATE INVENTORY SET INV_PRICE = V_NEW_PRICE;
        DBMS_OUTPUT.PUT_LINE('For inv ID: ' || V_INVID || ' old price is: $' || V_INVPRICE || 
         '. With an increase of ' || P_INCR || '% '
         || ', the new price is: $' || V_NEW_PRICE || '. ');

        FETCH INCR_CUR INTO V_INVID, V_INVPRICE;
    END LOOP;

    -- STEP 4
    CLOSE INCR_CUR;
    COMMIT;
END;
/
EXEC L5Q3(20)

-- Question 4 :
-- Run script scott_emp_dept.
-- Create a procedure that accepts a number represent the number of employees 
-- who earns the highest salary. Display employee name and his/her salary
-- Ex: SQL> exec L5Q4(2)
-- SQL> top 2 employees are
-- KING 5000 FORD 3000

CREATE OR REPLACE PROCEDURE L5Q4 (NEMP IN NUMBER) AS
    -- STEP 1 DEFINE CURSOR
    CURSOR HSAL_CUR IS
        SELECT ENAME, SAL
        FROM EMP
        ORDER BY SAL DESC;
    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;
    V_COUNT NUMBER(2) := 0;
BEGIN
    -- STEP 2: OPEN CURSOR
    OPEN HSAL_CUR;

    -- STEP 3: FETCH
    FETCH HSAL_CUR INTO V_ENAME, V_SAL;
    IF HSAL_CUR%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The top ' || nemp || ' employees are: ');
    END IF;
    WHILE HSAL_CUR%FOUND AND V_COUNT < NEMP LOOP
        DBMS_OUTPUT.PUT_LINE('Employee: ' || V_ENAME || ' Salary: ' || V_SAL || '.');
        V_COUNT := V_COUNT + 1;
        -- STEP 3: FETCH
        FETCH HSAL_CUR INTO V_ENAME, V_SAL;
    END LOOP;

    -- STEP 4: CLOSE CURSOR
    CLOSE HSAL_CUR;
END;
/

EXEC L5Q4(2)
EXEC L5Q4(5)

-- Question 5:
-- Modify question 4 to display ALL employees who make the top salary entered 
-- Ex: SQL> exec L5Q5(2)
-- SQL> Employee who make the top 2 salary are
-- KING 5000
-- FORD 3000 SCOTT 3000

CREATE OR REPLACE PROCEDURE L5Q5(NHSAL IN NUMBER) AS
    -- STEP 1 DEFINE CURSOR
    CURSOR HSAL_CUR IS
        SELECT ENAME, SAL
        FROM EMP
        WHERE SAL IN (
            SELECT SAL FROM 
                (SELECT DISTINCT SAL from EMP
                    ORDER BY SAL DESC)
            WHERE rownum <= NHSAL);
    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;

BEGIN

    -- STEP 2: OPEN CURSOR
    OPEN HSAL_CUR;

    -- STEP 3: FETCH
    FETCH HSAL_CUR INTO V_ENAME, V_SAL;
    IF HSAL_CUR%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee who make the top ' || NHSAL || ' salary are: ');
    END IF;
    WHILE HSAL_CUR%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Employee: ' || V_ENAME || ' Salary: ' || V_SAL || '.');
        -- STEP 3: FETCH
        FETCH HSAL_CUR INTO V_ENAME, V_SAL;
    END LOOP;

    -- STEP 4: CLOSE CURSOR
    CLOSE HSAL_CUR;
END;
/

EXEC L5Q5(2)
EXEC L5Q5(3)

SPOOL OFF;