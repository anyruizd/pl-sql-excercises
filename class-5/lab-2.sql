SPOOL './lab-2.txt'
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;

-- Q1. Create a function that accepts 2 numbers to calculate the product of 
-- them. Test your function in SQL*Plus

CREATE OR REPLACE FUNCTION l2_q1 (p1 IN NUMBER, p2 IN NUMBER)
RETURN NUMBER AS
BEGIN
	RETURN p1*p2;
END;
/

SELECT l2_q1(3, 1) AS result FROM DUAL;


-- Q2. Create a procedure that accepts 2 numbers and use the function created
-- in question 1 to display the following: 
-- For a rectangle of size .x. by .y. the area is .z.

CREATE OR REPLACE PROCEDURE l2_q2(P1 NUMBER, P2 NUMBER) AS
    v_result NUMBER;
    BEGIN
        v_result := l2_q1(p1,p2);
        DBMS_OUTPUT.PUT_LINE('For a rectangle of size .' || P1 || '. by .' || P2 || '. the area is .' || v_result || '.');
    END;
/

exec l2_q2(1,2)

-- Q3. Modify procedure of question 1 to display “square” when x and y are 
-- equal in length.

CREATE OR REPLACE PROCEDURE l2_q3(P1 NUMBER, P2 NUMBER) AS
    v_result NUMBER;
    shape VARCHAR(10);
    BEGIN
        v_result := l2_q1(p1,p2);
        IF P1 = P2 THEN
            shape := 'square';
        ELSE
            shape := 'rectangle';
        END IF;
        DBMS_OUTPUT.PUT_LINE('For a ' || shape || ' of size .' || P1 || '. by .' || P2 || '. the area is .' || v_result || '.');
    END;
/

exec l2_q3(4,2)
exec l2_q3(2,2)

-- Q4. Create a procedure that accepts a number represent Canadian dollar and a
-- letter represent the new currency. The procedure will convert the Canadian 
-- dollar to the new currency using the following exchange rate:
-- E EURO           1.50
-- Y YEN            100
-- V Viet Nam DONG  10 000
-- Z Endora ZIP     1 000 000
-- Display Canadian money and new currency in a sentence as the following:
-- For``x``dollarsCanadian, youwillhave``y`` ZZZ


CREATE OR REPLACE PROCEDURE l2_q4(P1 NUMBER, P2 CHAR) AS
    V_RESULT NUMBER;
    V_CURRENCY VARCHAR(20);
    BEGIN
        IF P2 = 'E' THEN
            V_RESULT := P1*1.50;
            V_CURRENCY := 'EUROS';
        ELSIF P2 = 'Y' THEN
            V_RESULT := P1*100;
            V_CURRENCY := 'YEN';
        ELSIF P2 = 'V' THEN
            V_RESULT := P1*10000;
            V_CURRENCY := 'Viet Nam DONG';
        ELSIF P2 = 'Z' THEN
            V_RESULT := P1*1000000;
            V_CURRENCY := 'Endora ZIP';
        END IF;
        DBMS_OUTPUT.PUT_LINE('For ' || P1 || ' dollars Canadian, you will have ' || V_RESULT || ' ' || V_CURRENCY);
    END;
/

exec l2_q4(4,'E')
exec l2_q4(4,'Y')
exec l2_q4(4,'V')
exec l2_q4(4,'Z')

-- Q5. Create a function called YES_EVEN that accepts a number to determine if
-- the number is EVEN or not. The function will return TRUE if the number 
-- inserted is EVEN otherwise the function will return FALSE

CREATE OR REPLACE FUNCTION YES_EVEN (p1 IN NUMBER)
RETURN BOOLEAN AS
v_result BOOLEAN := false;
BEGIN
	IF MOD(p1, 2) = 0 THEN
        v_result := true;
    END IF;

    RETURN v_result;
END;
/

-- Q6. Create a procedure that accepts a numbers and uses the function of 
-- question 5 to print out EXACTLY the following:
-- Number ... is EVEN OR Number ... is ODD

CREATE OR REPLACE PROCEDURE l2_q6(P1 NUMBER) AS
    V_RESULT VARCHAR(10);
    BEGIN
        IF YES_EVEN(P1) THEN
            v_result := 'EVEN';
        ELSE
            v_result := 'ODD';
        END IF;
        DBMS_OUTPUT.PUT_LINE('Number ' ||P1 || ' is ' || v_result);
    END;
/

exec l2_q6(4)
exec l2_q6(3)

-- Bonus question: Modify question 4 to convert the money in any direction.

