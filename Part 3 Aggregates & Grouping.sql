-- Part 3: Aggregates & Grouping
-- 1 Count how many customers each country has
select*from customers;
select country,count(*)as total_customer from customers 
group by country;

-- 2 Find the total sales amount for each customer.
select*from payments;

select c.customerName,round(sum(p.amount))as total_buying
from customers c
join payments p
on c.customerNumber=p.customerNumber
group by p.customerNumber;

-- 3 Show the average credit limit per country.
SELECT 
    country,
    ROUND(AVG(creditLimit)) AS avgCreditLimit
FROM 
    customers
GROUP BY 
    country
ORDER BY 
    avgCreditLimit DESC;
    
-- 4 Find the maximum payment amount per customer.
    select c.customerName,round(max(p.amount)) from payments p join customers c
    on p.customerNumber=c.customerNumber
    group by c.customerName;

-- 5 Count the number of products in each product line.
select*from products;
select productLine,count(productName)as total_product from products 
group by productLine;

-- 6 Find which employee manages the most customers.
select salesRepEmployeeNumber,count(customerNumber)as total_customers
from customers 
group by salesRepEmployeeNumber;

-- 7 Get the monthly sales totals for 2004.
select*from orders;
select*from orderdetails;
SELECT 
    YEAR(o.orderDate) AS orderYear,
    MONTH(o.orderDate) AS orderMonth,
    SUM(od.quantityOrdered * od.priceEach) AS monthlySales
FROM 
    orders o
JOIN 
    orderdetails od
    ON o.orderNumber = od.orderNumber
WHERE 
    YEAR(o.orderDate) = 2004
GROUP BY 
    YEAR(o.orderDate), MONTH(o.orderDate)
ORDER BY 
    orderMonth;
    
    
-- 8 Find the top 5 customers by total payments.
select*from payments;
select customerNumber,round(max(amount))as total_pay from payments 
group by customerNumber 
order by total_pay desc
limit 5;
