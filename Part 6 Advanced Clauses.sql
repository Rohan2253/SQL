-- Part 6: Advanced Clauses
-- 1 Find customers who placed more than 5 orders.

SELECT c.customerNumber,
       c.customerName,
       COUNT(o.orderNumber) AS total_orders
FROM customers c
JOIN orders o
     ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
HAVING COUNT(o.orderNumber) > 5
ORDER BY total_orders DESC;


-- 2 List product lines where the average MSRP > 100.

select pl.productline,round(avg(p.MSRP))as avg_msrp
from productlines pl 
join products p
on p.productLine=pl.productLine
group by pl.productLine
having avg(p.MSRP)>100
order by avg_msrp desc;

-- 3 Show employees with more than 3 customers assigned.

SELECT e.employeeNumber,
       e.firstName,
       e.lastName,
       COUNT(c.customerNumber) AS total_customers
FROM employees e
JOIN customers c
     ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
HAVING COUNT(c.customerNumber) > 3
ORDER BY total_customers DESc;

-- 4 Display orders where the shippedDate is NULL.
select orderNumber,shippedDate 
from orders 
where shippedDate is null;

-- 5 Categorize customers by credit limit: High, Medium, Low.

select customerName ,creditLimit,
case
when creditlimit >100000 then 'High'
when creditlimit between 50000 and 100000 then 'Medium'
else 'low'
end as credit_limit
from customers 
order by creditlimit desc;

-- 6 Find the top 10 most ordered products.

select p.productName,od.productCode,sum(od.quantityOrdered)as total_order
from products p
join orderdetails od
on p.productCode=od.productCode
group by p.productName,od.productCode
order by total_order desc
limit 10;

-- 7 Show the revenue of each product line.
select productName,round(sum((quantityInStock*buyprice)))as total_revenue 
from products
group by productName
order by total_revenue desc;
