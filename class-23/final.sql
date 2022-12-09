SPOOL './final.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
/*

    Question 2

*/
connect scott/tiger@localhost:1521/XE;

create or replace package final_q1 is
    function calc_area(n1 number) return number;
    function calc_area(n1 number, n2 number) return number;
end;
/
create or replace package body final_q1 is
    function calc_area(n1 number) return number is
    begin
        return n1*n1;
    end calc_area;
    function calc_area(n1 number, n2 number) return number is
    begin
        return n1*n2;
    end calc_area;
end;
/

create or replace procedure final_q1_p1(n1 number, n2 number) as
    v_area number;
    v_perimeter number;
    v_shape varchar2(10);
    e_negative exception;
begin
    if n1 < 0 or n2 < 0 then
        raise e_negative;
    end if;

    if n1 = n2 then
        v_area := final_q1.calc_area(n1);
        v_shape := 'square';
    else
        v_area := final_q1.calc_area(n1, n2);
        v_shape := 'rectangle';
    end if;
    v_perimeter := 2*(n1 + n2);
    dbms_output.put_line('For the ' || v_shape || ' of side ' || n1 || ' by ' || n2 || ', The area is ' || 
        v_area || ', and ' || v_perimeter || ' is the perimeter.');
    
    exception
    when e_negative then
        dbms_output.put_line('Error, sides cannot be negative!');
end;
/

exec final_q1_p1(2, 2);
exec final_q1_p1(2, -2);
exec final_q1_p1(2, 4);


/*
    Question 3 - des04

    We need to display all projects and the consultants who work for each project. Create 
    a procedure to display the project name and the last name of the manager of all the projects.
    Under each project display the first and the last name of the consultant who work in the project.

    Display next to the consultant's first name the start and end date (roll_on_date/roll_off_date)
    mgr_id is the id of the consultant who is the manager of the project
*/

connect des04/des04@localhost:1521/XE;
create or replace procedure final_q2 as
begin
    for p in (select project_name, c_last, p_id from project, consultant where mgr_id = c_id) loop
        dbms_output.put_line('---------------------------------------');
        dbms_output.put_line(p.project_name || ' - ' || p.c_last);
        dbms_output.put_line('---------------------------------------');
        for c in (select c_last, c_first, roll_on_date, roll_off_date, p_id, cons.c_id 
                 from consultant cons, project_consultant pc 
                 where pc.c_id = cons.c_id and pc.p_id = p.p_id) loop
            dbms_output.put_line('Consultant: ' || c.c_first || ' ' || c.c_last || '. Start date: ' || c.roll_on_date || '. End date: ' || c.roll_off_date);
        end loop;
    end loop;
end;
/

exec final_q2;

/*
    Question 4: 
    
    des04

    Create a table to audit the project_consultant as follow: 
    Create table audit_project_consultant (audit_id number, project_id number, consultant_id number,
    roll_on_date date, roll_off_date date, date_updated date, updating_user varchar2(30));
    Create a trigger for the table project_consultant used to record the roll_on_date, the old roll_off_date, who and 
    when the table project_consultant is updated.
*/
-- drop sequence project_consultant_audit_seq;
create sequence project_consultant_audit_seq;

-- drop table audit_project_consultant;
create table audit_project_consultant (
    audit_id number,
    project_id number,
    consultant_id number,
    roll_on_date date,
    roll_off_date date,
    date_updated date,
    updating_user varchar2(30)
);

create or replace trigger audit_project_consultant_trigger
    after update on project_consultant
    for each row
    WHEN (old.roll_on_date IS NOT NULL)
begin
    insert into audit_project_consultant values (
        project_consultant_audit_seq.nextval,
        :old.p_id,
        :old.c_id,
        :old.roll_on_date,
        :old.roll_off_date,
        sysdate,
        user
    );
end;
/

grant select, insert, update, delete on project_consultant to vampirito;
connect vampirito/vampirito@localhost:1521/XE;
UPDATE des04.project_consultant SET ROLL_OFF_DATE = TO_DATE('2022-01-01', 'YYYY-MM-DD')
WHERE p_id = 6 and c_id = 104;
commit;

