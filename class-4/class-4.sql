-- Example 1. Using the function f_sum from last class, create a procedure
-- that accepts two numbers and displays their sum as follow:
-- Number X plus number Y is Z !
-- Where X,Y are the two numbers inserted and Z is their sum.

-- run script scott_emp_dept

CREATE OR REPLACE PROCEDURE p_s21_ex1(P1 number, p2 number) AS
    v_result NUMBER;
    BEGIN
        v_result := f_sum(p1,p2);
        DBMS_OUTPUT.PUT_LINE(p1 || ' plus ' || p2 || ' is ' || v_result || ' !');
    END;
/

exec p_s21_ex1(1,2)

-- The if STATEMENT
-- Syntax: 
-- IF condition1 THEN
--      statement1
-- ELSIF condition2
--      statement2
-- ELSE 
--      statement3
-- END IF;

-- Example 2: 

-- Create a procedure named p_mark_convert that accepts a numerical mark
-- to convert the mark inserted into letter grade according to the scale below:

-- >= 90 A
-- 80 - 90 B
-- 70 - 79 C 
-- 60 - 69 D
--    < 60 See you again my friend!

CREATE OR REPLACE PROCEDURE p_mark_convert(p_mark_in number) AS
    v_grade VARCHAR(40);
    BEGIN
    IF p_mark_in < 0 OR p_mark_in > 100 THEN
        DBMS_OUTPUT.PUT_LINE('Please insert a number between 0-100');
    ELSE
        IF p_mark_in >= 90 THEN
            v_grade := 'an A.';
        ELSIF p_mark_in >= 80 THEN
            v_grade := 'a B.';
        ELSIF p_mark_in >= 70 THEN
            v_grade := 'a C.';
        ELSIF p_mark_in >= 60 THEN
            v_grade := 'a D.';
        ELSIF p_mark_in > 0 THEN
            v_grade := 'to repeat the course my friend!';
        END IF;
        DBMS_OUTPUT.PUT_LINE('For a mark of ' || p_mark_in || ' you have ' || v_grade);
    END IF;
    END;
/

exec p_mark_convert(155)
exec p_mark_convert(-155)
exec p_mark_convert(78)
exec p_mark_convert(58)

-- Function with return boolean
-- Ex 3: Create a function that accepts 2 numbers to return TRUE if they are equal
-- otherwise return false
-- Boolean is not SQL datatype is PL/SQL datatype you cannot put boolean in a table
CREATE OR REPLACE FUNCTION f_is_equal (p1 IN NUMBER, p2 IN NUMBER)
RETURN BOOLEAN AS
	v_result BOOLEAN := FALSE;
BEGIN
	IF p1 = p2 THEN
        v_result := TRUE;
    END IF;
	RETURN v_result;
END;
/

-- SELECT f_is_equal(1, 1) AS result FROM DUAL;

-- Ex 4. Create a procedure named p_s21_ex4 that accepts two numbers and use
-- the function f_is_equal to display either:
-- Number X and Y are EQUAL !
-- or Number X and number Y are NOT EQUAL !

CREATE OR REPLACE PROCEDURE p_s21_ex4(P1 number, p2 number) AS
    v_result VARCHAR(25) := 'NOT EQUAL !';
    BEGIN
        IF f_is_equal(P1, P2) THEN
            v_result := 'EQUAL !';
        END IF;
        DBMS_OUTPUT.PUT_LINE('Number ' || p1 || ' and number ' || p2 || ' are ' || v_result);
    END;
/

exec p_s21_ex4(1,2)
exec p_s21_ex4(2,2)
exec p_s21_ex4(2,-2)