SPOOL './final-simulation.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;

/* scott
1. Create overloading function named find_emp_info 
which returns a number represent the number of years of experience
if a date is passed into the function.(use the formula to find the peson age: FLOOR(sysdate-hiredate)/365.5)

if an employee number is passed to the function find_emp_info, it will return the
job of the employee 

We need to display all columns of the table emp, create a procedure
that accepts an employee number, using the overloading functions find_emp_info, just created
previously to find, to calculate and to display the following:

Employee number Y is N, an J with X years of experience earning a salary of $S.
Any negative value inserted into the procedure is considered an ERROR, you must handle
this error with an EXCEPTION, and display appropriate message.

Can you handle the case when the employee number inserted does not exist?
if yes, please make sure to display appropriate message when this happens.
Write a command to run the procedure and the expected result
*/
-- question 1
connect scott/tiger@localhost:1521/XE;
create or replace package final_q1 is
    function find_emp_info (p_empno number) return VARCHAR2;
    function find_emp_info (p_date date) return number;
end;
/

create or replace package body final_q1 is
    function find_emp_info (p_date date) return number is
        v_years number;
    begin
        select floor((sysdate-p_date)/365.25) into v_years from dual;
        return v_years;
    end;
    function find_emp_info (p_empno number) return VARCHAR2 is
        v_job varchar2(9);
    begin
        select job into v_job from emp where empno = p_empno;
        return v_job;
    end;
end;
/

select final_q1.find_emp_info(7369) from dual;
select final_q1.find_emp_info(sysdate -3650) from dual;


create or replace procedure display_emp_info (p_empno number) is
    v_years number;
    v_job varchar2(9);
    v_salary number;
    v_date date;
    e_negative EXCEPTION;
begin
    IF p_empno < 0 THEN
        RAISE e_negative;
    END IF;

    select hiredate into v_date from emp where empno = p_empno;
    v_years := final_q1.find_emp_info(v_date);
    v_job := final_q1.find_emp_info(p_empno);
    select sal into v_salary from emp where empno = p_empno;
    dbms_output.put_line('Employee number '||p_empno||' is '||v_job||' with '||v_years||' years of experience, earning a salary of $'||v_salary);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Employee number '||p_empno||' does not exist');
    WHEN e_negative THEN
        dbms_output.put_line('Error, employee number cannot be negative!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error');
end;
/

exec display_emp_info(7369);
exec display_emp_info(729);
exec display_emp_info(-729);

/*
2. Question 2: (20 mark) (use script 7northwoods)

Working with table student, create a function called your_name_find_age that
accepts the student_id, s_dob, to calculate the age of the student using the 
formula: Age = FLOOR((sysdate – birthdate)/365.5)
Create a procedure called your_name_p1 that accepts student id, s_last, s_first,
s_dob to INSERT or UPDATE table student (If the student ID is exist, it is 
an UPDATE. Otherwise, it is an INSERT)
For an INSERT, the value of the birthdate can be in the pass or in the future.
BUT, for an UPDATE, a birthdate in the FUTURE is considered an ERROR, please 
create an EXCEPTION to handle this kind of error.
Where Y is employee number, N is employee name, J is the job, S is the
salary, and X is number of years of experiences.

Any negative value inserted into the procedure is considered as an ERROR, you must
handle this error with an EXCEPTION, and display appropriate message.
Can you handle the case when the employee number inserted does not exist?
If yes, please make sure to display appropriate message when this happens.
Write a command to run the procedure and the expected result.
 
After the UPDATE or INSERT is committed, please display the confirmation of the
action performed (record updated OR record inserted) and use the function 
your_name_find_age to display the student’s information EITHER as:
Student number X is Y Z. Born on the M, N year old. OR
Student number X is Y Z. Not born yet.
Where X is the student ID, Y, Z are full name, M is the birthdate and N is the
age returned from the function.

*/
-- question 2
connect des03/des03@localhost:1521/XE;

create or replace function any_ruiz_find_age (p_sid number, p_dob date) return number is
    v_age number;
begin
    select floor((sysdate-p_dob)/365.25) into v_age from dual;
    return v_age;
end;

create or replace procedure any_ruiz_p1 (p_sid number, p_last varchar2, p_first varchar2, p_dob date) is
    e_future_birthdate EXCEPTION;
    v_age number;
    v_sid number;
begin
    select s_id into v_sid from student where s_id = p_sid;
    IF p_dob > sysdate THEN
        RAISE e_future_birthdate;
    END IF;
    update student set s_last = p_last, s_first = p_first, s_dob = p_dob where s_id = p_sid;
    commit;
    dbms_output.put_line('Student updated');
    v_age := any_ruiz_find_age(p_sid, p_dob);
    IF v_age < 0 THEN
        dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. not born yet.');
    ELSE
        dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. born on the '||p_dob||', '||v_age||' year old.');
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        insert into student(s_id, s_last, s_first,s_dob) values (p_sid, p_last, p_first, p_dob);
        commit;
        dbms_output.put_line('Record inserted');
        v_age := any_ruiz_find_age(p_sid, p_dob);
        IF v_age < 0 THEN
            dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. Not born yet.');
        ELSE
            dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. Born on the '||p_dob||', '||v_age||' years old.');
        END IF;
    WHEN e_future_birthdate THEN
        dbms_output.put_line('Error, birthdate cannot be in the future!');
end;
/

exec any_ruiz_p1(1, 'Ruiz', 'Any', '01-JAN-2014');
exec any_ruiz_p1(1, 'Ruiz', 'Any', '01-JAN-2024');
exec any_ruiz_p1(7, 'Ruiz', 'Any', '14-feb-1991');
exec any_ruiz_p1(8, 'Ruiz', 'Any', '01-JAN-2024');
select * from STUDENT;


