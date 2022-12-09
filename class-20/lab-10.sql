SPOOL './lab-10.txt';
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
/*

    Question 1: (use schemas des02 with script 7clearwater)
    We need to know WHO, and WHEN the table CUSTOMER is
    modified.
    Create table, sequence, and trigger to record the needed information.
    Test your trigger!

*/

-- connect sys/MyPassword123#@localhost:1521/XE as sysdba;
-- DROP USER vampirito CASCADE;
-- CREATE USER vampirito IDENTIFIED BY vampirito;
-- GRANT connect , resource, create view TO vampirito;
-- connect vampirito/vampirito@localhost:1521/XE;

-- connect sys/MyPassword123#@localhost:1521/XE as sysdba;
-- DROP USER halley CASCADE;
-- CREATE USER halley IDENTIFIED BY halley;
-- GRANT connect , resource, create view TO halley;
-- connect halley/halley@localhost:1521/XE;

-- drop sequence cust_audit_seq;
-- drop table cust_audit;

connect des02/des02@localhost:1521/XE;
create sequence cust_audit_seq;
create table cust_audit(cust_audit_id number, date_updated date, updating_user varchar(20));

create or replace trigger cust_audit_trigger
after insert or update or delete on customer
BEGIN
    insert into cust_audit
    values(cust_audit_seq.NEXTVAL, sysdate, user);
END;
/

grant select, insert, update, delete on customer to vampirito;
grant select, insert, update, delete on customer to halley;

-- vampirito
connect vampirito/vampirito@localhost:1521/XE;
UPDATE des02.customer SET c_city = 'Medellin' 
WHERE c_id = 6;
commit;

-- halley
connect halley/halley@localhost:1521/XE;
UPDATE des02.customer SET c_city = 'Montreal' 
WHERE c_id = 4;
commit;

-- des02
connect des02/des02@localhost:1521/XE;
SELECT cust_audit_id, TO_CHAR(date_updated, 'DD-MM-YYYY HH:MI:SS AM'), 
updating_user FROM  cust_audit;


/*
    Question 2: 

    Table ORDER_LINE is subject to INSERT, UPDATE, and
    DELETE, create a trigger to record who, when, and the action
    performed on the table order_line in a table called order_line_audit.
    (hint: use UPDATING, INSERTING, DELETING to verify for
    action performed. For example: IF UPDATING THEN …)
    Test your trigger!

*/

-- drop sequence order_line_audit_seq;
-- drop table order_line_audit;

create sequence order_line_audit_seq;
create table order_line_audit(ol_audit_id number, date_updated date, updating_user varchar(20), action_performed VARCHAR2(30));

create or replace trigger order_line_audit_trigger
after insert or update or delete on order_line
BEGIN
    IF INSERTING THEN
        INSERT INTO order_line_audit 
        VALUES(order_line_audit_seq.NEXTVAL, sysdate, user,'INSERT');
    ELSIF UPDATING THEN 
        INSERT INTO order_line_audit 
        VALUES(order_line_audit_seq.NEXTVAL, sysdate, user,'UPDATE');
    ELSIF DELETING THEN 
        INSERT INTO order_line_audit 
        VALUES(order_line_audit_seq.NEXTVAL, sysdate, user,'DELETE');
    END IF;
END;
/

grant select, insert, update, delete on order_line to vampirito;
grant select, insert, update, delete on order_line to halley;

-- vampirito
connect vampirito/vampirito@localhost:1521/XE;
UPDATE des02.order_line SET ol_quantity = 5
WHERE o_id = 1 and inv_id = 3;
commit;

INSERT INTO des02.order_line
VALUES(6,11,4);
commit;

DELETE FROM des02.order_line
WHERE o_id = 5 AND inv_id = 19;
commit;

-- halley
connect halley/halley@localhost:1521/XE;
UPDATE des02.order_line SET ol_quantity = 5
WHERE o_id = 6 and inv_id = 7;
commit;

-- des02
connect des02/des02@localhost:1521/XE;
SELECT ol_audit_id, TO_CHAR(date_updated, 'DD-MM-YYYY HH:MI:SS AM'), 
updating_user, action_performed FROM  order_line_audit;


/*

    Question 3: (use script 7clearwater des02)
    Create a table called order_line_row_audit to record who, when,
    and the OLD value of ol_quantity every time the data of table
    ORDER_LINE is updated.
    Test your trigger!

*/

-- DROP TABLE order_line_row_audit;
-- DROP sequence order_line_row_audit_seq;

CREATE sequence order_line_row_audit_seq;
CREATE TABLE order_line_row_audit(row_number NUMBER, date_updated DATE, updating_user VARCHAR2(30),
              old_o_id number, old_inv_id number, old_ol_quantity NUMBER);

CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
AFTER UPDATE ON order_line
FOR EACH ROW
WHEN (old.ol_quantity IS NOT NULL)
  BEGIN
    INSERT INTO order_line_row_audit
    VALUES(order_line_row_audit_seq.NEXTVAL, sysdate, user, :OLD.o_id, :OLD.inv_id, :OLD.ol_quantity);
  END;
/

-- vampirito
connect vampirito/vampirito@localhost:1521/XE;
UPDATE des02.order_line SET ol_quantity = 5
WHERE o_id = 1 and inv_id = 14;
commit;

-- des02
connect des02/des02@localhost:1521/XE;
SELECT ROW_NUMBER, TO_CHAR(date_updated, 'DD-MM-YYYY HH:MI:SS Am') as modDate, updating_user, old_o_id, old_inv_id, old_ol_quantity FROM order_line_row_audit;

spool off;