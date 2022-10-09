SPOOL './lab-3.txt'
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;

-- Question 1: (user scott)
-- Create a procedure that accepts an employee number to display the name of 
-- the department where he works, his name, his annual salary (do not forget 
-- his one time commission)
-- Note that the salary in table employee is monthly salary. 
-- Handle the error (use EXCEPTION)
-- hint: the name of the department can be found from table dept.

CREATE OR REPLACE PROCEDURE l3_q1(p_empno IN NUMBER) AS
    v_ename emp.ENAME%TYPE;
    v_msal emp.SAL%TYPE;
    v_asal emp.SAL%TYPE;
    v_com emp.COMM%TYPE;
    v_dname dept.DNAME%TYPE;
BEGIN
    SELECT ENAME, SAL, COMM, D.DNAME 
    INTO v_ename, v_msal, v_com, v_dname
    from EMP E
    JOIN DEPT D ON E.DEPTNO = D.DEPTNO
    WHERE empno = p_empno;

    v_asal := v_msal * 12;
    IF v_com > 0 THEN
        v_asal := v_asal + v_com;
    ELSE
        v_com := 0;
    END IF;

    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NUMBER ' || P_EMPNO || ' IS '
        || V_ENAME || '. THEIR DEPARTMENT IS ' || V_DNAME 
        || '. HIS MONTHLY SALARY IS $' || V_MSAL 
        || '. HIS COMMISION IS $' || V_COM
        || '. ANNUAL SALARY IS $' || V_ASAL || '. ');
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE NUMBER ' || P_EMPNO || ' DOES NOT EXIST! ');
END;
/

EXEC l3_q1(7369)
EXEC l3_q1(1234)


-- Question 2: (use schemas des02, and script 7clearwater) Create a procedure 
-- that accepts an inv_id to display the item description, price, color, 
-- inv_qoh, and the value of that inventory. Handle the error ( use EXCEPTION)
-- Hint: value is the product of price and quantity on hand.

CREATE OR REPLACE PROCEDURE l3_q2(p_inv_id IN INVENTORY.INV_ID%TYPE) AS
    v_idesc ITEM.ITEM_DESC%TYPE;
    v_color INVENTORY.COLOR%TYPE;
    v_qty INVENTORY.INV_QOH%TYPE;
    v_price INVENTORY.INV_PRICE%TYPE;
    v_value NUMBER;
BEGIN
    SELECT ITEM_DESC, COLOR, INV_QOH, INV_PRICE 
    INTO v_idesc, v_color, v_qty, v_price
    FROM INVENTORY
    JOIN ITEM ON ITEM.ITEM_ID = INVENTORY.ITEM_ID
    WHERE INV_ID = p_inv_id;

    v_value := v_price * v_qty;

    DBMS_OUTPUT.PUT_LINE('INV NUMBER ' || p_inv_id 
        || ' IS ' || v_idesc 
        || '. ITS COLOR $' || v_color 
        || '. ITS PRICE $' || v_price
        || '. FOR A TOTAL OF $' || v_value || '. ');
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('INVENTORY NUMBER ' || p_inv_id || ' DOES NOT EXIST! ');
END;
/

exec l3_q2(10)
exec l3_q2(12)
exec l3_q2(20)

-- Question 3: (use schemas des03, and script 7northwoods) 
-- Create a function called find_age that accepts a date and return a number.
-- The function will use the sysdate and the date inserted to calculate the age
--  of the person with the birthdate inserted.
-- Create a procedure that accepts a student number to display his name, 
-- his birthdate, and his age using the function find_age created above.
-- Handle the error ( use EXCEPTION)


CREATE OR REPLACE FUNCTION find_age (p_date IN DATE)
RETURN NUMBER AS
	v_sysdate DATE;
BEGIN
    SELECT SYSDATE INTO v_sysdate FROM DUAL;
    RETURN FLOOR((v_sysdate - p_date) / 365);
END;
/

CREATE OR REPLACE PROCEDURE l3_q3(p_sid NUMBER) AS
    v_sfname STUDENT.S_FIRST%TYPE;
    v_slname STUDENT.S_LAST%TYPE;
    v_sbirthdate STUDENT.S_DOB%TYPE;
    v_sage NUMBER;
BEGIN
    SELECT S_LAST, S_FIRST, S_DOB
    INTO v_sfname, v_slname, v_sbirthdate
    FROM STUDENT
    WHERE S_ID = p_sid;
    v_sage := find_age(v_sbirthdate);
    DBMS_OUTPUT.PUT_LINE('Student: ' || v_sfname || ' ' || v_slname
    || '. Birthdate: ' || v_sbirthdate
    || '. Age: ' || v_sage || ' years old.'
    );
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('STUDENT NUMBER ' || p_sid || ' DOES NOT EXIST! ');

END;
/

exec l3_q3(1)
exec l3_q3(10)


