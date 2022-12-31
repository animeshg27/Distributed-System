------------------------------------------------- UPDATE PRICES OF ALL PRODUCTS ----------------------------------------------------
--SELECT * FROM (SELECT PRODUCT_ID, PRODUCT_PRICE, PRODUCT_PRICE + (PRODUCT_PRICE * 500 * POWER(2, -PRODUCT_PRICE)) as new FROM FALL22_S001_3_PRODUCTS order by PRODUCT_PRICE desc fetch next 5 rows only) UNION SELECT * FROM (SELECT PRODUCT_ID, PRODUCT_PRICE, PRODUCT_PRICE + (PRODUCT_PRICE * 500 * POWER(2, -PRODUCT_PRICE)) as new FROM FALL22_S001_3_PRODUCTS order by PRODUCT_PRICE fetch next 5 rows only);
UPDATE FALL22_S001_3_PRODUCTS SET PRODUCT_PRICE = PRODUCT_PRICE + (PRODUCT_PRICE * 500 * POWER(2, -PRODUCT_PRICE));

UPDATE (
        SELECT
            O.ORDER_ID, O.AMOUNT, TEMP.TOTAL_PRICE
        FROM Fall22_S001_3_ORDERS O INNER JOIN (
            SELECT
                CO.ORDER_ID, SUM(CO.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
            FROM
                Fall22_S001_3_CONTAINS_ORDERS CO INNER JOIN FALL22_S001_3_PRODUCTS P ON CO.PRODUCT_ID = P.PRODUCT_ID
            GROUP BY
                CO.ORDER_ID
            ORDER BY
                CO.ORDER_ID
        ) TEMP ON O.ORDER_ID = TEMP.ORDER_ID
    ) SET AMOUNT = TOTAL_PRICE;

-- SELECT
--     O.ORDER_ID, O.AMOUNT, TEMP.TOTAL_PRICE
-- FROM
--     Fall22_S001_3_ORDERS O INNER JOIN (
--             SELECT
--                 CN.ORDER_ID, SUM(CN.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
--             FROM
--                 Fall22_S001_3_CONTAINS_ORDERS CN INNER JOIN FALL22_S001_3_PRODUCTS P ON CN.PRODUCT_ID = P.PRODUCT_ID
--             GROUP BY
--                 CN.ORDER_ID
--             ORDER BY
--                 CN.ORDER_ID
--         ) TEMP ON O.ORDER_ID = TEMP.ORDER_ID
-- WHERE
--     O.AMOUNT != TEMP.TOTAL_PRICE;

UPDATE (
        SELECT
            C.CREDIT_NOTE_ID, C.AMOUNT, C.REMAINING_AMOUNT, TEMP.TOTAL_PRICE
        FROM Fall22_S001_3_CREDIT_NOTES C INNER JOIN (
            SELECT
                CN.CREDIT_NOTE_ID, SUM(CN.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
            FROM
                Fall22_S001_3_CONTAINS_CN CN INNER JOIN FALL22_S001_3_PRODUCTS P ON CN.PRODUCT_ID = P.PRODUCT_ID
            GROUP BY
                CN.CREDIT_NOTE_ID
            ORDER BY
                CN.CREDIT_NOTE_ID
        ) TEMP ON C.CREDIT_NOTE_ID = TEMP.CREDIT_NOTE_ID
    ) SET AMOUNT = TOTAL_PRICE, REMAINING_AMOUNT = TOTAL_PRICE;

-- SELECT
--     O.CREDIT_NOTE_ID, O.AMOUNT, O.REMAINING_AMOUNT, TEMP.TOTAL_PRICE
-- FROM
--     Fall22_S001_3_CREDIT_NOTES O INNER JOIN (
--             SELECT
--                 CN.CREDIT_NOTE_ID, SUM(CN.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
--             FROM
--                 Fall22_S001_3_CONTAINS_CN CN INNER JOIN FALL22_S001_3_PRODUCTS P ON CN.PRODUCT_ID = P.PRODUCT_ID
--             GROUP BY
--                 CN.CREDIT_NOTE_ID
--             ORDER BY
--                 CN.CREDIT_NOTE_ID
--         ) TEMP ON O.CREDIT_NOTE_ID = TEMP.CREDIT_NOTE_ID
-- WHERE
--     O.AMOUNT != TEMP.TOTAL_PRICE OR O.REMAINING_AMOUNT != TEMP.TOTAL_PRICE;

------------------------------------------------- UPDATE PRICES OF ALL PRODUCTS ----------------------------------------------------

------------------------------------- DELETE TOP 5 MOST EXPENSIVE AND LEAST EXPENSIVE PRODUCTS -------------------------------------

DELETE FROM Fall22_S001_3_CONTAINS_ORDERS WHERE PRODUCT_ID IN (
    SELECT PRODUCT_ID FROM (SELECT P2.PRODUCT_ID FROM FALL22_S001_3_PRODUCTS P2 ORDER BY P2.PRODUCT_PRICE DESC FETCH NEXT 5 ROWS ONLY)
    UNION SELECT PRODUCT_ID FROM (SELECT P3.PRODUCT_ID FROM FALL22_S001_3_PRODUCTS P3 ORDER BY P3.PRODUCT_PRICE FETCH NEXT 5 ROWS ONLY)
);

DELETE FROM Fall22_S001_3_CONTAINS_CN WHERE PRODUCT_ID IN (
    SELECT PRODUCT_ID FROM (SELECT P2.PRODUCT_ID FROM FALL22_S001_3_PRODUCTS P2 ORDER BY P2.PRODUCT_PRICE DESC FETCH NEXT 5 ROWS ONLY)
    UNION SELECT PRODUCT_ID FROM (SELECT P3.PRODUCT_ID FROM FALL22_S001_3_PRODUCTS P3 ORDER BY P3.PRODUCT_PRICE FETCH NEXT 5 ROWS ONLY)
);

DELETE FROM FALL22_S001_3_PRODUCTS P1 WHERE P1.PRODUCT_ID IN (
    SELECT PRODUCT_ID FROM (SELECT P2.PRODUCT_ID FROM FALL22_S001_3_PRODUCTS P2 ORDER BY P2.PRODUCT_PRICE DESC FETCH NEXT 5 ROWS ONLY)
    UNION SELECT PRODUCT_ID FROM (SELECT P3.PRODUCT_ID FROM FALL22_S001_3_PRODUCTS P3 ORDER BY P3.PRODUCT_PRICE FETCH NEXT 5 ROWS ONLY)
);

DELETE FROM Fall22_S001_3_CREDIT_NOTES WHERE CREDIT_NOTE_ID NOT IN (
    SELECT DISTINCT(CREDIT_NOTE_ID) FROM Fall22_S001_3_CONTAINS_CN
);

DELETE FROM Fall22_S001_3_ORDERS WHERE ORDER_ID NOT IN (
    SELECT DISTINCT(ORDER_ID) FROM Fall22_S001_3_CONTAINS_ORDERS
);

UPDATE (
        SELECT
            O.ORDER_ID, O.AMOUNT, TEMP.TOTAL_PRICE
        FROM Fall22_S001_3_ORDERS O INNER JOIN (
            SELECT
                CO.ORDER_ID, SUM(CO.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
            FROM
                Fall22_S001_3_CONTAINS_ORDERS CO INNER JOIN FALL22_S001_3_PRODUCTS P ON CO.PRODUCT_ID = P.PRODUCT_ID
            GROUP BY
                CO.ORDER_ID
            ORDER BY
                CO.ORDER_ID
        ) TEMP ON O.ORDER_ID = TEMP.ORDER_ID
    ) SET AMOUNT = TOTAL_PRICE;

UPDATE (
        SELECT
            C.CREDIT_NOTE_ID, C.AMOUNT, C.REMAINING_AMOUNT, TEMP.TOTAL_PRICE
        FROM Fall22_S001_3_CREDIT_NOTES C INNER JOIN (
            SELECT
                CN.CREDIT_NOTE_ID, SUM(CN.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
            FROM
                Fall22_S001_3_CONTAINS_CN CN INNER JOIN FALL22_S001_3_PRODUCTS P ON CN.PRODUCT_ID = P.PRODUCT_ID
            GROUP BY
                CN.CREDIT_NOTE_ID
            ORDER BY
                CN.CREDIT_NOTE_ID
        ) TEMP ON C.CREDIT_NOTE_ID = TEMP.CREDIT_NOTE_ID
    ) SET AMOUNT = TOTAL_PRICE, REMAINING_AMOUNT = TOTAL_PRICE;

------------------------------------- DELETE TOP 5 MOST EXPENSIVE AND LEAST EXPENSIVE PRODUCTS -------------------------------------

------------------------------------- INSERT 10 NEW PRODUCTS AND RELATED DATA IN RELATED TABLES ------------------------------------

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Old spice deodarant', 3, 120, 3);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to red route', 300, 23);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 150 and the remaining orders are 50',150, 150,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),50);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Axe black body spray', 3,200, 4.89);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to blue route', 489, 14);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 146.7 and the remaining orders are 70',146.7, 146.7,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),30);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Barilla spagetti pasta', 1, 150, 3.18);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to blue route', 318, 16);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 111.3 and the remaining orders are 65',111.3, 111.3,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),35);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Maggie Instant pasta', 1,170, 2.97);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to red route', 297, 28);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 148.5 and the remaining orders are 50',148.5, 148.5,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),50);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Nissin cup noodles', 1,200, 1.29);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to orange route', 129, 34);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 77.4 and the remaining orders are 40',77.4, 77.4,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),60);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Dettol disinfectant', 2,100, 69.99);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to blue route', 699.9, 12);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),10);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 279.96 and the remaining orders are 6',279.96, 279.96,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),4);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Pedialite electrolyte solution', 3,150, 4.98);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to black route', 498, 7);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 149.4 and the remaining orders are 70',149.4, 149.4,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),30);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Ensure original nutirition shake', 3,120, 10.99);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to blue route', 109.9, 17);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),10);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 21.98 and the remaining orders are 8',21.98, 21.98,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),2);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Easywring spin mop and bucket', 3, 200, 34.98);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to blue route', 3498, 20);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),100);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 1399.2 and the remaining orders are 60',1399.2, 1399.2,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),40);

