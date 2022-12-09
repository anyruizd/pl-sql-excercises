SPOOL './lab-9.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;

/*

Question 1: des02, script 7clearwater
    Create a package with OVERLOADING procedure used to insert a new customer. The user has
    the choice of providing either
    a/ Last Name, address
    b/ Last Name, birthdate
    c/ Last Name, First Name, birthdate
    d/ Customer id, last name, birthdate
    In case no customer id is provided, please use a number from a sequence called customer_sequence.

*/
drop sequence CUSTOMER_SEQUENCE;
create sequence customer_sequence start with 13 increment by 1 nocache;

create or replace package customer_pkg is
    procedure cus_insert(p_lname VARCHAR2, p_address VARCHAR2);
    procedure cus_insert(p_lname VARCHAR2, p_birthdate DATE);
    procedure cus_insert(p_lname VARCHAR2, p_fname VARCHAR2, p_birthdate DATE);
    procedure cus_insert(p_c_id NUMBER, p_lname VARCHAR2, p_birthdate DATE);
end;
/

create or replace package body customer_pkg is
    procedure cus_insert(p_lname VARCHAR2, p_address VARCHAR2) as
    begin
        insert into CUSTOMER(c_id, c_last, c_address)
        values(customer_sequence.nextval, p_lname, p_address);
        commit;
        dbms_output.put_line('Customer inserted successfully');
    end cus_insert;
    procedure cus_insert(p_lname VARCHAR2, p_birthdate DATE) as
    begin
        insert into CUSTOMER(c_id, c_last, c_birthdate)
        values(customer_sequence.nextval, p_lname, p_birthdate);
        commit;
        dbms_output.put_line('Customer inserted successfully');
    end cus_insert;
    procedure cus_insert(p_lname VARCHAR2, p_fname VARCHAR2, p_birthdate DATE) as
    begin
        insert into CUSTOMER(c_id, c_last, c_first, c_birthdate)
        values(customer_sequence.nextval, p_lname, p_fname, p_birthdate);
        commit;
        dbms_output.put_line('Customer inserted successfully');
    end cus_insert;
    procedure cus_insert(p_c_id NUMBER, p_lname VARCHAR2, p_birthdate DATE) as
    begin
        insert into CUSTOMER(c_id, c_last, c_birthdate)
        values(p_c_id, p_lname, p_birthdate);
        commit;
        dbms_output.put_line('Customer inserted successfully');
    end cus_insert;
end;
/


exec customer_pkg.cus_insert('Ruiz', '1975 Maisonneuve Boulevard Ou');
exec customer_pkg.cus_insert('Ruiz', TO_DATE('1991-02-14', 'YYYY-MM-DD'));
exec customer_pkg.cus_insert('Ruiz', 'Any', TO_DATE('1991-02-14', 'YYYY-MM-DD'));
exec customer_pkg.cus_insert(16,'Ruiz', TO_DATE('1991-02-14', 'YYYY-MM-DD'));
SELECT * FROM CUSTOMER order by c_id;
/*

Question 2: des03, script 7northwoods
    Create a package with OVERLOADING procedure used to insert a new student. The user has the
    choice of providing either
    a/ Student id, last name, birthdate
    b/ Last Name, birthdate
    c/ Last Name, address
    d/ Last Name, First Name, birthdate, faculty id
    In case no student id is provided, please use a number from a sequence called student_sequence.
    Make sure that the package with the overloading procedure is user friendly enough to handle error such as:
    - Faculty id does not exist
    - Student id provided already existed
    - Birthdate is in the future
    Please test for all cases and hand in spool file.

*/

create sequence student_sequence start with 9 increment by 1 nocache;

create or replace package student_pkg is
    procedure student_insert(p_s_id NUMBER, p_s_last VARCHAR2, p_birthdate DATE);
    procedure student_insert(p_s_last VARCHAR2, p_birthdate DATE);
    procedure student_insert(p_s_last VARCHAR2, p_address VARCHAR2);
    procedure student_insert(p_s_last VARCHAR2, p_s_first VARCHAR2, p_birthdate DATE, p_f_id NUMBER);
    procedure check_birthdate(p_birthdate DATE, is_valid OUT BOOLEAN);
    procedure check_student_id(p_s_id NUMBER, s_id_exists OUT BOOLEAN);
    procedure check_faculty_id(p_f_id NUMBER, f_id_exists OUT BOOLEAN );
end;
/

