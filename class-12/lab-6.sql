SPOOL './lab-6.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
-- Question 1:
-- Run script 7northwoods in schemas des03
-- Create a procedure to display all the faculty member 
-- (f_id, f_last, f_first, f_rank), under each faculty member, display all the 
-- student advised by that faculty member
-- (s_id, s_last, s_first, birthdate, s_class).

create or replace procedure l6q1 as 
    -- step 1: declare cursor
    cursor fac_cur IS
        select f_id, f_last, f_first, f_rank
        from FACULTY;
    v_fac_row fac_cur%ROWTYPE;
    -- inner cursor with parameter step 1
    cursor st_cur(p_f_id number) IS
        select s_id, s_last, s_first, s_dob, s_class, f_id
        from STUDENT
        where f_id = p_f_id;
    v_st_row st_cur%ROWTYPE;
BEGIN
    -- step 2: open outer cursor
    open fac_cur;

    -- step 3: fetch outer cur
    fetch fac_cur into v_fac_row;
    while fac_cur%found loop
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Faculty member id: ' || v_fac_row.f_id || ' name is ' || v_fac_row.f_last
            || ' ' || v_fac_row.f_first || ' and rank ' || v_fac_row.f_rank);
        -- step 2: open inner cursor
        open  st_cur(v_fac_row.f_id);
        -- step 3: fetch with inner cursor
        fetch st_cur into v_st_row;
        while st_cur%found loop
            DBMS_OUTPUT.PUT_LINE(' ' || 'Student number: ' || v_st_row.s_id || ' name: ' || v_st_row.s_last || ' ' || v_st_row.s_first || ' birthdate: ' || 
                v_st_row.s_dob || ' belongs to class ' || v_st_row.s_class);
            fetch st_cur into v_st_row;
        end loop;
        -- step 4 close inner cursor
        close st_cur;

        fetch fac_cur into v_fac_row;
    end loop;
    close fac_cur;
end;
/

exec l6q1;

-- Question 2:
-- Run script 7software in schemas des04
-- Create a procedure to display all the consultants. Under each consultant 
-- display all his/her skill (skill description) and the status of the skill 
-- (certified or not)

create or replace procedure l6q2 as 
-- step 1: define outer cursor 
    cursor cons_cur is
        select c_id, c_last, c_first
        from consultant;
    v_cons_row cons_cur%ROWTYPE;
-- step 1: inner cursor with parameter
    cursor skill_cur(p_c_id number) is
        select skill_description, certification
        from consultant_skill cs, skill sk
        where c_id = p_c_id and cs.skill_id = sk.skill_id;
    v_skill_row skill_cur%ROWTYPE;
begin
    -- step 2: open outer cursor
    open cons_cur;
    -- step 3: fetch
    fetch cons_cur into v_cons_row;
    while cons_cur%found loop
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Consultant number ' || v_cons_row.c_id || ' is ' || 
        v_cons_row.c_first || ' ' || v_cons_row.c_last);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
            -- step 2: open inner cursor
            open skill_cur(v_cons_row.c_id);
            -- step 3: fetch inner cursor
            fetch skill_cur into v_skill_row;
            while skill_cur%found loop
                DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skill_row.skill_description || ' cerfied: ' || v_skill_row.certification);
            fetch skill_cur into v_skill_row;
            end loop;
            -- step 4 close inner cursor
            close skill_cur;
        fetch cons_cur into v_cons_row;
    end loop;
    -- step 4: close outer cursor
    close cons_cur;
end;
/

exec l6q2;

-- Question 3:
-- Run script 7clearwater in schemas des02
-- Create a procedure to display all items (item_id, item_desc, cat_id) under 
-- each item, display all the inventories belong to it.

create or replace procedure l6q3 as 
    -- step 1: declare cursor
    cursor item_cur IS
        select item_id, item_desc, cat_id
        from ITEM;
    v_item_row item_cur%ROWTYPE;
    -- inner cursor with parameter step 1
    cursor inv_cur(p_item_id number) IS
        select inv_id, item_id, inv_qoh, inv_price
        from INVENTORY
        where item_id = p_item_id;
    v_inv_row inv_cur%ROWTYPE;

