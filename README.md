# E-commerce Database (MySQL)

## 📌 Overview
This project contains a relational **E-commerce Database Management System** designed and implemented in **MySQL**.  
It models a typical online store, including customers, products, categories, orders, payments, inventory, and reviews.  

The database schema ensures **data integrity** through:
- Primary and Foreign Keys
- NOT NULL, UNIQUE, and CHECK constraints
- One-to-One, One-to-Many, and Many-to-Many relationships

---

## 📂 Files
- **ecommerce_store.sql** → Full schema with table creation and sample data inserts.

---

## 🏗️ Database Schema
Key entities include:
- **Customers** → Stores customer details
- **Addresses** → Billing & shipping addresses linked to customers
- **Suppliers** → Product suppliers
- **Categories** → Product categories
- **Products** → Store inventory items
- **Orders & Order Items** → Tracks purchases
- **Payments** → Payment transactions
- **Cart Items** → Shopping cart data
- **Reviews** → Customer reviews for products

---

## ⚙️ Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/john89000/ecommerce-database.git
   cd ecommerce-database

## Import the SQL file:
   ```bash
   mysql -u your_username -p ecommerce_db < ecommerce_store.sql

## Verify tables:

USE ecommerce_db;
SHOW TABLES;

## 📊 Sample Queries
List all customers and their orders:
SELECT c.first_name, c.last_name, o.order_id, o.total, o.status
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

## Find products that are low in stock:
SELECT p.name, i.quantity, i.reorder_level
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE i.quantity < i.reorder_level;

## Show reviews for a product:
SELECT p.name AS product, r.rating, r.title, r.body
FROM reviews r
JOIN products p ON r.product_id = p.product_id;

## ✅ Features

Full relational schema with constraints

Handles customer accounts, carts, and orders

Supports multiple suppliers and categories

Tracks payments and reviews

Includes sample data for testing