-- Question 4: (use schemas des04, and script 7software)
-- We need to INSERT or UPDATE data of table consultant_skill, create needed 
-- functions, procedures ... that accepts consultant id, skill id, and 
-- certification status for the task. The procedure should be user friendly 
-- enough to handle all possible errors such as consultant id, skill id do not 
-- exist OR certification status is different than ‘Y’, ‘N’. 
-- Make sure to display: Consultant last, first name, skill description and the
-- confirmation of the DML performed (hint: Do not forget to add COMMIT inside 
-- the procedure)

CREATE OR REPLACE PROCEDURE DISPLAY_DATA(P_CID NUMBER, P_SKID NUMBER, P_CERTST CHAR) AS
    V_LNAME CONSULTANT.C_LAST%TYPE;
    V_FNAME CONSULTANT.C_FIRST%TYPE;
    V_SKDESC SKILL.SKILL_DESCRIPTION%TYPE;
BEGIN
    SELECT C_FIRST, C_LAST, SKILL_DESCRIPTION
    INTO V_FNAME, V_LNAME, V_SKDESC
    FROM CONSULTANT C 
    JOIN CONSULTANT_SKILL C_SK ON C.C_ID = C_SK.C_ID
    JOIN SKILL SK ON SK.SKILL_ID = C_SK.SKILL_ID
    WHERE C.C_ID = P_CID
    AND C_SK.SKILL_ID = P_SKID;

    DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID 
        || ' is ' || V_FNAME || ' ' || V_LNAME
        || '. They work in ' || V_SKDESC || '. Certification status is: ' || P_CERTST || '!');
END;
/

CREATE OR REPLACE PROCEDURE l3_q4(P_CID NUMBER, P_SKID NUMBER, P_CERTST CHAR) AS
    V_EXC NUMBER;
    V_SKID NUMBER;
    V_CID NUMBER;
    V_CERTST CHAR;
BEGIN
    -- VERIFY C_ID EXISTS IN CONSULTANT 
    V_EXC := 1; 
    SELECT C_ID
    INTO V_CID
    FROM CONSULTANT
    WHERE C_ID = P_CID;

    -- VERIFY SK_ID EXISTS IN SKILL
    V_EXC := 2; 
    SELECT SKILL_ID
    INTO V_SKID
    FROM SKILL
    WHERE SKILL_ID = P_SKID;

    -- VERIFY COMBINATION EXISTS IN CONSULTANT_SKILL
    V_EXC := 3;
    SELECT C_ID, SKILL_ID, CERTIFICATION
    INTO V_CID, V_SKID, V_CERTST
    FROM CONSULTANT_SKILL
    WHERE SKILL_ID = P_SKID AND C_ID = P_CID;

    -- IF COMBINATION EXISTS, CHECK IF IT'S NECESSARY TO UPDATE  CERTIFICATION
    IF V_CERTST = P_CERTST THEN
        DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' found, no update needed!');
        DISPLAY_DATA(P_CID, P_SKID, P_CERTST);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' found, update needed!');
        IF P_CERTST <> 'Y' AND P_CERTST <> 'N' THEN
            DBMS_OUTPUT.PUT_LINE('Certification code ' || P_CERTST || ' is invalid!');
        ELSE 
            UPDATE CONSULTANT_SKILL SET CERTIFICATION = P_CERTST WHERE C_ID = P_CID;
            DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' updated!');
            DISPLAY_DATA(P_CID, P_SKID, P_CERTST);           
            COMMIT;
        END IF;
    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF V_EXC = 1 THEN -- C_ID DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' does not exist, please add it first!');
        ELSIF V_EXC = 2 THEN -- SKILL_ID DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Skill number ' || P_SKID || ' does not exist, please add it first!');
        ELSIF V_EXC = 3 THEN -- COMBINATION DOES NOT EXIST: INSERT IT
            DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' and skill number ' || P_SKID || ' need to be inserted!');
            IF P_CERTST <> 'Y' AND P_CERTST <> 'N' THEN
                DBMS_OUTPUT.PUT_LINE('Certification code ' || P_CERTST || ' is invalid!');
            ELSE
                INSERT INTO CONSULTANT_SKILL(C_ID, SKILL_ID, CERTIFICATION)
                VALUES(P_CID, P_SKID, P_CERTST);
                DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' and skill number ' || P_SKID || ' inserted!');
                DISPLAY_DATA(P_CID, P_SKID, P_CERTST);
                COMMIT;
            END IF;
        END IF;
END;
/
-- NO C_ID
EXEC l3_q4(120, 1, 'N') 
-- NO SK_ID
EXEC l3_q4(100, 10, 'N')
-- NO COMBINATION
EXEC l3_q4(100, 4, 'Y') 
-- INVALID CERTIFICATION
EXEC l3_q4(102, 7, 'S') 
-- UPDATE CERTIFICATION
EXEC l3_q4(103, 9, 'N') 

SPOOL OFF;