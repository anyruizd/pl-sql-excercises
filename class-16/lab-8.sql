SPOOL './lab-8.txt'
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
/*
Question 1: (use script 7clearwater) des02
Modify the package order_package (Example of lecture on PACKAGE) by adding 
function, procedure to verify the quantity on hand before insert a row in 
table order_line and to update also the quantity on hand of table inventory.

Modify the package order_package (Example of lecture on PACKAGE) by adding 
function, procedure to verify the quantity on hand before insert a row in 
table order_line and to update also the quantity on hand of table inventory.

Test your package with different cases.
*/

CREATE OR REPLACE PACKAGE order_package IS
    global_inv_id NUMBER(6);
    global_quantity NUMBER(6);
    PROCEDURE create_new_order(current_c_id NUMBER, 
            current_meth_pmt VARCHAR2, 
            current_os_id NUMBER);
    PROCEDURE update_inventory(current_o_id NUMBER);
    PROCEDURE create_new_order_line(current_o_id NUMBER, quantity NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY order_package IS

    PROCEDURE create_new_order(current_c_id NUMBER, current_meth_pmt VARCHAR2, current_os_id NUMBER) AS
            current_o_id NUMBER;
        BEGIN
            SELECT order_sequence.NEXTVAL
            INTO   current_o_id
            FROM   dual;
            INSERT INTO orders 
            VALUES(current_o_id, sysdate, current_meth_pmt,
                    current_c_id, current_os_id);
            update_inventory(current_o_id);
            COMMIT;
    END create_new_order;

    PROCEDURE create_new_order_line(current_o_id NUMBER, quantity NUMBER) AS
            BEGIN
               INSERT INTO order_line 
               VALUES(current_o_id, global_inv_id,quantity);
               COMMIT;
            DBMS_OUTPUT.PUT_LINE('Order line number ' || current_o_id || ' created for inventory id ' || global_inv_id);
    END create_new_order_line;

    PROCEDURE update_inventory(current_o_id NUMBER) AS
            current_inv_qoh NUMBER(6);
            BEGIN
                SELECT inv_qoh
                INTO   current_inv_qoh
                FROM   inventory
                WHERE  inv_id = global_inv_id;
                IF current_inv_qoh > global_quantity THEN
                    create_new_order_line(current_o_id, global_quantity);
                    UPDATE inventory
                    SET    inv_qoh = current_inv_qoh - global_quantity
                    WHERE  inv_id = global_inv_id;
                    COMMIT;
                    DBMS_OUTPUT.PUT_LINE('Inventory id: ' || global_inv_id || ' was updated!');
                ELSIF current_inv_qoh = global_quantity THEN
                    create_new_order_line(current_o_id, global_quantity);
                    UPDATE inventory
                    SET    inv_qoh = 0
                    WHERE  inv_id = global_inv_id;
                    DBMS_OUTPUT.PUT_LINE('Inventory id: ' || global_inv_id || ' was updated!');
                    COMMIT;
                ELSIF current_inv_qoh < global_quantity THEN
                    create_new_order_line(current_o_id, current_inv_qoh);
                    UPDATE inventory
                    SET    inv_qoh = 0
                    WHERE  inv_id = global_inv_id;
                    COMMIT;
                    DBMS_OUTPUT.PUT_LINE('The amount you ordered is not fully available. We will have ' || (global_quantity - current_inv_qoh) ||'soon.');
                    DBMS_OUTPUT.PUT_LINE('Inventory id: ' || global_inv_id || ' was updated!');
                ELSIF current_inv_qoh = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('The quantity ' || global_quantity ||' you ordered is not available. We will have it soon.');
                END IF;

    END update_inventory;
END;
/

BEGIN
  order_package.global_inv_id := 32;
  order_package.global_quantity := 10;
END;
/ 

EXEC order_package.create_new_order(4,'FAVOR',6);

BEGIN
  order_package.global_inv_id := 21; 
  order_package.global_quantity := 2;
END;
/ 
EXEC order_package.create_new_order(3,'Cash',1);

/*

Question 2: (use script 7software)
Create a package with a procedure that accepts the consultant id, skill id, and a
letter to insert a new row into table consultant_skill.

After the record is inserted, display the consultant last and first name, 
skill description and the status of the certification as CERTIFIED or Not Yet Certified.


Do not forget to handle the errors such as: Consultant, skill does not exist and 
the certification is different than 'Y' or 'N'.


Test your package at least 2 times!

*/

CREATE OR REPLACE PACKAGE c_sk_package IS
    PROCEDURE create_new_consultant_skill(P_CID NUMBER, P_SKID NUMBER, P_CERTST CHAR);
    PROCEDURE DISPLAY_DATA(P_CID NUMBER, P_SKID NUMBER, P_CERTST CHAR);
END;

CREATE OR REPLACE PACKAGE BODY c_sk_package IS
    PROCEDURE DISPLAY_DATA(P_CID NUMBER, P_SKID NUMBER, P_CERTST CHAR) AS
        V_LNAME CONSULTANT.C_LAST%TYPE;
        V_FNAME CONSULTANT.C_FIRST%TYPE;
        V_SKDESC SKILL.SKILL_DESCRIPTION%TYPE;
        V_CERT VARCHAR(20);
    BEGIN
        SELECT C_FIRST, C_LAST, SKILL_DESCRIPTION
        INTO V_FNAME, V_LNAME, V_SKDESC
        FROM CONSULTANT C 
        JOIN CONSULTANT_SKILL C_SK ON C.C_ID = C_SK.C_ID
        JOIN SKILL SK ON SK.SKILL_ID = C_SK.SKILL_ID
        WHERE C.C_ID = P_CID
        AND C_SK.SKILL_ID = P_SKID;

        IF P_CERTST = 'Y' THEN
            V_CERT := 'CERTIFIED';
        ELSE
            V_CERT := 'Not Yet Certified';
        END IF;

        DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID 
            || ' is ' || V_FNAME || ' ' || V_LNAME
            || '. They work in ' || V_SKDESC || '. Certification status is: ' || V_CERT || '!');
    END DISPLAY_DATA;
    PROCEDURE create_new_consultant_skill(P_CID NUMBER, P_SKID NUMBER, P_CERTST CHAR) AS
        V_EXC NUMBER;
        V_SKID NUMBER;
        V_CID NUMBER;
        V_CERTST CHAR;
        BEGIN
            -- VERIFY C_ID EXISTS IN CONSULTANT 
            V_EXC := 1; 
            SELECT C_ID
            INTO V_CID
            FROM CONSULTANT
            WHERE C_ID = P_CID;

            -- VERIFY SK_ID EXISTS IN SKILL
            V_EXC := 2; 
            SELECT SKILL_ID
            INTO V_SKID
            FROM SKILL
            WHERE SKILL_ID = P_SKID;

            -- VERIFY COMBINATION EXISTS IN CONSULTANT_SKILL
            V_EXC := 3;
            SELECT C_ID, SKILL_ID, CERTIFICATION
            INTO V_CID, V_SKID, V_CERTST
            FROM CONSULTANT_SKILL
            WHERE SKILL_ID = P_SKID AND C_ID = P_CID;

            -- IF COMBINATION EXISTS, CHECK IF IT'S NECESSARY TO UPDATE  CERTIFICATION
            IF V_CERTST = P_CERTST THEN
                DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' found, no update needed!');
                DISPLAY_DATA(P_CID, P_SKID, P_CERTST);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' found, update needed!');
                IF P_CERTST <> 'Y' AND P_CERTST <> 'N' THEN
                    DBMS_OUTPUT.PUT_LINE('Certification code ' || P_CERTST || ' is invalid!');
                ELSE 
                    UPDATE CONSULTANT_SKILL SET CERTIFICATION = P_CERTST WHERE C_ID = P_CID;
                    DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' updated!');
                    DISPLAY_DATA(P_CID, P_SKID, P_CERTST);           
                    COMMIT;
                END IF;
            END IF;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF V_EXC = 1 THEN -- C_ID DOES NOT EXIST
                DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' does not exist, please add it first!');
            ELSIF V_EXC = 2 THEN -- SKILL_ID DOES NOT EXIST
                DBMS_OUTPUT.PUT_LINE('Skill number ' || P_SKID || ' does not exist, please add it first!');
            ELSIF V_EXC = 3 THEN -- COMBINATION DOES NOT EXIST: INSERT IT
                DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' and skill number ' || P_SKID || ' need to be added!');
                INSERT INTO CONSULTANT_SKILL(C_ID, SKILL_ID, CERTIFICATION)
                VALUES(P_CID, P_SKID, P_CERTST);
                DBMS_OUTPUT.PUT_LINE('Consultant number ' || P_CID || ' and skill number ' || P_SKID || ' inserted!');
                DISPLAY_DATA(P_CID, P_SKID, P_CERTST);
                COMMIT;
            END IF;
    END create_new_consultant_skill;
END;
/

EXEC c_sk_package.create_new_consultant_skill(100, 4, 'Y');

EXEC c_sk_package.create_new_consultant_skill(102, 7, 'S');

EXEC c_sk_package.create_new_consultant_skill(103, 9, 'Y');

EXEC c_sk_package.create_new_consultant_skill(100, 7, 'Y');

SPOOL OFF;