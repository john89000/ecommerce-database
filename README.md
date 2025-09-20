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
