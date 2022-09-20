-- Example 1
CREATE OR REPLACE FUNCTION f_five_time (p_num_in IN NUMBER)
RETURN NUMBER AS
	v_num_in NUMBER;
	v_result NUMBER;
BEGIN
	v_num_in :=  p_num_in;
	v_result := (v_num_in * 5);	
	
	RETURN v_result;
END;
/

SELECT f_five_time(5) AS result FROM DUAL;
-- Example 2
-- Use table emp of scott and the function f_five_time
SELECT empno, ename, job, sal, f_five_time(sal) "Dream Salary"
FROM emp;

-- Bonus question:
-- Create a function named f_sum that accepts 2 numbers to return the sum of the two numbers inserted
SPOOL './s16.txt'
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
CREATE OR REPLACE FUNCTION f_sum (p_num1_in IN NUMBER, p_num2_in IN NUMBER)
RETURN NUMBER AS
	v_num1_in NUMBER;
	v_num2_in NUMBER;
	v_result NUMBER;
BEGIN
	v_num1_in :=  p_num1_in;
	v_num2_in :=  p_num2_in;
	v_result := v_num1_in + v_num2_in;	
	
	RETURN v_result;
END;
/

SELECT f_sum(1, 1) AS result FROM DUAL;
SELECT f_sum(1, 56) AS result FROM DUAL;

-- second way
CREATE OR REPLACE FUNCTION f_sum (p_num1_in IN NUMBER, p_num2_in IN NUMBER)
RETURN NUMBER AS
	v_num1_in NUMBER := p_num1_in;
	v_num2_in NUMBER := p_num2_in;
	v_result NUMBER;
BEGIN
	v_result := v_num1_in + v_num2_in;
	RETURN v_result;
END;
/

SELECT f_sum(1, 1) AS result FROM DUAL;

-- third way
CREATE OR REPLACE FUNCTION f_sum (p_num1_in IN NUMBER, p_num2_in IN NUMBER)
RETURN NUMBER AS
	v_result NUMBER;
BEGIN
	v_result := p_num1_in + p_num2_in;
	RETURN v_result;
END;
/

SELECT f_sum(1, 1) AS result FROM DUAL;

-- fourth way
CREATE OR REPLACE FUNCTION f_sum (p_num1_in IN NUMBER, p_num2_in IN NUMBER)
RETURN NUMBER AS

BEGIN
	RETURN p_num1_in + p_num2_in;
END;
/

SELECT f_sum(1, 3) AS result FROM DUAL;