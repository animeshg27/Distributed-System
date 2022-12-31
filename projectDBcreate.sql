CREATE TABLE Fall22_S001_3_PRODUCT_TYPES (
    PRODUCT_TYPE_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    PRODUCT_TYPE VARCHAR2(20) NOT NULL,
    PRIMARY KEY(PRODUCT_TYPE_ID)
);

CREATE TABLE Fall22_S001_3_PRODUCTS (
    PRODUCT_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    PRODUCT_NAME VARCHAR2(50) NOT NULL,
    PRODUCT_TYPE_ID NUMBER(10) NOT NULL,
    INVENTORY NUMBER(10) DEFAULT 100,
    PRODUCT_PRICE NUMBER(38, 3) NOT NULL,
    PRIMARY KEY(PRODUCT_ID),
    FOREIGN KEY (PRODUCT_TYPE_ID)
        REFERENCES Fall22_S001_3_PRODUCT_TYPES(PRODUCT_TYPE_ID)
);

CREATE TABLE Fall22_S001_3_SALES_PERSON (
    SALES_PERSON_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    FIRST_NAME VARCHAR2(20) NOT NULL,
    LAST_NAME VARCHAR2(20),
    PRIMARY KEY(SALES_PERSON_ID)
);

CREATE TABLE Fall22_S001_3_SALES_PERSON_CONTACT (
    SALES_PERSON_ID NUMBER(10) NOT NULL,
    CONTACT_NUMBER NUMBER(10),
    UNIQUE (SALES_PERSON_ID, CONTACT_NUMBER),
    FOREIGN KEY (SALES_PERSON_ID)
        REFERENCES Fall22_S001_3_SALES_PERSON(SALES_PERSON_ID)
);

CREATE TABLE Fall22_S001_3_ROUTES (
    ROUTE_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    ROUTE_DESC VARCHAR2(20) NOT NULL,
    SALES_PERSON_ID NUMBER(10) NOT NULL,
    PRIMARY KEY(ROUTE_ID),
    FOREIGN KEY (SALES_PERSON_ID)
        REFERENCES Fall22_S001_3_SALES_PERSON(SALES_PERSON_ID)
);

CREATE TABLE Fall22_S001_3_REGIONS (
    REGION_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    REGION_NAME VARCHAR2(20) NOT NULL,
    REGION_DESC VARCHAR2(100) NOT NULL,
    ROUTE_ID NUMBER(10) NOT NULL,
    PRIMARY KEY(REGION_ID),
    FOREIGN KEY (ROUTE_ID)
        REFERENCES Fall22_S001_3_ROUTES(ROUTE_ID)
);

CREATE TABLE Fall22_S001_3_RETAILERS (
    RETAILER_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    RETAILER_NAME VARCHAR2(50) NOT NULL,
    REGION_ID NUMBER(10) NOT NULL,
    PRIMARY KEY(RETAILER_ID),
    FOREIGN KEY (REGION_ID)
        REFERENCES Fall22_S001_3_REGIONS(REGION_ID)
);

CREATE TABLE Fall22_S001_3_ORDERS (
    ORDER_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    ORDER_DATE DATE DEFAULT SYSDATE,
    ORDER_DESC VARCHAR2(100) NOT NULL,
    AMOUNT NUMBER(38, 3) NOT NULL,
    RETAILER_ID NUMBER(10) NOT NULL,
    PRIMARY KEY(ORDER_ID),
    FOREIGN KEY (RETAILER_ID)
        REFERENCES Fall22_S001_3_RETAILERS(RETAILER_ID)
);

CREATE TABLE Fall22_S001_3_CREDIT_NOTES (
    CREDIT_NOTE_ID NUMBER(10) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    CREDIT_NOTE_DATE DATE DEFAULT SYSDATE,
    CREDIT_NOTE_DESC VARCHAR2(100) NOT NULL,
    AMOUNT NUMBER(38, 3) NOT NULL,
    REMAINING_AMOUNT NUMBER(38, 3) NOT NULL,
    ORDER_ID NUMBER(10) NOT NULL,
    PRIMARY KEY(CREDIT_NOTE_ID),
    FOREIGN KEY (ORDER_ID)
        REFERENCES Fall22_S001_3_ORDERS(ORDER_ID)
);

CREATE TABLE Fall22_S001_3_CONTAINS_CN (
    CREDIT_NOTE_ID NUMBER(10) NOT NULL,
    PRODUCT_ID NUMBER(10) NOT NULL,
    PRODUCT_QUANTITY NUMBER(10) NOT NULL,
    FOREIGN KEY (CREDIT_NOTE_ID)
        REFERENCES Fall22_S001_3_CREDIT_NOTES(CREDIT_NOTE_ID),
    FOREIGN KEY (PRODUCT_ID)
        REFERENCES Fall22_S001_3_PRODUCTS(PRODUCT_ID)
);

CREATE TABLE Fall22_S001_3_CONTAINS_ORDERS (
    ORDER_ID NUMBER(10) NOT NULL,
    PRODUCT_ID NUMBER(10) NOT NULL,
    PRODUCT_QUANTITY NUMBER(10) NOT NULL,
    FOREIGN KEY (ORDER_ID)
        REFERENCES Fall22_S001_3_ORDERS(ORDER_ID),
    FOREIGN KEY (PRODUCT_ID)
        REFERENCES Fall22_S001_3_PRODUCTS(PRODUCT_ID)
);