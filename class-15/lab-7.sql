SPOOL './lab-7.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
/* Question 1:
    Run script 7northwoods in schemas des03
    Using CURSOR FOR LOOP syntax 1 in a procedure to display all the faculty 
    member (f_id, f_last, f_first, f_rank), under each faculty member, display
    all the student advised by that faculty member
    (s_id, s_last, s_first, birthdate, s_class).
*/

create or replace procedure l7q1 as
    cursor fac_cur is
    select f_id, f_last, f_first, f_rank
    from faculty;

    cursor st_cur(p_fid number)is
    select s_id, s_last, s_first, s_dob, s_class
    from student;
begin
    for f in fac_cur loop
        dbms_output.put_line('---------------------------------------------------');
        dbms_output.put_line('Faculty member id ' || f.f_id || ' is ' || f.f_first || ' ' || f.f_last || ', with rank ' || f.f_rank || '. Advises the following students: ');
        for st in st_cur(f.f_id) loop
            dbms_output.put_line('- Student id: ' || st.s_id || '. Fullname: ' || st.s_first || ' ' || st.s_last || '. Birthdate: ' || st.s_dob || '. Class: ' || st.s_class);
        end loop;
    end loop;
end;
/

exec l7q1;

/*
Question 2:
    Run script 7software in schemas des04
    Using %ROWTYPE in a procedure, display all the consultants. Under each 
    consultant display all his/her skill (skill description) and the status of 
    the skill (certified or not)

*/

create or replace procedure l7q2 as
    cursor con_cur is
    select *
    from consultant;
    con_row con_cur%rowtype;

    cursor skill_cur(p_c_id number) is
    select c_id, cs.skill_id, certification, skill_description
    from skill s, consultant_skill cs
    where cs.skill_id = s.skill_id 
    and cs.c_id = p_c_id;
    skill_row skill_cur%rowtype;
begin
    open con_cur;
    fetch con_cur into con_row;
    while con_cur%found loop
        dbms_output.put_line('---------------------------------------------------');
        dbms_output.put_line('Consultant id ' || con_row.c_id || ' is ' || con_row.c_first || ' ' || con_row.c_last || '. Has the following skills: ');
        open skill_cur(con_row.c_id);
        fetch skill_cur into skill_row;
        while skill_cur%found loop
            dbms_output.put_line('- Skill id: ' || skill_row.skill_id || '. Description: ' || skill_row.skill_description || '. Certified: ' || skill_row.certification);
            fetch skill_cur into skill_row;
        end loop;
        close skill_cur;
    fetch con_cur into con_row;
    end loop;
    close con_cur;
end;
/

exec l7q2;

/*
Question 3:
    Run script 7clearwater in schemas des02
    Using CURSOR FOR LOOP syntax 2 in a procedure to display all items 
    (item_id, item_desc, cat_id) under each item, display all the inventories
    belong to it.    
*/

create or replace procedure l7q3 as 
begin
    for i in (select item_id, item_desc, cat_id from item) loop
        dbms_output.put_line('---------------------------------------------------');
        dbms_output.put_line('Item id: ' || i.item_id || '. Item description: ' || i.item_desc || '. Category: ' || i.cat_id || '. Contains the following inventories: ');
        for iv in (select * from inventory where i.item_id = item_id) loop
            dbms_output.put_line('Inv id: ' || iv.inv_id || '. Color: ' || iv.color || '. Price: ' || iv.inv_price || '. Quantity: ' || iv.inv_qoh);
        end loop;
    end loop;
end;
/

exec l7q3;

/*
Question 4:
    Modify question 3 to display beside the item description the value of the 
    item (value = inv_price * inv_qoh).

*/

create or replace procedure l7q4 as
    v_value number;
begin
    for i in (select item_id, item_desc, cat_id from item) loop
        v_value := 0;
        for v in (select inv_qoh, inv_price from inventory where item_id = i.item_id) loop
            v_value := v_value + v.inv_qoh*v.inv_price;
        end loop;
        dbms_output.put_line('---------------------------------------------------');
        dbms_output.put_line('Item id: ' || i.item_id || '. Item description: ' || i.item_desc || '. Category: ' || i.cat_id || '. Total value: ' || v_value);
        for iv in (select * from inventory where item_id = i.item_id) loop
            dbms_output.put_line('Inv id: ' || iv.inv_id || '. Color: ' || iv.color || '. Price: ' || iv.inv_price || '. Quantity: ' || iv.inv_qoh || '. Inv value = ' || iv.inv_qoh*iv.inv_price);
        end loop;
    end loop;
end;
/

exec l7q4;

SPOOL off;