BEGIN

    -- step 2: open outer cursor
    open item_cur;

    -- step 3: fetch outer cur
    fetch item_cur into v_item_row;
    while item_cur%found loop
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Item id: ' || v_item_row.item_id || ' description: ' || v_item_row.item_desc || ' category id: ' || v_item_row.cat_id);
        -- step 2: open inner cursor
        open  inv_cur(v_item_row.item_id);
        -- step 3: fetch with inner cursor
        fetch inv_cur into v_inv_row;
        while inv_cur%found loop
            DBMS_OUTPUT.PUT_LINE('Inventory number: ' || v_inv_row.inv_id || ' item id: ' || v_inv_row.item_id || ' quantity: ' || v_inv_row.inv_qoh || ' price: ' || 
                v_inv_row.inv_price);
            fetch inv_cur into v_inv_row;
        end loop;
        -- step 4 close inner cursor
        close inv_cur;

        fetch item_cur into v_item_row;
    end loop;
    close item_cur;
end;
/
exec l6q3;

-- Question 4: 
-- Modify question 3 to display beside the item description the value of the 
-- item (value = inv_price * inv_qoh).

create or replace procedure l6q4 as 
    -- step 1: declare cursor
    cursor item_cur IS
        select item_id, item_desc, cat_id
        from ITEM;
    v_item_row item_cur%ROWTYPE;
    -- inner cursor with parameter step 1
    cursor inv_cur(p_item_id number) IS
        select inv_id, item_id, inv_qoh, inv_price
        from INVENTORY
        where item_id = p_item_id;
    v_inv_row inv_cur%ROWTYPE;

BEGIN
        -- step 2: open outer cursor
        open item_cur;
    
        -- step 3: fetch outer cur
        fetch item_cur into v_item_row;
        while item_cur%found loop
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item id: ' || v_item_row.item_id || ' description: ' || v_item_row.item_desc || ' category id: ' || v_item_row.cat_id);
            -- step 2: open inner cursor
            open  inv_cur(v_item_row.item_id);
            -- step 3: fetch with inner cursor
            fetch inv_cur into v_inv_row;
            while inv_cur%found loop
                DBMS_OUTPUT.PUT_LINE('Inventory number: ' || v_inv_row.inv_id || ' item id: ' || v_inv_row.item_id || ' quantity: ' || v_inv_row.inv_qoh || ' price: ' || 
                    v_inv_row.inv_price || ' value: ' || v_inv_row.inv_qoh * v_inv_row.inv_price);
                fetch inv_cur into v_inv_row;
            end loop;
            -- step 4 close inner cursor
            close inv_cur;
    
            fetch item_cur into v_item_row;
        end loop;
        close item_cur;
end;
/

exec l6q4;

-- Question 5:
-- Run script 7software in schemas des04
-- Create a procedure that accepts a consultant id, and a character used to 
-- update the status (certified or not) of all the SKILLs belonged to the 
-- consultant inserted. Display 4 information about the consultant such as 
-- id, name, ...Under each consultant display all his/her skill (skill 
-- description) and the OLD and NEW status of the skill (certified or not).

create or replace procedure l6q5(p_cons_id number, p_char char) as 
    -- step 1: declare cursor
    cursor cons_cur IS
        select c_id, c_first, c_last, c_phone, c_email
        from CONSULTANT
        where c_id = p_cons_id;
    v_cons_row cons_cur%ROWTYPE;
    -- inner cursor with parameter step 1
    cursor skill_cur(p_cons_id number) IS
        select cs.skill_id, skill_description, certification
        from consultant_skill cs, skill sk
        where c_id = p_cons_id and cs.skill_id = sk.skill_id
        FOR UPDATE OF certification;
    v_skill_row skill_cur%ROWTYPE;

BEGIN
    -- step 2: open outer cursor
    open cons_cur;
    -- step 3: fetch outer cur
    fetch cons_cur into v_cons_row;
    while cons_cur%found loop
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Consultant id: ' || v_cons_row.c_id || '. Full name: ' || v_cons_row.c_first || ' ' || v_cons_row.c_last || '. Phone: ' || 
            v_cons_row.c_phone || '. Email: ' || v_cons_row.c_email);
        -- step 2: open inner cursor
        open  skill_cur(p_cons_id);
        -- step 3: fetch with inner cursor
        fetch skill_cur into v_skill_row;
        while skill_cur%found loop
            DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skill_row.skill_description || '. Certified: ' || v_skill_row.certification || '. New status: ' || p_char);
            update CONSULTANT_SKILL
            set certification = p_char
            where current of skill_cur;
            fetch skill_cur into v_skill_row;
        end loop;
        -- step 4 close inner cursor
        close skill_cur;
    fetch cons_cur into v_cons_row;
    end loop;
    -- step 4: close outer cursor
    close cons_cur;
--commit;
end;
/

exec l6q5(101, 'Y');
SPOOL off;