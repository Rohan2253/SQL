-- Part 2: Joins Practice
-- 1 Show all orders along with the customer name.
select*from customers;
select*from employees;

SELECT 
    o.orderNumber,
    o.orderDate,
    o.status,
    c.customerName
FROM 
    orders o
JOIN 
    customers c
ON 
    o.customerNumber = c.customerNumber;
    
    
-- 2 Show each customer with their sales representative’s name.
select c.customerName,e.firstName as sales_representative from 
customers c join 
employees e
on c.salesRepEmployeeNumber=e.employeeNumber;

-- 3 Find all employees and the office city they work in.
select e.firstName,o.city from employees e
join offices o
on e.officeCode=o.officeCode;

-- 4 Show each order with its ordered products and quantities.
select*from products;
select*from orderdetails;

select p.productName,o.quantityOrdered from 
products p join 
orderdetails o on
p.productCode = o.productCode;

-- 5 List all payments with customer name and country.
select*from payments;
select*from customers;
select c.customerName,c.country,p.amount
from customers c
join payments p
on p.customerNumber=c.customerNumber;

-- 6 Show all customers who have never placed an order.
SELECT 
    c.customerNumber,
    c.customerName
FROM 
    customers c
LEFT JOIN 
    orders o
ON 
    c.customerNumber = o.customerNumber
WHERE 
    o.orderNumber IS NULL;
    
-- 7 Find employees who don’t manage anyone.

SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    e.jobTitle
FROM 
    employees e
LEFT JOIN 
    employees m
ON 
    e.employeeNumber = m.reportsTo
WHERE 
    m.employeeNumber IS NULL;
