SPOOL './midterm.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
-- Question 1
-- A
CREATE OR REPLACE FUNCTION any_ruiz_f1 (p_date IN DATE)
RETURN NUMBER AS
	v_sysdate DATE;
BEGIN
    v_sysdate := SYSDATE();
    RETURN FLOOR((v_sysdate - p_date) / 365);
END;
/

-- B
SELECT any_ruiz_f1('5 Jan 2017') as result from DUAL;
select * from STUDENT;
SELECT * from COURSE_SECTION;
SELECT * from ENROLLMENT;
-- C

-- Create a procedure called your name p1 that accepts two numbers, and a character. The first number
-- represent the s_id, the second number represent the c_sec_id, the third parameter represent the GRADE. The
-- procedure must be able to:
-- Validate the S_id (Display appropriate message to the client when the id does not exist) (5 marks)
-- Validate the c_sec_id (Display appropriate message to the client when the id does not exist) (5 marks)
-- Determine if the combination of s_id and c_sec id existed. (5 marks)
-- Update the grade of the student. Use the function your _name f1 to calculate the AGE of the student,
-- and display the student FULL name, his/her birthdate and age. (5 marks)

create or replace procedure any_p1(p_sid number, p_csec_id number, p_grade char) AS
    -- first step define cursor
    cursor st_cur is
        SELECT S_ID, S_FIRST, S_LAST, S_DOB
        FROM STUDENT
        WHERE S_ID = P_SID;
    v_st_row st_cur%rowtype;

    cursor csec_cur is
        SELECT C_SEC_ID
        FROM COURSE_SECTION
        WHERE C_SEC_ID = P_CSEC_ID;
    v_csec_row csec_cur%rowtype;

    cursor enr_cur is
        SELECT C_SEC_ID, S_ID, GRADE
        FROM ENROLLMENT
        WHERE C_SEC_ID = P_CSEC_ID AND S_ID = P_SID;
    v_enr_row enr_cur%rowtype;
begin
    -- step 2: open cursors
    open st_cur;
    open csec_cur;
    open enr_cur;

    -- step 3 fetch

    fetch st_cur into v_st_row;
    fetch csec_cur into v_csec_row;
    fetch enr_cur into v_enr_row;

    if st_cur%notfound then
        dbms_output.put_line('St id: ' || p_sid || ' not found!');
    else 
        if csec_cur%notfound then 
            dbms_output.put_line('section id: ' || p_csec_id || ' not found!');
        else
            if enr_cur%notfound then
                dbms_output.put_line('st id: ' || p_sid || ' not enrolled in course ' || p_csec_id);
            else
                if v_enr_row.grade = p_grade then
                    dbms_output.put_line('St id: ' || p_sid || ' found!, no update needed');
                else 
                    update enrollment set grade = p_grade;
                    dbms_output.put_line('St id: ' || p_sid || ' found and updated!');
                    dbms_output.put_line('St id: ' || p_sid || '. Full name: ' || 
                        v_st_row.s_first || ' ' || v_st_row.s_last || '. Birthdate: ' ||
                        v_st_row.s_dob || '. Age: ' || any_ruiz_f1(v_st_row.s_dob) || ' years old.'
                    );
                end if;
            end if;
        end if;
    end if;
end;
/ 

-- S_ID DOES NOT EXIST
EXEC any_p1(7, 1, 'A')
-- C_SEC_ID DOES NOT EXIST
EXEC any_p1(6, 14, 'A')
-- Combinaton DOES NOT EXIST
EXEC any_p1(1, 13, 'A')
-- Combination exists and grade is updated
EXEC any_p1(2, 1, 'B')
-- Combination exists and grade is not updated
EXEC any_p1(1, 1, 'A')

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
-- step 3 open cursor 
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

-- We need to display all the students and their age. Using function of question 1, create a procedure to display all students
-- s_id, s_last, s_first, s_dob, s_age
select * from student

create or replace procedure all_st as
    cursor st_cur is
        select s_id, s_last, s_first, s_dob
        from student;
    v_st_row st_cur%rowtype;
begin
    open st_cur;
    fetch st_cur into v_st_row;
    while st_cur%found loop
        dbms_output.put_line('st id: '|| v_st_row.s_id || 
        '. Full name: ' || v_st_row.s_first || ' ' || v_st_row.s_last || 
        '. Birthdate: ' || v_st_row.s_dob || '. Age: ' || any_ruiz_f1(v_st_row.s_dob) || ' years old.');
        fetch st_cur into v_st_row;
    end loop;
end;
/

exec all_st
SPOOL OFF;