CREATE OR REPLACE FUNCTION CONVERT_TO_CAD(P1 NUMBER, P2 CHAR)
RETURN NUMBER AS
    V_RESULT NUMBER;
    BEGIN
        IF P2 = 'E' THEN
            V_RESULT := P1/1.50;
        ELSIF P2 = 'Y' THEN
            V_RESULT := P1/100;
        ELSIF P2 = 'V' THEN
            V_RESULT := P1/10000;
        ELSIF P2 = 'Z' THEN
            V_RESULT := P1/1000000;
        END IF;
        RETURN V_RESULT;
    END;
/

SELECT CONVERT_TO_CAD(4,'E') AS result FROM DUAL;
SELECT CONVERT_TO_CAD(4,'Y') AS result FROM DUAL;
SELECT CONVERT_TO_CAD(4,'V') AS result FROM DUAL;
SELECT CONVERT_TO_CAD(4,'Z') AS result FROM DUAL;


CREATE OR REPLACE FUNCTION CONVERT_FROM_CAD(P1 NUMBER, P2 CHAR)
RETURN NUMBER AS
    V_RESULT NUMBER;
    BEGIN
        IF P2 = 'E' THEN
            V_RESULT := P1*1.50;
        ELSIF P2 = 'Y' THEN
            V_RESULT := P1*100;
        ELSIF P2 = 'V' THEN
            V_RESULT := P1*10000;
        ELSIF P2 = 'Z' THEN
            V_RESULT := P1*1000000;
        END IF;
        RETURN V_RESULT;
    END;
/

SELECT CONVERT_FROM_CAD(1,'E') AS result FROM DUAL;
SELECT CONVERT_FROM_CAD(400,'Y') AS result FROM DUAL;
SELECT CONVERT_FROM_CAD(40000,'V') AS result FROM DUAL;
SELECT CONVERT_FROM_CAD(4000000,'Z') AS result FROM DUAL;

CREATE OR REPLACE FUNCTION l2_q1 (p1 IN NUMBER, p2 IN NUMBER)
RETURN NUMBER AS
BEGIN
	RETURN p1*p2;
END;
/


CREATE OR REPLACE FUNCTION GET_CURRENCY(P2 CHAR) RETURN VARCHAR2 AS
    V_CURRENCY VARCHAR(20);
BEGIN
    IF P2 = 'E' THEN
        V_CURRENCY := 'EUROS';
    ELSIF P2 = 'Y' THEN
        V_CURRENCY := 'YEN';
    ELSIF P2 = 'C' THEN
        V_CURRENCY := 'Canadian dollar';
    ELSIF P2 = 'V' THEN
        V_CURRENCY := 'Viet Nam DONG';
    ELSIF P2 = 'Z' THEN
        V_CURRENCY := 'Endora ZIP';
    END IF;
    RETURN V_CURRENCY;
END;
/

SELECT GET_CURRENCY('E') AS result FROM DUAL;
SELECT GET_CURRENCY('Y') AS result FROM DUAL;
SELECT GET_CURRENCY('V') AS result FROM DUAL;
SELECT GET_CURRENCY('Z') AS result FROM DUAL;
SELECT GET_CURRENCY('C') AS result FROM DUAL;

CREATE OR REPLACE PROCEDURE l2_bonus(P1 NUMBER, V_FROM CHAR, V_TO CHAR) AS
    V_TEMP_RES NUMBER;
    V_RESULT NUMBER;
    BEGIN
        IF V_FROM = 'C' THEN -- CONVERT FROM CANADIAN
           V_RESULT := CONVERT_FROM_CAD(P1, V_TO);
        ELSIF V_TO = 'C' THEN -- CONVERT TO CANADIAN
            V_RESULT := CONVERT_TO_CAD(P1, V_FROM);
        ELSE
            V_TEMP_RES := CONVERT_TO_CAD(P1, V_FROM);
            V_RESULT := CONVERT_FROM_CAD(V_TEMP_RES, V_TO);
        END IF;
        DBMS_OUTPUT.PUT_LINE('For ' || P1 || ' ' || GET_CURRENCY(V_FROM) || ', you will have ' || V_RESULT || ' ' || GET_CURRENCY(V_TO));
    END;
/

exec l2_bonus(2,'Y','V')
-- For 2 YEN, you will have 200 Viet Nam DONG
exec l2_bonus(20000,'V','C')
-- For 20000 Viet Nam DONG, you will have 2 dollars Canadian
exec l2_bonus(20000,'C','E')
exec l2_bonus(30,'Y','Z')
exec l2_bonus(30,'Z','E')

SPOOL OFF;