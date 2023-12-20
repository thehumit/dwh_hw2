-- Manufacturers
CREATE TABLE manufacturers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    legal_entity VARCHAR(100) NOT NULL
);

-- Categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Products
CREATE TABLE products (
    id BIGINT PRIMARY KEY CHECK (id >= 0),
    name VARCHAR(255) NOT NULL,
    category_id BIGINT REFERENCES categories(id) CHECK (category_id >= 0),
    manufacturer_id BIGINT REFERENCES manufacturers(id) CHECK (manufacturer_id >= 0),
    picture_url VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    age_restriction INT CHECK (age_restriction >= 0)
);

-- Stores
CREATE TABLE stores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Deliveries
CREATE TABLE deliveries (
    id BIGINT PRIMARY KEY,
    store_id BIGINT REFERENCES stores(id) CHECK (store_id >= 0),
    product_id BIGINT REFERENCES products(id) CHECK (product_id >= 0),
    date DATE NOT NULL,
    count INTEGER CHECK (count >= 0)
);

-- Customers
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone VARCHAR(100) NOT NULL
);

-- Purchases
CREATE TABLE purchases (
    id SERIAL PRIMARY KEY,
    store_id BIGINT REFERENCES stores(id) CHECK (store_id >= 0),
    customer_id BIGINT REFERENCES customers(id) CHECK (customer_id >= 0),
    date DATE NOT NULL,
    payment_type VARCHAR(100) NOT NULL
);

-- Purchase Items
CREATE TABLE purchase_items (
    product_id BIGINT REFERENCES products(id) CHECK (product_id >= 0),
    purchase_id BIGINT REFERENCES purchases(id) CHECK (purchase_id >= 0),
    count BIGINT CHECK (count >= 0),
    price NUMERIC(9,2) CHECK (price >= 0)
);

-- Price Change
CREATE TABLE price_change (
    product_id BIGINT REFERENCES products(id) CHECK (product_id >= 0),
    ts TIMESTAMP NOT NULL,
    new_price NUMERIC(9,2) NOT NULL
);

-- Insert Statements (Unchanged)

-- Gross Merchandise Value View
CREATE VIEW gmv_view AS
SELECT
    p.store_id,
    pr.category_id,
    SUM(pi.price * pi.count) AS sales_sum
FROM
    purchases p
JOIN
    purchase_items pi ON p.id = pi.purchase_id
JOIN
    products pr ON pi.product_id = pr.id
GROUP BY
    p.store_id, pr.category_id
ORDER BY
    p.store_id, pr.category_id;
