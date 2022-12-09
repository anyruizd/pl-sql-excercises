CONNECT des02/des02;

SPOOL C:\BD2\part10.txt

SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') FROM DUAL;


-- Question 1:

CREATE SEQUENCE customer_audit_seq;


CREATE TABLE customer_audit(customer_audit_id NUMBER, date_updated DATE, updating_user VARCHAR2(20));


CREATE OR REPLACE TRIGGER customer_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON customer
BEGIN
  INSERT INTO customer_audit 
  VALUES(customer_audit_seq.NEXTVAL, sysdate, user);
END;
/


GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO thiago;
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO julie;


connect thiago/123


UPDATE des02.customer SET c_last = 'Nelson 2' 
WHERE c_id = 6;

commit;
  

connect julie/123

  
  UPDATE des02.customer SET c_last = 'Miller 2' 
  WHERE c_id = 3;
  
  commit;
  

connect des02/des02


SELECT customer_audit_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS Am'), 
   updating_user FROM  customer_audit;




-- Question 2:


connect des02/des02

CREATE SEQUENCE order_line_audit_seq;


CREATE TABLE order_line_audit(order_line_audit_id NUMBER, date_updated DATE, updating_user VARCHAR2(20), action_performed VARCHAR2(30));



CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON order_line
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


GRANT SELECT, INSERT, UPDATE, DELETE ON order_line TO thiago;
GRANT SELECT, INSERT, UPDATE, DELETE ON order_line TO julie;

connect julie/123

  UPDATE des02.order_line SET ol_quantity = 8 
  WHERE o_id = 6 AND inv_id = 7;
  
  commit;


connect thiago/123;

   INSERT INTO des02.order_line
   VALUES(5,32,20);


   DELETE FROM des02.order_line
   WHERE o_id = 5 AND inv_id = 13

commit;


connect des02/des02


  SELECT order_line_audit_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS Am'), 
   updating_user, action_performed FROM  order_line_audit;





-- Question 3:

connect des02/des02

CREATE SEQUENCE order_line_row_audit_seq;


CREATE TABLE order_line_row_audit(row_number NUMBER, date_updated DATE, updating_user VARCHAR2(30), old_o_id NUMBER, old_inv_id NUMBER, old_ol_quantity NUMBER);



CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
    AFTER UPDATE ON order_line
	FOR EACH ROW
	WHEN(old.ol_quantity IS NOT NULL)
BEGIN
    INSERT INTO order_line_row_audit
	VALUES(order_line_audit_seq.NEXTVAL, sysdate, user, :OLD.o_id, :OLD.inv_id, :OLD.ol_quantity);
END;
/



connect julie/123


  UPDATE des02.order_line SET ol_quantity = 2 
  WHERE o_id = 1 AND inv_id = 1;
  
  
  commit;

connect thiago/123


  UPDATE des02.order_line SET ol_quantity = 3 
  WHERE o_id = 3 AND inv_id = 24;
  
  
  UPDATE des02.order_line SET ol_quantity = 9 
  WHERE o_id = 5 AND inv_id = 8;

  
  commit;


connect des02/des02


SELECT ROW_NUMBER, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS Am'), updating_user, old_o_id, old_inv_id, old_ol_quantity FROM order_line_row_audit;


SPOOL OFF;

select * from ORDER_LINE
DROP TRIGGER order_line_row_audit_trigger;