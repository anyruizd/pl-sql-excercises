  -- Menu du jour
  -- Create Function
  -- BREAK
  -- Project Part 1

  -- Syntax: CREATE OR REPLACE FUNCTION name_of_function
  --    [(name_of_parameter MODE datatype)] RETURN datatype AS
  --  BEGIN
  --    excecutable statement ;
  --    RETURN variable;
  --  END;
  --  /
  -- Ex1:  Create a function that accepts a number to return
  --     five time the input values.
connect scott/tiger;
  -- create spool file
SPOOL C:\BD2\s16_spool.txt
SELECT to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am' )
FROM dual;

CREATE OR REPLACE FUNCTION f_five_time(p_num_in IN NUMBER)
RETURN number AS
  v_num_in NUMBER;
  v_result NUMBER;
BEGIN
  v_num_in := p_num_in ;
  v_result := v_num_in * 5 ;
  RETURN   v_result ;
END;
/

-- A function must be used in a SELECT statement OR inside a
-- procedure
-- Syntax: SELECT name_of_function FROM dual;
SELECT f_five_time (5) FROM dual;
-- Example 2:  Using table emp of scott and the function
-- f_five_time, write a query to display the employee number,
-- name, job, salary, and five time his/her salary, name the
-- result as "Dream Salary"
SELECT empno, ename, job, sal, f_five_time(sal) "Dream Salary"
FROM  emp;

-- Bonus
--  Create a function named f_sum that accepts 2 numbers
-- to return the sum of the two numbers inserted.
-- test your function with 2 cases

CREATE OR REPLACE FUNCTION f_sum (p1 IN number, p2 IN number)
RETURN number AS
  v1 NUMBER ;
  v2 NUMBER ;
  v_result NUMBER;
BEGIN
  v1 := p1;
  v2 := p2;
  v_result := v1 + v2;
  RETURN v_result;
END;
/
 SELECT f_sum (2,3) FROM dual;
-- second way
CREATE OR REPLACE FUNCTION f_sumB (p1 IN number, p2 IN number)
RETURN number AS
  v1 NUMBER := p1;
  v2 NUMBER := p2;
  v_result NUMBER;
BEGIN
  v_result := v1 + v2;
  RETURN v_result;
END;
/
 SELECT f_sumB (2,3) FROM dual;

-- third way
CREATE OR REPLACE FUNCTION f_sumC (p1 IN number, p2 IN number)
RETURN number AS
  v_result NUMBER;
BEGIN
  v_result := p1 + p2;
  RETURN v_result;
END;
/
 SELECT f_sumC (2,3) FROM dual;
-- the 4 th way
CREATE OR REPLACE FUNCTION f_sumD (p1 IN number, p2 IN number)
RETURN number AS
BEGIN
  RETURN p1 + p2;
END;
/
 SELECT f_sumD (2,3) FROM dual;


SPOOL OFF;
