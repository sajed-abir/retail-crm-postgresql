
# 📄 Business Requirements Document (BRD)

## 1. Project Overview

This project is a PostgreSQL-based database system for an online fashion and apparel brand.

The system enables the business to manage:

- Customers  
- Products and product variants (size, color)  
- Orders and payments  
- Discounts, coupons, and returns  
- Sales and customer analytics  

The database is designed with scalability, performance optimization, and clean modular SQL structure in mind.

---

## 2. Business Problem

Small and growing fashion eCommerce brands often face:

- Difficulty managing product variants (size, color)
- Poor inventory tracking
- Limited reporting capabilities
- Inability to analyze repeat customers
- No structured way to monitor returns and discounts

Spreadsheet-based systems are not scalable and lack analytical power.

This system solves those problems with a normalized relational database and optimized queries.

---

## 3. Scope

### In-Scope

- Customer management
- Product and variant management
- Category management
- Order and order item tracking
- Payment tracking
- Discount and coupon management
- Return management
- Sales and inventory analytics
- Performance optimization with indexes

### Out-of-Scope

- Frontend application
- Payment gateway integration
- Multi-vendor marketplace support
- Machine learning forecasting

---

## 4. Assumptions

- PostgreSQL is used as the database platform
- Data is imported via CSV or inserted manually
- Data volume starts small to medium scale
- Users have basic SQL knowledge
- Analytics are performed using SQL queries

---

## 5. Functional Requirements

### Customer Management

- Store and manage customer details
- Track purchase history

### Product & Variant Management

- Manage products separately from size/color variants
- Maintain SKU-level inventory tracking

### Order Management

- Record orders and associated items
- Track order status
- Calculate subtotal, tax, discounts, and total

### Payment Management

- Record payment method and payment status

### Discount & Coupon Handling

- Support percentage and fixed discounts
- Track validity period and usage

### Returns

- Record returned items
- Track refund amount and return status

### Analytics

- Monthly revenue trends
- Best-selling products
- Best-selling sizes and colors
- Repeat purchase rate
- Customer lifetime value
- Inventory turnover
- Return rate analysis
- Gross profit analysis

---

## 6. Non-Functional Requirements

- Optimized queries using indexes
- Normalized schema design
- Modular SQL structure
- Maintainable and scalable architecture
- Clear documentation and folder organization

---

## 7. Success Criteria

- Database deployed successfully in PostgreSQL
- All core entities properly related with constraints
- Analytical queries return meaningful insights
- Performance improved using indexing strategies
- Documentation clear for client or developer use

---
