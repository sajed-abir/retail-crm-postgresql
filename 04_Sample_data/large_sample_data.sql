TRUNCATE TABLE Returns,
Payments,
Order_Items,
Orders,
Product_Variants,
Products,
Discounts,
Customer_Address,
Customer,
Categories RESTART IDENTITY CASCADE;

SELECT COUNT(*) FROM Orders;