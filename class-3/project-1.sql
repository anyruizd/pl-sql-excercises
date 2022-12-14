SPOOL './project-1.txt'
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
-- Q1. Create a procedure that accept a number to display the triple of its 
-- value to the screen as follow: The triple of ... is ...

CREATE OR REPLACE PROCEDURE question_1(p_num_in IN NUMBER) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('The triple of ' || p_num_in || ' is ' || p_num_in*3 );
END;
/

Exec question_1 (2)
Exec question_1 (3)

-- Q2. Create a procedure that accepts a number which represent the temperature
-- in Celsius. The procedure will convert the temperature into Fahrenheit using
-- the following formula: Tf = (9/5) * Tc + 32
-- Then display the following: ... degree in C is equivalent to ... in F

CREATE OR REPLACE PROCEDURE question_2(p_num_in IN NUMBER) AS
    v_result NUMBER;
BEGIN
    v_result := (9/5)*p_num_in + 32;
    DBMS_OUTPUT.PUT_LINE(p_num_in || ' degrees in C is equivalent to ' || v_result || ' in F' );
END;
/

Exec question_2 (0)
Exec question_2 (25)
Exec question_2 (-15)

-- Q3. Create a procedure that accept a number which represent the temperature 
-- in Fahrenheit. The procedure will convert the temperature into Celsius using
-- the following formula: Tc = (5/9) * (Tf - 32) 
-- Then display the following: ... degree in F is equivalent to ... in C

CREATE OR REPLACE PROCEDURE question_3(p_num_in IN NUMBER) AS
    v_result NUMBER;
BEGIN
    v_result := (5/9)*(p_num_in - 32);
    DBMS_OUTPUT.PUT_LINE(p_num_in || ' degrees in F is equivalent to ' || v_result || ' in C' );
END;
/

Exec question_3 (32)
Exec question_3 (77)
Exec question_3 (5)

-- Q4. Create a procedure that accepts a number used to calculate the 5% GST, 
-- 9.98 % QST, the total of the 2 tax, the grand total, and to display 
-- EVERYTHING to the screen as follow: 
-- For the price of $...
-- You will have to pay $... GST 
-- $ ... QST for a total of $... 
-- The GRAND TOTAL is $ ...

CREATE OR REPLACE PROCEDURE question_4(price IN NUMBER) AS
    v_total NUMBER;
    v_gst NUMBER;
    v_qst NUMBER;
    v_subtotal NUMBER;
BEGIN
    v_gst := price*0.05;
    v_qst := price*0.0998;
    v_subtotal := v_gst + v_qst;
    v_total := price + v_subtotal;
    DBMS_OUTPUT.PUT_LINE('For the price of $' || price);
    DBMS_OUTPUT.PUT_LINE('You will have to pay $' || v_gst || ' GST');
    DBMS_OUTPUT.PUT_LINE('$' || v_qst || ' QST for a total of $' || v_subtotal );
    DBMS_OUTPUT.PUT_LINE('The GRAND TOTAL is $' || v_total );
END;
/

Exec question_4 (100)

-- Q5. Create a procedure that accepts 2 numbers represented the width and 
-- height of a rectangular shape. The procedure will calculate the area and 
-- the perimeter using the following formula:
-- Area = Width X Height
-- Perimeter = (Width + Height) X 2
-- display EVERYTHING to the screen as follow: 
-- The area of a ... by ... is .... It's parameter is ...

CREATE OR REPLACE PROCEDURE question_5(width IN NUMBER, height IN NUMBER) AS
    area NUMBER;
    perimeter NUMBER;
BEGIN
    area := width * height;
    perimeter := (width + height) * 2;
    DBMS_OUTPUT.PUT_LINE('The area of a ' || width || ' by ' || height || ' is ' || area || '. Its perimeter is ' || perimeter);
END;
/

Exec question_5 (2,3)

-- Q6. Use the formula of question 2, create a function that accepts the 
-- temperature in Celsius to convert it into temperature in Fahrenheit. 
-- Test your function at least 3 times with 3 different temperature.

CREATE OR REPLACE FUNCTION question_6(p_num_in IN NUMBER)
RETURN NUMBER AS
	v_result NUMBER;
BEGIN
	v_result := (9/5)*p_num_in + 32;
	RETURN v_result;
END;
/

SELECT question_6(0) AS result FROM DUAL;
SELECT question_6(25) AS result FROM DUAL;
SELECT question_6(-15) AS result FROM DUAL;

-- Q7. Use the formula of question 3, create a function that accepts the
-- temperature in Fahrenheit to convert it into temperature in Celsius.
-- Test your function at least 3 times with 3 different temperatures.

CREATE OR REPLACE FUNCTION question_7(p_num_in IN NUMBER)
RETURN NUMBER AS
	v_result NUMBER;
BEGIN
	v_result := (5/9)*(p_num_in - 32);
	RETURN v_result;
END;
/

SELECT question_7(32) AS result FROM DUAL;
SELECT question_7(77) AS result FROM DUAL;
SELECT question_7(5)  AS result FROM DUAL;

SPOOL OFF;