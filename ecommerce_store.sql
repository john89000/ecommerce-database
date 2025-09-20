CREATE DATABASE ecommerce_db;

USE ecommerce_db;

CREATE TABLE customers (
customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(255) NOT NULL UNIQUE,
phone VARCHAR(20),
password_hash VARCHAR(255) NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

INSERT INTO customers (first_name, last_name, email, phone, password_hash)
VALUES
('Alice', 'Mwangi', 'alice@example.com', '0712345678', 'hashed_pw1'),
('Brian', 'Kamau', 'brian@example.com', '0722334455', 'hashed_pw2'),
('Clara', 'Otieno', 'clara@example.com', '0733445566', 'hashed_pw3');

CREATE TABLE addresses (
address_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
customer_id INT UNSIGNED NOT NULL,
label VARCHAR(50), -- e.g. 'Home', 'Office'
street VARCHAR(255) NOT NULL,
city VARCHAR(100) NOT NULL,
state VARCHAR(100),
postal_code VARCHAR(20),
country VARCHAR(100) NOT NULL,
is_default BOOLEAN NOT NULL DEFAULT FALSE,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (address_id),
CONSTRAINT fk_addresses_customer FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO addresses (customer_id, label, street, city, state, postal_code, country, is_default)
VALUES
(1, 'Home', '123 Kenyatta Ave', 'Nairobi', 'Nairobi', '00100', 'Kenya', TRUE),
(2, 'Office', '456 Moi Avenue', 'Mombasa', 'Mombasa', '80100', 'Kenya', TRUE),
(3, 'Home', '789 Uhuru Rd', 'Kisumu', 'Kisumu', '40100', 'Kenya', TRUE);

CREATE TABLE suppliers (
supplier_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
contact_email VARCHAR(255),
phone VARCHAR(50),
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (supplier_id)
) ENGINE=InnoDB;

INSERT INTO suppliers (name, contact_email, phone)
VALUES
('TechWorld Ltd', 'contact@techworld.com', '+254700123456'),
('FashionHub', 'support@fashionhub.com', '+254711223344');

CREATE TABLE categories (
category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
name VARCHAR(100) NOT NULL UNIQUE,
description TEXT,
parent_id INT UNSIGNED DEFAULT NULL,
PRIMARY KEY (category_id),
CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id)
REFERENCES categories(category_id)
ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO categories (name, description)
VALUES
('Electronics', 'Devices and gadgets'),
('Clothing', 'Men and Women apparel'),
('Accessories', 'Fashion and tech accessories');

CREATE TABLE products (
product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
sku VARCHAR(64) NOT NULL UNIQUE,
name VARCHAR(255) NOT NULL,
description TEXT,
price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
active BOOLEAN NOT NULL DEFAULT TRUE,
supplier_id INT UNSIGNED,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (product_id),
CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id)
ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO products (sku, name, description, price, supplier_id)
VALUES
('ELEC-001', 'Smartphone X', 'Latest 5G smartphone', 55000.00, 1),
('ELEC-002', 'Laptop Pro 15"', 'High performance laptop', 120000.00, 1),
('CLOT-001', 'Men T-Shirt', 'Cotton T-shirt', 1200.00, 2),
('CLOT-002', 'Women Dress', 'Floral dress', 3000.00, 2),
('ACC-001', 'Wireless Earbuds', 'Bluetooth earbuds with charging case', 7500.00, 1);


CREATE TABLE product_categories (
product_id INT UNSIGNED NOT NULL,
category_id INT UNSIGNED NOT NULL,
PRIMARY KEY (product_id, category_id),
CONSTRAINT fk_pc_product FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_pc_category FOREIGN KEY (category_id)
REFERENCES categories(category_id)
ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO product_categories (product_id, category_id)
VALUES
(1, 1), (2, 1),
(3, 2), (4, 2),
(5, 1), (5, 3);

CREATE TABLE product_images (
image_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
product_id INT UNSIGNED NOT NULL,
url VARCHAR(1024) NOT NULL,
alt_text VARCHAR(255),
position INT UNSIGNED DEFAULT 0,
PRIMARY KEY (image_id),
CONSTRAINT fk_images_product FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE inventory (
product_id INT UNSIGNED NOT NULL,
quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
reorder_level INT NOT NULL DEFAULT 0,
last_restocked DATETIME,
PRIMARY KEY (product_id),
CONSTRAINT fk_inventory_product FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO inventory (product_id, quantity, reorder_level, last_restocked)
VALUES
(1, 50, 10, NOW()),
(2, 20, 5, NOW()),
(3, 100, 20, NOW()),
(4, 40, 10, NOW()),
(5, 60, 15, NOW());


CREATE TABLE orders (
order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
customer_id INT UNSIGNED NOT NULL,
billing_address_id INT UNSIGNED,
shipping_address_id INT UNSIGNED,
order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
status ENUM('pending','processing','shipped','delivered','cancelled','refunded') NOT NULL DEFAULT 'pending',
subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
shipping DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (shipping >= 0),
tax DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (tax >= 0),
total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
PRIMARY KEY (order_id),
CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_orders_billing_address FOREIGN KEY (billing_address_id)
REFERENCES addresses(address_id)
ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT fk_orders_shipping_address FOREIGN KEY (shipping_address_id)
REFERENCES addresses(address_id)
ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO orders (customer_id, billing_address_id, shipping_address_id, subtotal, shipping, tax, total, status)
VALUES
(1, 1, 1, 55000.00, 500.00, 0.00, 55500.00, 'processing'),
(2, 2, 2, 13200.00, 500.00, 0.00, 13700.00, 'shipped');

CREATE TABLE order_items (
order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
order_id BIGINT UNSIGNED NOT NULL,
product_id INT UNSIGNED NOT NULL,
sku_at_order VARCHAR(64) NOT NULL,
product_name_at_order VARCHAR(255) NOT NULL,
unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price >= 0),
quantity INT NOT NULL CHECK (quantity > 0),
line_total DECIMAL(14,2) AS (unit_price * quantity) VIRTUAL,
PRIMARY KEY (order_item_id),
CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO order_items (order_id, product_id, sku_at_order, product_name_at_order, unit_price, quantity)
VALUES
(1, 1, 'ELEC-001', 'Smartphone X', 55000.00, 1),
(2, 3, 'CLOT-001', 'Men T-Shirt', 1200.00, 10);

CREATE TABLE payments (
payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
order_id BIGINT UNSIGNED NOT NULL,
amount DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
currency CHAR(3) NOT NULL DEFAULT 'USD',
payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
method ENUM('card','paypal','bank_transfer','wallet','mpesa') NOT NULL,
transaction_reference VARCHAR(255),
status ENUM('pending','completed','failed','refunded') NOT NULL DEFAULT 'pending',
PRIMARY KEY (payment_id),
CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO payments (order_id, amount, currency, method, transaction_reference, status)
VALUES
(1, 55500.00, 'KES', 'card', 'TXN123456', 'completed'),
(2, 13700.00, 'KES', 'mpesa', 'MPESA987654', 'completed');

CREATE TABLE cart_items (
cart_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
customer_id INT UNSIGNED NOT NULL,
product_id INT UNSIGNED NOT NULL,
quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (cart_item_id),
UNIQUE KEY uq_cart_customer_product (customer_id, product_id),
CONSTRAINT fk_cart_customer FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_cart_product FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO cart_items (customer_id, product_id, quantity)
VALUES
(3, 5, 2);

CREATE TABLE reviews (
  review_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id INT UNSIGNED NOT NULL,
  customer_id INT UNSIGNED, 
  rating TINYINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(255),
  body TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (review_id),
  CONSTRAINT fk_reviews_product FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO reviews (product_id, customer_id, rating, title, body)
VALUES
(1, 1, 5, 'Amazing phone!', 'Battery lasts long and performance is excellent.'),
(3, 2, 4, 'Good quality T-shirt', 'Comfortable and worth the price.');

CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_inventory_quantity ON inventory(quantity);

CREATE ALGORITHM=UNDEFINED VIEW vw_order_summary AS
SELECT o.order_id, o.order_date, o.customer_id, o.status, o.total,
c.first_name, c.last_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id;