CREATE SCHEMA dwh_detailed;

-- Anchors
CREATE TABLE dwh_detailed.anc_manufacturer (
    id BIGINT PRIMARY KEY
);

CREATE TABLE dwh_detailed.anc_category (
    id BIGINT PRIMARY KEY
);

CREATE TABLE dwh_detailed.anc_product (
    id BIGINT PRIMARY KEY
);

CREATE TABLE dwh_detailed.anc_store (
    id BIGINT PRIMARY KEY
);

CREATE TABLE dwh_detailed.anc_delivery (
    id BIGINT PRIMARY KEY
);

CREATE TABLE dwh_detailed.anc_customer (
    id BIGINT PRIMARY KEY
);

CREATE TABLE dwh_detailed.anc_purchase (
    id BIGINT PRIMARY KEY
);

-- Attributes (with versioning)
CREATE TABLE dwh_detailed.att_manufacturer (
    id BIGINT REFERENCES dwh_detailed.anc_manufacturer,
    name VARCHAR(100) NOT NULL,
    legal_entity VARCHAR(100) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

CREATE TABLE dwh_detailed.att_category (
    id BIGINT REFERENCES dwh_detailed.anc_category,
    name VARCHAR(100) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

-- Attributes for Products
CREATE TABLE dwh_detailed.att_product (
    id BIGINT REFERENCES dwh_detailed.anc_product,
    name VARCHAR(255) NOT NULL,
    picture_url VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    age_restriction INT CHECK (age_restriction >= 0),
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

-- Attributes for Stores
CREATE TABLE dwh_detailed.att_store (
    id BIGINT REFERENCES dwh_detailed.anc_store,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

-- Attributes for Deliveries
CREATE TABLE dwh_detailed.att_delivery (
    id BIGINT REFERENCES dwh_detailed.anc_delivery,
    date DATE NOT NULL,
    product_count INTEGER CHECK (product_count >= 0),
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

-- Attributes for Customers
CREATE TABLE dwh_detailed.att_customer (
    id BIGINT REFERENCES dwh_detailed.anc_customer,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR(100) NOT NULL,
    gender VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

-- Attributes for Purchases
CREATE TABLE dwh_detailed.att_purchase (
    id BIGINT REFERENCES dwh_detailed.anc_purchase,
    date TIMESTAMP NOT NULL,
    payment_type VARCHAR(100) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (id, valid_from)
);

-- Attributes for Price Changes
CREATE TABLE dwh_detailed.att_price_change (
    product_id BIGINT REFERENCES dwh_detailed.anc_product,
    change_ts TIMESTAMP NOT NULL,
    new_price NUMERIC(9,2) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (product_id, valid_from)
);

-- Ties (to represent relationships, also with versioning)
CREATE TABLE dwh_detailed.tie_product_manufacturer (
    product_id BIGINT REFERENCES dwh_detailed.anc_product,
    manufacturer_id BIGINT REFERENCES dwh_detailed.anc_manufacturer,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (product_id, manufacturer_id, valid_from)
);

CREATE TABLE dwh_detailed.tie_product_category (
    product_id BIGINT REFERENCES dwh_detailed.anc_product,
    category_id BIGINT REFERENCES dwh_detailed.anc_category,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (product_id, category_id, valid_from)
);

CREATE TABLE dwh_detailed.tie_delivery_product (
    delivery_id BIGINT REFERENCES dwh_detailed.anc_delivery,
    product_id BIGINT REFERENCES dwh_detailed.anc_product,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (delivery_id, product_id, valid_from)
);

CREATE TABLE dwh_detailed.tie_delivery_store (
    delivery_id BIGINT REFERENCES dwh_detailed.anc_delivery,
    store_id BIGINT REFERENCES dwh_detailed.anc_store,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (store_id, delivery_id, valid_from)
);

CREATE TABLE dwh_detailed.tie_purchase_store (
    purchase_id BIGINT REFERENCES dwh_detailed.anc_purchase,
    store_id BIGINT REFERENCES dwh_detailed.anc_store,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (store_id, purchase_id, valid_from)
);

CREATE TABLE dwh_detailed.tie_purchase_customer (
    purchase_id BIGINT REFERENCES dwh_detailed.anc_purchase,
    customer_id BIGINT REFERENCES dwh_detailed.anc_customer,
    valid_from TIMESTAMP NOT NULL,
    PRIMARY KEY (customer_id, purchase_id, valid_from)
);