INSERT INTO FALL22_S001_3_PRODUCTS VALUES ((SELECT MAX(PRODUCT_ID) + 1 FROM FALL22_S001_3_PRODUCTS), 'Rubber maid waste container', 3,150, 18);
INSERT INTO Fall22_S001_3_ORDERS VALUES ((SELECT MAX(ORDER_ID) + 1 FROM Fall22_S001_3_ORDERS), NULL, 'Order is been tagged to blue route', 180, 15);
INSERT INTO Fall22_S001_3_CONTAINS_ORDERS VALUES ((SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),10);
INSERT INTO Fall22_S001_3_CREDIT_NOTES VALUES (NULL, '20-NOV-2022' ,'Amount deducted is 90 and the remaining orders are 5',90, 90,(SELECT MAX(ORDER_ID) FROM Fall22_S001_3_ORDERS)); 
INSERT INTO Fall22_S001_3_CONTAINS_CN VALUES ((SELECT MAX(CREDIT_NOTE_ID) FROM Fall22_S001_3_CREDIT_NOTES),(SELECT MAX(PRODUCT_ID) FROM FALL22_S001_3_PRODUCTS),10);

UPDATE (
        SELECT
            O.ORDER_ID, O.AMOUNT, TEMP.TOTAL_PRICE
        FROM Fall22_S001_3_ORDERS O INNER JOIN (
            SELECT
                CO.ORDER_ID, SUM(CO.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
            FROM
                Fall22_S001_3_CONTAINS_ORDERS CO INNER JOIN FALL22_S001_3_PRODUCTS P ON CO.PRODUCT_ID = P.PRODUCT_ID
            GROUP BY
                CO.ORDER_ID
            ORDER BY
                CO.ORDER_ID
        ) TEMP ON O.ORDER_ID = TEMP.ORDER_ID
    ) SET AMOUNT = TOTAL_PRICE;

UPDATE (
        SELECT
            C.CREDIT_NOTE_ID, C.AMOUNT, C.REMAINING_AMOUNT, TEMP.TOTAL_PRICE
        FROM Fall22_S001_3_CREDIT_NOTES C INNER JOIN (
            SELECT
                CN.CREDIT_NOTE_ID, SUM(CN.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_PRICE
            FROM
                Fall22_S001_3_CONTAINS_CN CN INNER JOIN FALL22_S001_3_PRODUCTS P ON CN.PRODUCT_ID = P.PRODUCT_ID
            GROUP BY
                CN.CREDIT_NOTE_ID
            ORDER BY
                CN.CREDIT_NOTE_ID
        ) TEMP ON C.CREDIT_NOTE_ID = TEMP.CREDIT_NOTE_ID
    ) SET AMOUNT = TOTAL_PRICE, REMAINING_AMOUNT = TOTAL_PRICE;

------------------------------------- INSERT 10 NEW PRODUCTS AND RELATED DATA IN RELATED TABLES ------------------------------------