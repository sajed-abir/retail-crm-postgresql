# 🛒 Retail CRM — PostgreSQL E-Commerce Database & Analytics Project
 
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-orange)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)
 
A complete, end-to-end **retail Customer Relationship Management (CRM) database** built on PostgreSQL. This project covers everything from schema design and data generation to advanced business analytics — simulating a real-world e-commerce operation at scale.

---

## 📌 Table of Contents
 
- [Project Overview](#-project-overview)
- [Key Features](#-key-features)
- [Project Scope](#-project-scope)
- [Folder Structure](#-folder-structure)
- [Database Schema](#-database-schema)
- [Analytics Modules](#-analytics-modules)
- [Getting Started](#-getting-started)
- [Prerequisites](#-prerequisites)
- [Usage](#-usage)
- [Sample Queries](#-sample-queries)
- [Skills Demonstrated](#-skills-demonstrated)
- [Contributing](#-contributing)
- [License](#-license)
 
---

## 📖 Project Overview
 
This project demonstrates a **complete e-commerce database workflow** alongside advanced SQL analytics. It is structured as a professional portfolio project designed to showcase real-world PostgreSQL skills, relational database design, and business intelligence capabilities.
 
The system models a retail CRM with customers, products (with variants), orders, payments, discounts, and returns — all interconnected through a normalized relational schema.
 
---

## 📊 Project Scope
 
| Entity              | Volume                      |
|---------------------|-----------------------------|
| Customers           | 1,000+                      |
| Products            | 5,000+ (with 3 variants each) |
| Orders              | 1,500+                      |
| Order Items         | Multiple items per order    |
| Payments            | Linked to every order       |
| Discounts & Returns | Fully modeled               |
 
---

## 📁 Folder Structure
 
```
retail-crm-postgresql/
│
├── 01_Requirements/        # Business requirements and project scope documentation
│
├── 02_Design/              # Entity-Relationship (ER) diagrams and database design artifacts
│
├── 03_Schema/              # SQL scripts for creating all tables, constraints, and indexes
│
├── 04_Sample_data/         # SQL scripts for populating the database with realistic sample data
│
├── 05_Analytics/           # SQL queries for business analytics and reporting
│
└── README.md               # Project documentation (this file)
```

---

## 🗄️ Database Schema
 
The schema follows a **normalized relational design** (3NF) with the following core entities:
 
### Core Tables
 
| Table            | Description                                              |
|------------------|----------------------------------------------------------|
| `customers`      | Customer profiles, contact info, and registration dates  |
| `products`       | Product catalog with categories and base pricing         |
| `product_variants` | SKU-level variants (size, color, etc.) per product     |
| `orders`         | Order header records linked to customers                 |
| `order_items`    | Line-item detail for each order                          |
| `payments`       | Payment records with method and status                   |
| `discounts`      | Discount/coupon definitions and application rules        |
| `returns`        | Product return records with reason codes                 |

### Key Design Decisions
 
- **Foreign key constraints** enforce referential integrity across all tables.
- **CHECK constraints** validate business rules (e.g., quantity > 0, price > 0).
- **Indexes** are applied on high-cardinality lookup columns (customer_id, order_id, product_id) to optimize query performance.
- **Timestamps** (`created_at`, `updated_at`) are used throughout for auditability.

---

## 📈 Analytics Modules
 
The `05_Analytics/` folder contains SQL queries organized by business domain:
 
### Sales Analytics
- Total revenue by day, week, month, and year
- Average order value (AOV) trends
- Revenue breakdown by product category
 
### Customer Analytics
- New vs. returning customer rates
- Customer Lifetime Value (CLV) estimation
- **Cohort Analysis** — Retention rates by acquisition month
- **RFM Segmentation** — Classify customers as Champions, Loyal, At-Risk, Lost, etc.
 
### Product Performance
- Best-selling products and variants
- Products with the highest return rates
- Inventory turnover analysis
 
### Payment & Discount Trends
- Payment method distribution (credit card, cash, wallet, etc.)
- Discount code usage and revenue impact
- Failed/refunded payment tracking
 
### Advanced Analytics
- **Market Basket Analysis** — Identify products frequently purchased together
- Seasonal demand patterns
- Geographic sales distribution (if location data is present)
 
---

## 🚀 Getting Started
 
### Prerequisites
 
- [PostgreSQL 14+](https://www.postgresql.org/download/) installed and running
- A PostgreSQL client such as:
  - [pgAdmin](https://www.pgadmin.org/)
  - [DBeaver](https://dbeaver.io/)
  - [VS Code SQLTools extension](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
  - `psql` command-line client
 
### Installation
 
1. **Clone the repository**
   ```bash
   git clone https://github.com/sajed-abir/retail-crm-postgresql.git
   cd retail-crm-postgresql
   ```
 
2. **Create the database**
   ```bash
   psql -U postgres -c "CREATE DATABASE retail_crm;"
   ```
 
3. **Run the schema scripts**
   ```bash
   psql -U postgres -d retail_crm -f 03_Schema/schema.sql
   ```
 
4. **Load the sample data**
   ```bash
   psql -U postgres -d retail_crm -f 04_Sample_data/sample_data.sql
   ```
 
5. **Run analytics queries**
   ```bash
   psql -U postgres -d retail_crm -f 05_Analytics/sales_analytics.sql
   ```

---

## 💻 Usage
 
Once the database is set up, you can:
 
- **Explore the schema** using pgAdmin's ERD viewer or any database browser.
- **Run analytics queries** from `05_Analytics/` to generate business insights.
- **Extend the schema** to add new entities (e.g., `suppliers`, `warehouses`, `loyalty_points`).
- **Connect a BI tool** like Metabase, Tableau, or Power BI to build dashboards on top of the database.
 
---

## 🔍 Sample Queries
 
### Top 5 Customers by Revenue
```sql
SELECT
    c.customer_id,
    c.full_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 5;
```

### Monthly Revenue Trend
```sql
SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    COUNT(DISTINCT o.order_id)        AS total_orders,
    SUM(oi.quantity * oi.unit_price)  AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY 1
ORDER BY 1;
```

### RFM Segmentation (Simplified)
```sql
WITH rfm AS (
    SELECT
        customer_id,
        MAX(order_date)                              AS last_order,
        COUNT(DISTINCT order_id)                     AS frequency,
        SUM(total_amount)                            AS monetary
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT
    customer_id,
    CURRENT_DATE - last_order::date AS recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary
FROM rfm
ORDER BY recency_days ASC, frequency DESC;
```

### Market Basket — Frequently Co-Purchased Products
```sql
SELECT
    a.product_id AS product_a,
    b.product_id AS product_b,
    COUNT(*)     AS times_bought_together
FROM order_items a
JOIN order_items b
    ON a.order_id = b.order_id
    AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_bought_together DESC
LIMIT 10;
```
 
---

## 🧠 Skills Demonstrated
 
| Area                        | Skills Applied                                                           |
|-----------------------------|--------------------------------------------------------------------------|
| **Database Design**         | Schema normalization (3NF), ER modeling, constraints, indexes            |
| **SQL Querying**            | JOINs, subqueries, CTEs, window functions, aggregate functions           |
| **Business Intelligence**   | KPI reporting, cohort analysis, RFM segmentation, market basket analysis |
| **Data Generation**         | Realistic synthetic data simulation at scale                             |
| **Query Optimization**      | Index design, query planning, efficient aggregation                      |
| **PostgreSQL Features**     | `DATE_TRUNC`, `GENERATE_SERIES`, `NTILE`, `ROW_NUMBER`, `CASE` logic     |
 
---

## 🤝 Contributing
 
Contributions, issues, and feature requests are welcome!
 
1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Open a Pull Request
 
---

## 📄 License
 
This project is open-source.
 
---

## 👤 Author
 
**Sajed Khan Abir**
 
- GitHub: [@sajed-abir](https://github.com/sajed-abir)
- LinkedIn: [sajed-khan-abir](https://www.linkedin.com/in/sajed-khan-abir/)
---