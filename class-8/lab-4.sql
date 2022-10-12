SPOOL './lab-4.txt'
SELECT to_char(SYSDATE, 'DD Month Year Day HH:MI:SS Am')
FROM dual;
-- Question 1.
-- Create a procedure that accepts 3 parameters, the first two are of mode IN
-- with number as their datatype and the third one is of mode OUT in form of
-- Varchar2. The procedure will compare the first two numbers and output the 
-- result as EQUAL, or DIFFERENT. Create a second procedure called L4Q1 that
-- accepts the two sides of a rectangle. The procedure will calculate the area
-- and the perimeter of the rectangle. Use the procedure created previously to 
-- display if the shape is a square or a rectangle

CREATE OR REPLACE PROCEDURE COMPARE_NUMS(
    P_NUM1 IN NUMBER,
    P_NUM2 IN NUMBER,
    P_RESULT OUT VARCHAR2
) AS
BEGIN
    IF P_NUM1 = P_NUM2 THEN
        P_RESULT := 'EQUAL';
    ELSE
        P_RESULT := 'DIFFERENT';
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE L4Q1(
    P_SIDE1 IN NUMBER,
    P_SIDE2 IN NUMBER
) AS
    V_RESULT VARCHAR2(10);
    V_AREA NUMBER;
    V_PERIMETER NUMBER;    
    V_SHAPE VARCHAR(10);
BEGIN
    v_area := p_side1 * p_side2;
    v_perimeter := (p_side1 + p_side2)*2;
    COMPARE_NUMS(p_side1, p_side2, v_result);
    IF V_RESULT = 'EQUAL' THEN
        v_shape := 'square';
    ELSE
        v_shape := 'rectangle';
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        'The area of a ' || v_shape || ' size ' || p_side1 || 
        ' by ' || p_side2 || ' is ' || v_area || '. Its perimeter is ' ||
        v_perimeter || '.'
    );
END;
/

--The area of a square size 2 by 2 is 4. It`s perimeter is 8.
EXEC L4Q1(2,2)
-- The area of a rectangle size 2 by 3 is 6. It`s perimeter is 10.
EXEC L4Q1(2,3)

-- Question 2.
-- Create a pseudo function called pseudo_fun that accepts 2 parameters 
-- represented the height and width of a rectangle. The pseudo function should 
-- return the area and the perimeter of the rectangle.
-- Create a second procedure called L4Q2 that accepts the two sides of a 
-- rectangle. The procedure will use the pseudo function to display the 
-- shape, the area and the perimeter.

CREATE OR REPLACE PROCEDURE pseudo_fun(
    P_SIDE1_AREA IN OUT NUMBER,
    P_SIDE2_PERIMETER IN OUT NUMBER
) AS
    V_SIDE1 NUMBER := P_SIDE1_AREA;
    V_SIDE2 NUMBER := P_SIDE2_PERIMETER;
BEGIN
    P_SIDE1_AREA := V_SIDE1 * V_SIDE2;
    P_SIDE2_PERIMETER := (V_SIDE1 + V_SIDE2)*2;
END;
/

CREATE OR REPLACE PROCEDURE L4Q2(
    P_SIDE1 IN NUMBER,
    P_SIDE2 IN NUMBER
) AS
    V_SIDE1_AREA NUMBER := P_SIDE1;
    V_SIDE2_PERIMETER NUMBER := P_SIDE2;
    V_SHAPE VARCHAR2(10);
BEGIN
    pseudo_fun(V_SIDE1_AREA, V_SIDE2_PERIMETER);
    IF P_SIDE1 = P_SIDE2 THEN
        v_shape := 'square';
    ELSE
        v_shape := 'rectangle';
    END IF;
    DBMS_OUTPUT.PUT_LINE(
            'The area of a ' || v_shape || ' size ' || p_side1 || 
            ' by ' || p_side2 || ' is ' || V_SIDE1_AREA || '. Its perimeter is ' ||
            V_SIDE2_PERIMETER || '.'
    );
END;
/

--The area of a square size 2 by 2 is 4. It`s perimeter is 8.
EXEC L4Q2(2,2)
-- The area of a rectangle size 2 by 3 is 6. It`s perimeter is 10.
EXEC L4Q2(2,3)

-- Question 3.
-- Create a pseudo function that accepts 2 parameters represented the inv_id, 
-- and the percentage increase in price. The pseudo function should first 
-- update the database with the new price then return the new price and the
-- quantity on hand.
-- Create a second procedure called L4Q3 that accepts the inv_id and the 
-- percentage increase in price. The procedure will use the pseudo function
-- to display the new value of the inventory (hint: value = price X quantity
-- on hand)

select * from inventory

CREATE OR REPLACE PROCEDURE update_price(
    p_invid_price IN OUT NUMBER,
    p_inc_qoh IN OUT NUMBER
) AS
    v_invid INVENTORY.inv_id%TYPE := p_invid_price;
    v_price INVENTORY.INV_PRICE%type;
    v_new_price number;
    v_qoh INVENTORY.INV_QOH%TYPE;
BEGIN
    SELECT INV_PRICE, INV_QOH
    INTO v_price, v_qoh
    from INVENTORY
    WHERE inv_id = v_invid;

    v_new_price := v_price*(1+p_inc_qoh/100);
    UPDATE INVENTORY SET INV_PRICE = v_new_price WHERE inv_id = v_invid;
    p_invid_price := v_new_price;
    p_inc_qoh := v_qoh; 
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Inventory id ' || v_invid ||' does not exist!');  
END;
/

CREATE OR REPLACE PROCEDURE L4Q3(
    p_invid IN INVENTORY.INV_ID%TYPE,
    p_incr IN NUMBER
) AS
  v_invid_price NUMBER:= p_invid;
  v_incr_qoh NUMBER := p_incr;
  v_value number;
BEGIN
    update_price(v_invid_price, v_incr_qoh);
    v_value := v_invid_price * v_incr_qoh;
    DBMS_OUTPUT.PUT_LINE('The price for item' || p_invid || ' has been updated. New value of the inventory is: ' || v_value );
END;
/

exec L4Q3(2, 20);

SPOOL OFF;