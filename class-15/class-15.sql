-- cursor for loop two ways
-- Only needs step 1, step 2,3,4 will be done automaticalyy by the following:
-- FOR index In name_of_cursor LOOP
-- use . dot notation to access the column of the select
-- END LOOP;

-- Example 1. Using schemas scott, create a procedure called show_all to 
-- display all departments using cursor for loop syntax.


create or replace procedure show_all as
    cursor dept_cur is
    select deptno, dname, loc
    from dept;

begin
    for d in dept_cur loop
        dbms_output.put_line('Department ' || d.deptno || ' is ' || d.dname || ' located in the city of ' || d.loc);
    end loop;
end;
/

exec show_all

-- Example 2
-- Modify the procedure show_all of example 1 to 

create or replace procedure show_all as
    cursor dept_cur is
        select deptno, dname, loc
        from dept;
    cursor emp_cur(pc_deptno number) is
        select empno, ename, job, sal
        from emp
        where deptno = pc_deptno;

begin
    for d in dept_cur loop
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('Department ' || d.deptno || ' is ' || d.dname || ' located in the city of ' || d.loc);
        for e in emp_cur(d.deptno) loop
            dbms_output.put_line('Employee ' || e.empno || ' is ' || e.ename || ' works as a ' || e.job || ' and has a salary of ' || e.sal);
        end loop;
    end loop;
end;
/

exec show_all
-- no one in depto 40 so i'm moving an employee
update emp set deptno = 40 where empno = 7900;

-- syntax 2: we don't need any step, they're done automatically by including 
-- the select statement directly in the for loop as follow:

-- for index in (select statement) loop

-- Example 3. show_all_s2 to display all deptmnts using syntax 2

create or replace procedure show_all_s2 as
begin
    dbms_output.put_line('~~~~~~~~~~~~~Hello, this is syntax 2~~~~~~~~~~~~~~~');
    for d in (select deptno, dname, loc from dept) loop
    dbms_output.put_line('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
        dbms_output.put_line('Department ' || d.deptno || ' is ' || d.dname || ' located in the city of ' || d.loc);
        for e in (select empno, ename, job, sal from emp where deptno = d.deptno) loop
            dbms_output.put_line('Employee ' || e.empno || ' is ' || e.ename || ' works as a ' || e.job || ' and has a salary of ' || e.sal);
        end loop;
    end loop;
end;
/

exec show_all_s2

-- to cancel all the updates i just did.
rollback