/*
Question 3: scott

We need to display all departments and the employees who work in each
department. Create a procedure to display the department name and the 
location of each department. Under each department, display the name, 
job, salary, hiredate, and the number of years of experiences of the 
employee who work for the department.

*/
-- question 3
connect scott/tiger@localhost:1521/XE;

create or replace procedure question_3 AS
begin
    for d in (select deptno, dname, loc from dept) loop
        dbms_output.put_line('---------------------------------------');
        dbms_output.put_line(d.dname||' '||d.loc);
        dbms_output.put_line('---------------------------------------');
        for e in (select ename, job, sal, hiredate from emp where deptno = d.deptno) loop
            dbms_output.put_line('- Name: ' || e.ename||'. Position: '||e.job||'. Salary: '||e.sal||'. Hiring date: '||e.hiredate || '. Years of experience: '|| final_q1.display_emp_info(e.hiredate));
        end loop;
    end loop;
end;
/

exec question_3;

/*

Question 4: (20 mark) (use script scott_emp_dept)
Create a table to audit the table em as follow:
CREATE TABLE audit_emp (audit_id NUMBER, old_empno NUMBER, old_ename
NUMBER, old_hiredate DATE, old_salary NUMBER, old_job VARCHAR2(40), updating_user VARCHAR2(30), date_updated DATE)
Create a trigger for the table EMP used to record the old name, hiredate, job, salary, who and when the table emp is updated.

*/

-- question 4
connect scott/tiger@localhost:1521/XE;
-- DROP sequence emp_audit_seq;
create sequence emp_audit_seq;

-- DROP table audit_emp;

create table audit_emp (audit_id NUMBER, old_empno NUMBER, old_ename VARCHAR2(10), old_hiredate DATE, old_salary NUMBER, old_job VARCHAR2(40), updating_user VARCHAR2(30), date_updated DATE);

create or replace trigger audit_emp_trigger
after update on emp
for each row
WHEN (old.grade IS NOT NULL)
    begin
        insert into audit_emp values (emp_audit_seq.nextval, :old.empno, :old.ename, :old.hiredate, :old.sal, :old.job, user, sysdate);
    end;
/

grant select, insert, update, delete on emp to vampirito;

-- 
connect vampirito/vampirito@localhost:1521/XE;
UPDATE scott.emp SET ename = 'ruiz'
WHERE empno = 7934;
commit;

connect scott/tiger@localhost:1521/XE;
SELECT * FROM audit_emp;
desc emp
/*
Question 5:
(run the command to create all tables of script 7northwoods and scott_emp_dept in one user’s schemas for this question)
Create a package specification and package body (name the package: your_name_final) with all the procedures and functions of question 2,3
Execute the package’s procedure at least 3 times.
*/
-- question 5
create or replace package any_ruiz_final is
    function any_ruiz_find_age (p_sid number, p_dob date) return number;
    procedure any_ruiz_p1 (p_sid number, p_last varchar2, p_first varchar2, p_dob date);
    procedure question_3;
end;

create or replace package body any_ruiz_final is
    function any_ruiz_find_age (p_sid number, p_dob date) return number is
        v_age number;
    begin
        select floor((sysdate-p_dob)/365.25) into v_age from dual;
        return v_age;
    end any_ruiz_find_age;
    procedure any_ruiz_p1 (p_sid number, p_last varchar2, p_first varchar2, p_dob date) is
        e_future_birthdate EXCEPTION;
        v_age number;
        v_sid number;
    begin
        select s_id into v_sid from student where s_id = p_sid;
        IF p_dob > sysdate THEN
            RAISE e_future_birthdate;
        END IF;
        update student set s_last = p_last, s_first = p_first, s_dob = p_dob where s_id = p_sid;
        commit;
        dbms_output.put_line('Student updated');
        v_age := any_ruiz_find_age(p_sid, p_dob);
        IF v_age < 0 THEN
            dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. not born yet.');
        ELSE
            dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. born on the '||p_dob||', '||v_age||' year old.');
        END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            insert into student(s_id, s_last, s_first,s_dob) values (p_sid, p_last, p_first, p_dob);
            -- commit;
            dbms_output.put_line('Record inserted');
            v_age := any_ruiz_find_age(p_sid, p_dob);
            IF v_age < 0 THEN
                dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. Not born yet.');
            ELSE
                dbms_output.put_line('Student number '||p_sid||' is '||p_last||' '||p_first||'. Born on the '||p_dob||', '||v_age||' years old.');
            END IF;
        WHEN e_future_birthdate THEN
            dbms_output.put_line('Error, birthdate cannot be in the future!');
    end any_ruiz_p1;
    procedure question_3 AS
    begin
        for d in (select deptno, dname, loc from dept) loop
            dbms_output.put_line('---------------------------------------');
            dbms_output.put_line(d.dname||' '||d.loc);
            dbms_output.put_line('---------------------------------------');
            for e in (select ename, job, sal, hiredate from emp where deptno = d.deptno) loop
                dbms_output.put_line('- ' || e.ename||' '||e.job||' '||e.sal||' '||e.hiredate);
            end loop;
        end loop;
    end question_3;
end;
/

exec any_ruiz_final.any_ruiz_p1(1, 'Ruiz', 'Any', '01-JAN-2024');
exec any_ruiz_final.any_ruiz_p1(7, 'Ruiz', 'Any', '14-feb-1991');
exec any_ruiz_final.question_3;

spool off;


select * from consultant;
select * from PROJECT;
select p_id, c_id, roll_on_date, roll_off_date from PROJECT_CONSULTANT;