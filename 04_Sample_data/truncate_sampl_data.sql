-- Remove all sample data from the database
TRUNCATE TABLE Returns,
Payments,
Order_Items,
Orders,
Product_Variants,
Products,
Discounts,
Customer_Address,
Customer,
Categories,
Discounts RESTART IDENTITY CASCADE;

SELECT COUNT(*) FROM categories;