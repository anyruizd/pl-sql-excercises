SPOOL './midterm.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
-- Question 1
-- A
CREATE OR REPLACE FUNCTION any_ruiz_f1 (p_date IN DATE)
RETURN NUMBER AS
	v_sysdate DATE;
    v_age NUMBER;
BEGIN
    SELECT SYSDATE INTO v_sysdate FROM DUAL;
    v_age := FLOOR((v_sysdate - p_date) / 365);
    RETURN v_age;
END;
/
-- B
SELECT any_ruiz_f1(TO_DATE('5 Jan 2017')) as result from DUAL;

-- C

CREATE OR REPLACE PROCEDURE any_ruiz_p1(P_SID NUMBER, P_CSEC_ID NUMBER, P_GRADE CHAR) AS
    V_SID STUDENT.S_ID%TYPE;
    V_CSEC_ID COURSE_SECTION.C_SEC_ID%TYPE;
    V_GRADE ENROLLMENT.GRADE%TYPE;
    V_SFNAME STUDENT.S_FIRST%TYPE;
    V_SLNAME STUDENT.S_LAST%TYPE;
    V_DOB STUDENT.S_DOB%TYPE;
    V_AGE NUMBER;
    V_EXC NUMBER;
BEGIN
    -- VERIFY S_ID EXISTS IN STUDENT 
    V_EXC := 1; 
    SELECT S_ID, S_FIRST, S_LAST, S_DOB
    INTO V_SID, V_SFNAME, V_SLNAME, V_DOB
    FROM STUDENT
    WHERE S_ID = P_SID;

    -- VERIFY C_SEC_ID EXISTS IN COURSE_SECTION
    V_EXC := 2; 
    SELECT C_SEC_ID
    INTO V_CSEC_ID
    FROM COURSE_SECTION
    WHERE C_SEC_ID = P_CSEC_ID;

    -- VERIFY COMBINATION EXISTS IN ENROLLMENT
    V_EXC := 3;
    SELECT C_SEC_ID, S_ID, GRADE
    INTO V_CSEC_ID, V_SID, V_GRADE
    FROM ENROLLMENT
    WHERE C_SEC_ID = P_CSEC_ID AND S_ID = P_SID;

    -- IF COMBINATION EXISTS, CHECK IF IT'S NECESSARY TO UPDATE  GRADE
    IF V_GRADE = P_GRADE THEN
        DBMS_OUTPUT.PUT_LINE('Student ID ' || P_SID || ' found, no update needed!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student ID ' || P_SID || ' found, update needed!');
        UPDATE ENROLLMENT SET GRADE = P_GRADE WHERE S_ID = P_SID;
        DBMS_OUTPUT.PUT_LINE('Student ID ' || P_SID || ' grade was updated!');     
        -- COMMIT;
    END IF;

    V_AGE := any_ruiz_f1(V_DOB);

    DBMS_OUTPUT.PUT_LINE('Student ' || V_SFNAME || ' ' || V_SLNAME 
            || ' birthdate is ' || V_DOB
            || ' and is ' || V_AGE || ' years old.');    

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF V_EXC = 1 THEN -- S_ID DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Student ID ' || P_SID || ' does not exist, please add it first!');
        ELSIF V_EXC = 2 THEN -- SKILL_ID DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Course section ' || P_CSEC_ID || ' does not exist, please add it first!');
        ELSIF V_EXC = 3 THEN -- COMBINATION DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Student ID ' || P_SID || ' is not enrolled in  course section' || P_CSEC_ID|| ' please add it first!');
        END IF;
END;
/

-- S_ID DOES NOT EXIST
EXEC any_ruiz_p1(7, 1, 'A')
-- C_SEC_ID DOES NOT EXIST
EXEC any_ruiz_p1(6, 14, 'A')
-- Combinaton DOES NOT EXIST
EXEC any_ruiz_p1(1, 13, 'A')
-- Combination exists and grade is updated
EXEC any_ruiz_p1(2, 1, 'A')
-- Combination exists and grade is not updated
EXEC any_ruiz_p1(1, 1, 'A')

-- Question 2

CREATE OR REPLACE PROCEDURE any_ruiz_p2 AS
    -- STEP 1 DECLARE CURSOR
    CURSOR fac_cur IS
        SELECT F_ID, F_LAST, F_FIRST, F_RANK
        FROM FACULTY;

    -- STEP 2 DECLARE INNER CURSOR WITH PARAMETER
    CURSOR c_course (p_f_id IN FACULTY.F_ID%TYPE) IS
        SELECT C.COURSE_NAME, CS.C_SEC_ID, LO.BLDG_CODE, LO.ROOM
        FROM COURSE C, COURSE_SECTION CS, LOCATION LO
        WHERE C.COURSE_ID = CS.COURSE_ID AND CS.LOC_ID = LO.LOC_ID
        AND CS.F_ID = p_f_id;
    V_FID FACULTY.F_ID%TYPE;
    V_FLNAME FACULTY.F_LAST%TYPE;
    V_FFNAME FACULTY.F_FIRST%TYPE;
    V_FRANK FACULTY.F_RANK%TYPE;
    V_CSECID COURSE_SECTION.C_SEC_ID%TYPE;
    V_COURSENAME COURSE.COURSE_NAME%TYPE;
    V_BLDGCODE LOCATION.BLDG_CODE%TYPE;
    V_ROOM LOCATION.ROOM%TYPE;

BEGIN
    OPEN fac_cur;
        
    FETCH fac_cur INTO V_FID, V_FLNAME, V_FFNAME, V_FRANK;
    WHILE fac_cur%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Faculty member id: ' || V_FID || ' Full Name: ' || V_FLNAME || ' ' || V_FFNAME || ' Rank: ' || V_FRANK);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
        OPEN c_course(V_FID);
        FETCH c_course INTO V_COURSENAME, V_CSECID, V_BLDGCODE, V_ROOM;
        WHILE c_course%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Course Name: ' || V_COURSENAME || ' Course Section ID: ' || V_CSECID || ' Building Code: ' || V_BLDGCODE || ' Room: ' || V_ROOM);
            FETCH c_course INTO V_COURSENAME, V_CSECID, V_BLDGCODE, V_ROOM;
        END LOOP;
        CLOSE c_course;
    FETCH fac_cur INTO V_FID, V_FLNAME, V_FFNAME, V_FRANK;
    END LOOP;
    CLOSE fac_cur;
END;
/
EXEC any_ruiz_p2

SPOOL OFF;