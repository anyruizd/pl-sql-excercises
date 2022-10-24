-- Question 1 :
-- Run script 7northwoods. DES03
-- Using cursor to display many rows of data, create a procedure to display
-- all the rows of table term.

CREATE OR REPLACE PROCEDURE L4Q1 AS
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

EXEC L4Q1

-- Question 2 :
-- Run script 7clearwater.
-- Using cursor to display many rows of data, create a procedure to display 
-- the following data from the database: Item description, price, color,
-- and quantity on hand.
select ITEM_DESC, INV_PRICE, COLOR, INV_QOH from ITEM IT
join INVENTORY INV on IT.ITEM_ID = INV.ITEM_ID

select * from INVENTORY
CREATE OR REPLACE PROCEDURE L4Q2 AS
-- STEP 1
    CURSOR INV_CUR IS
        select ITEM_DESC, INV_PRICE, COLOR, INV_QOH 
        FROM ITEM IT
        JOIN INVENTORY INV ON IT.ITEM_ID = INV.ITEM_ID
    V_ITEM_DESC ITEM.ITEM_DESC%TYPE;
    V_INV_PRICE INVENTORY.INV_PRICE%TYPE;
    V_COLOR INVENTORY.COLOR%TYPE;
    V_INV_QOH INVENTORY.INV_QOH%TYPE;
BEGIN
    -- STEP 2
    OPEN INV_CUR;

    -- STEP 3
    FETCH INV_CUR INTO V_ITEM_DESC, V_INV_PRICE, V_COLOR, V_INV_QOH;
        WHILE TERM_CUR%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('TERM ID ' || V_TERMID || ' TERM_DESC ' || V_TERMDESC || ' STATUS ' || V_STATUS || '.');
            
        FETCH TERM_CUR INTO V_TERMID, V_TERMDESC, V_STATUS;
    END LOOP;

    -- STEP 4
    CLOSE TERM_CUR;
    -- COMMIT; 
END; 
/



-- Question 3 :
-- Run script 7clearwater.
-- Using cursor to update many rows of data, create a procedure that accepts a 
-- number represent the percentage increase in price. The procedure will 
-- display the old price, new price and update the database with the new price.



-- Question 4 :
-- Run script scott_emp_dept.
-- Create a procedure that accepts a number represent the number of employees 
-- who earns the highest salary. Display employee name and his/her salary
-- Ex: SQL> exec L5Q4(2)
-- SQL> top 2 employees are
-- KING 5000 FORD 3000

-- Question 5:
-- Modify question 4 to display ALL employees who make the top salary entered 
-- Ex: SQL> exec L5Q5(2)
-- SQL> Employee who make the top 2 salary are
-- KING 5000
-- FORD 3000 SCOTT 3000

-- 4 and 5
-- 4: connect to user scott and select ename, sal, from table emp, 
-- you will have the results king 5000 scott 300,
-- i will need a procedure that receives a number which is the number of employees i want to SHOW
-- which will be the n top ✨employees✨ who earns the highest salary (only employees)

-- question 5 is return all the employees that earn the n top salary