connect des04/des04@localhost:1521/XE;
SELECT * from audit_project_consultant;

/*
    Question 5: 
    
    des03

    Create a procedure that accepts the student id, course section id, and grade, to insert or update
    the table enrollment. After the record is inserted (or updated), display DML performed (UPDATE or INSERT)
    the course name, the last and first bame of the student.

    Do no forget to hablde the errors such as:

    student_id, course section id does not exist

*/

connect des03/des03@localhost:1521/XE;

CREATE OR REPLACE PROCEDURE final_q5(P_SID NUMBER, P_CSEC_ID NUMBER, P_GRADE CHAR) AS
    V_SID STUDENT.S_ID%TYPE;
    V_CSEC_ID COURSE_SECTION.C_SEC_ID%TYPE;
    V_COURSE_ID COURSE.COURSE_ID%TYPE;
    V_GRADE ENROLLMENT.GRADE%TYPE;
    V_SFNAME STUDENT.S_FIRST%TYPE;
    V_SLNAME STUDENT.S_LAST%TYPE;
    V_COURSE_NAME COURSE.COURSE_NAME%TYPE;
    V_EXC NUMBER;
BEGIN
    -- VERIFY S_ID EXISTS IN STUDENT 
    V_EXC := 1; 
    SELECT S_ID, S_FIRST, S_LAST
    INTO V_SID, V_SFNAME, V_SLNAME
    FROM STUDENT
    WHERE S_ID = P_SID;

    -- VERIFY C_SEC_ID EXISTS IN COURSE_SECTION
    V_EXC := 2; 
    SELECT C_SEC_ID, COURSE_ID
    INTO V_CSEC_ID, V_COURSE_ID
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
        COMMIT;
    END IF;

    SELECT COURSE_NAME into V_COURSE_NAME FROM COURSE where COURSE_ID = V_COURSE_ID;

    DBMS_OUTPUT.PUT_LINE('Student id ' || P_SID || '. First name: ' || V_SFNAME || '. Last name: ' || V_SLNAME || 
    '. Enrolled in course  ' || V_COURSE_NAME);    

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF V_EXC = 1 THEN -- S_ID DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Student ID ' || P_SID || ' does not exist, please add it first!');
        ELSIF V_EXC = 2 THEN -- SKILL_ID DOES NOT EXIST
            DBMS_OUTPUT.PUT_LINE('Course section ' || P_CSEC_ID || ' does not exist, please add it first!');
        ELSIF V_EXC = 3 THEN -- COMBINATION DOES NOT EXIST -> INSERT IT
            DBMS_OUTPUT.PUT_LINE('Student number ' || P_SID || ' and course section ' || P_CSEC_ID || ' need to be inserted!');
            INSERT INTO ENROLLMENT(S_ID, C_SEC_ID, GRADE)
            VALUES(P_SID, P_CSEC_ID, P_GRADE);
            DBMS_OUTPUT.PUT_LINE('Student number ' || P_SID || ' and course section ' || P_CSEC_ID || ' inserted!');
            COMMIT;
            SELECT COURSE_NAME into V_COURSE_NAME FROM COURSE where COURSE_ID = V_COURSE_ID;

            DBMS_OUTPUT.PUT_LINE('Student id ' || P_SID || '. First name: ' || V_SFNAME || '. Last name: ' || V_SLNAME || 
            '. Enrolled in course  ' || V_COURSE_NAME);  
        END IF;
END;
/

-- S_ID DOES NOT EXIST
EXEC final_q5(7, 1, 'A')
-- C_SEC_ID DOES NOT EXIST
EXEC final_q5(6, 14, 'A')
-- Combinaton DOES NOT EXIST
EXEC final_q5(1, 13, 'A')
-- Combination exists and grade is updated
EXEC final_q5(2, 1, 'A')
-- Combination exists and grade is not updated
EXEC final_q5(1, 1, 'A')

spool off;