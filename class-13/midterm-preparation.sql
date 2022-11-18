-- We need to see all teachers (faculty member) and their course given. Create a procedure called
-- your_ name_p2 to display all faculty members (f_id, f_last, f_ first, f_rank). Under each faculty member,
-- display his/her course section given including the location of the course section (c_sec_id, course name,
-- bldg_code, room)

select * from FACULTY
select * from course_section
select * from course
select * from location

create or replace procedure any_p2 as
    -- step 1 define cursor 
    cursor fac_cur IS
        select f_id, f_last, f_first, f_rank
        from FACULTY;
    v_fac_row fac_cur%rowtype;

    -- step 1: define inner cursor 
    cursor c_sec_cur(p_c_sec_id) IS
        select c_sec_id, course_name, bldg_code, room
        from course_section cs, course c, location l
        where cs.course_id = c.course_id
            and cs.loc_id = lo.loc_id
            and cs.c_sec_id = p_c_sec_id;
    v_c_sec_row c_sec_cur%rowtype;
BEGIN

END;
/