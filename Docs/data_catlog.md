# 📚 Data Dictionary for Gold Layer

## 📄 Overview
> The gold layer is the business level data representation structured to support analytical and reporting use cases. It consists of dimension and fact tables.

---

## 🗂️ gold.dim_customers

**Purpose:** Supports customer details enriched with demographic and geographic data.

| Column Name     | Data Type      | Description                                                                 |
|-----------------|----------------|-----------------------------------------------------------------------------|
| customer_key    | INT            | Surrogate key uniquely identifying each customer record in dimension table |
| customer_id     | INT            | Unique numerical identifier assigned to each customer                      |
| customer_number | NVARCHAR(50)   | Alphanumeric identifier used for tracking and referencing                  |
| first_name      | NVARCHAR(50)   | Customer's first name                                                       |
| last_name       | NVARCHAR(50)   | Customer's last name                                                        |
| country         | NVARCHAR(50)   | Customer's country                                                          |
| maritial_status | NVARCHAR(50)   | Customer's marital status                                                   |
| gender          | NVARCHAR(50)   | Customer's gender                                                           |
| birthdate       | DATE           | Customer's birth date                                                       |
| create_date     | DATE           | Date the customer record was created                                        |

---

## 🗂️ gold.dim_products

**Purpose:** Provides information about product names and their attributes.

| Column Name     | Data Type      | Description                                          |
|-----------------|----------------|------------------------------------------------------|
| product_key     | INT            | Surrogate key uniquely identifying each product      |
| product_id      | INT            | Unique numerical identifier assigned to each product |
| product_number  | NVARCHAR(50)   | Alphanumeric identifier for product tracking         |
| product_name    | NVARCHAR(50)   | Descriptive name of the product                      |
| category_id     | NVARCHAR(50)   | Identifier for the product’s category                |
| category        | NVARCHAR(50)   | Name of the product category                         |
| subcategory     | NVARCHAR(50)   | Name of the product subcategory                      |
| cost            | INT            | Cost of the product                                  |
| product_line    | NVARCHAR(50)   | Product line to which the product belongs            |
| start_date      | DATE           | Date when the product was first available            |
| maintenance     | NVARCHAR(50)   | Indicates if product requires maintenance (Yes/No)   |

---

## 🗂️ gold.fact_sales

**Purpose:** Stores transactional sales data for analytical purposes.

| Column Name   | Data Type      | Description                                                      |
|---------------|----------------|------------------------------------------------------------------|
| order_number  | NVARCHAR(50)   | Unique order identifier                                          |
| product_key   | INT            | Surrogate key linking to product dimension table                 |
| customer_key  | INT            | Surrogate key linking to customer dimension table                |
| order_date    | DATE           | Date when the order was placed                                   |
| shipping_date | DATE           | Date when the order was shipped                                  |
| due_date      | DATE           | Date when the order is due                                       |
| sales_amount  | INT            | Total amount for the sales transaction                           |
| quantity      | INT            | Quantity of products sold                                        |
| price         | INT            | Price per unit                                                   |
