select*from customers;
-- 1 List all customers from USA.
select customerName,country from customers
where country='USA';

-- 2 Show all products where stock is less than 500 units.
select *from products;
select productName,quantityInStock
from products
where quantityInStock<500;

-- 3 Find employees working in the Paris office.
select*from customers;
select*from offices;

SELECT e.employeeNumber,
       e.firstName,
       e.lastName,
       e.jobTitle,
       o.city
FROM employees e
JOIN offices o 
    ON e.officeCode = o.officeCode
WHERE o.city = 'Paris';

-- 4 Get orders with status = 'Cancelled'.
select*from orders;
select orderNumber,status from orders 
where status='Cancelled';

-- 5 List all customers whose credit limit > 100000.
select*from customers;
select customerName,creditlimit
from customers
where creditLimit>100000;

-- 6 Find customers who have no assigned sales representative.
select customerName,salesRepEmployeeNumber from customers 
where salesRepEmployeeNumber is Null;

-- 7 Show all orders placed in 2004.
SELECT orderNumber, orderDate
FROM orders
WHERE YEAR(orderDate) = 2004;