create or replace package body student_pkg is
    procedure check_birthdate(p_birthdate DATE, is_valid OUT BOOLEAN) AS
    begin
        -- if (p_birthdate - sysdate) = 0 then
        if p_birthdate > sysdate then
            is_valid := FALSE;
        else
            is_valid := TRUE;
        end if;
    end check_birthdate;
    procedure check_faculty_id(p_f_id NUMBER, f_id_exists OUT BOOLEAN ) AS
        v_f_id NUMBER;
    begin
        select f_id into v_f_id from FACULTY where f_id = p_f_id;
        f_id_exists := TRUE;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            f_id_exists := FALSE;
    end check_faculty_id;
    procedure check_student_id(p_s_id NUMBER, s_id_exists OUT BOOLEAN) AS
        v_s_id NUMBER;
    begin
        select s_id into v_s_id from STUDENT where s_id = p_s_id;
        s_id_exists := TRUE;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            s_id_exists := FALSE;
    end check_student_id;

    procedure student_insert(p_s_id NUMBER, p_s_last VARCHAR2, p_birthdate DATE) as
        birthdate_valid BOOLEAN;
        s_id_exists BOOLEAN;
    begin
        check_student_id(p_s_id, s_id_exists);
        if s_id_exists = TRUE then
            dbms_output.put_line('Error! Student id provided already existed');
        else
            check_birthdate(p_birthdate, birthdate_valid);
            if birthdate_valid = TRUE then
                insert into STUDENT(s_id, s_last, s_dob)
                values(p_s_id, p_s_last, p_birthdate);
                commit;
                dbms_output.put_line('Student inserted successfully');
            else
                dbms_output.put_line('Error! Birthdate is in the future');
            end if;
        end if;
    end student_insert;
    procedure student_insert(p_s_last VARCHAR2, p_birthdate DATE) as
        birthdate_valid BOOLEAN;
    begin
        check_birthdate(p_birthdate, birthdate_valid);
        if birthdate_valid = TRUE then
        insert into STUDENT(s_id, s_last, s_dob)
        values(student_sequence.nextval, p_s_last, p_birthdate);
        commit;
        dbms_output.put_line('Student inserted successfully');
        else
            dbms_output.put_line('Error!  Birthdate is in the future');
        end if;
    end student_insert;
    procedure student_insert(p_s_last VARCHAR2, p_address VARCHAR2) as
    begin
        insert into STUDENT(s_id, s_last, s_address)
        values(student_sequence.nextval, p_s_last, p_address);
        commit;
        dbms_output.put_line('Student inserted successfully');
    end student_insert;
    procedure student_insert(p_s_last VARCHAR2, p_s_first VARCHAR2, p_birthdate DATE, p_f_id NUMBER) as
        birthdate_valid BOOLEAN;
        f_id_exists BOOLEAN;
    begin
        check_faculty_id(p_f_id, f_id_exists);
        if f_id_exists = FALSE then
            dbms_output.put_line('Error! Faculty id does not exist');
        else
            check_birthdate(p_birthdate, birthdate_valid);
            if birthdate_valid = TRUE then
                insert into STUDENT(s_id, s_last, s_first, s_dob, f_id)
                values(student_sequence.nextval, p_s_last, p_s_first, p_birthdate, p_f_id);
                commit;
                dbms_output.put_line('Student inserted successfully');
            else
                dbms_output.put_line('Error! Birthdate is in the future');
            end if;
        end if;
    end student_insert;
end;
/

exec student_pkg.student_insert('Ruiz', TO_DATE('1991-02-14', 'YYYY-MM-DD'));
exec student_pkg.student_insert(10, 'Ruiz', TO_DATE('1991-02-14', 'YYYY-MM-DD'));
select student_sequence.nextval from dual;
exec student_pkg.student_insert('Ruiz', 'Any');
exec student_pkg.student_insert('Ruiz', 'Any', TO_DATE('1991-02-14', 'YYYY-MM-DD'), 1);

-- check with invalid birthdate
exec student_pkg.student_insert('Ruiz', TO_DATE('2023-02-14', 'YYYY-MM-DD'));
-- check with invalid student id
exec student_pkg.student_insert(2, 'Ruiz', TO_DATE('1991-02-14', 'YYYY-MM-DD'));
-- check with invalid faculty id
exec student_pkg.student_insert('Ruiz', 'Any', TO_DATE('1991-02-14', 'YYYY-MM-DD'), 6);

SPOOL off;
