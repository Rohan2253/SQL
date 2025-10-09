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

-- Part 4: Subqueries & Insights
-- 1 Find customers who made payments greater than the average payment.
select round(avg(amount)) from payments;

select customerNumber, amount
from payments
where amount > (select round(avg(amount)) from payments);

-- 2 List products that have never been ordered.
select productcode from orderdetails;

select  productcode,productLine from 
products 
where productcode not in(select productcode from orderdetails);

-- 3 Find the employee with the highest number of direct reports.

select reportsTo as managerNumber,
       count(*) as num_direct_reports
from employees
where reportsTo is not null
group by reportsTo
order by num_direct_reports desc
limit 1;
select* from employees;


-- 4 Show orders that contain the most expensive product. 
select productCode,round(max(priceEach))as expensive_product
from orderdetails
group by productCode
order by expensive_product desc
limit 1;

-- 5 List the top 3 offices with the highest total sales of 3 offices

select ofs.city, ofs.country,
       round(sum(ord.quantityOrdered * ord.priceEach), 2) as total_sales
from orderdetails ord
join orders o on ord.orderNumber = o.orderNumber
join customers c on o.customerNumber = c.customerNumber
join employees e on c.salesRepEmployeeNumber = e.employeeNumber
join offices ofs on e.officeCode = ofs.officeCode
group by ofs.city, ofs.country
order by total_sales desc
limit 3;

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


-- Part 7: Business Insights
-- 1 Which country generates the most revenue?
select c.state,o.customernumber,od.orderNumber,round(sum(od.quantityOrdered*od.priceEach)) as most_revenue
from orderdetails od
join orders o
on od.orderNumber=o.orderNumber
join customers c 
on c.customerNumber=o.customerNumber
group by o.customerNumber,od.orderNumber,c.customerNumber
order by most_revenue desc ;


-- 2 Who are the top 5 sales representatives by payments?

select e.employeeNumber,e.firstName,round(sum(p.amount))as highest_payments
from customers c 
join payments p
on c.customerNumber=p.customerNumber
join employees e
 on c.salesRepEmployeeNumber = e.employeeNumber
group by e.employeeNumber,e.firstName
order by highest_payments
limit 5;

-- 3 Which month has the highest number of orders?

select date_format(orderDate, '%Y-%m') as order_month,
       count(orderNumber) as total_orders
from orders
group by order_month
order by total_orders desc
limit 1;

-- 4 What is the average order size (quantity of products per order)?

select round(avg(order_qty)) as avg_order_size
from (
    select orderNumber, sum(quantityOrdered) as order_qty
    from orderdetails
    group by orderNumber
) as order_totals;

-- 5 Which product has the highest profit margin (MSRP - buyPrice)?

select productName,(MSRP-buyPrice) as margin
from products
order by margin desc
limit 1;

-- 6 Which office manages the largest number of customers?
select o.city,count(c.customerNumber)as total_customers
from customers c
join employees e
on c.salesRepEmployeeNumber=e.employeeNumber
join offices o
on e.officeCode=o.officeCode
group by o.city
order by total_customers desc
limit 1;

-- 7 Who are the most valuable customers (based on payments)?

select c.customerName,round(sum(p.amount)) as total_amount 
from payments p
join customers c
on c.customerNumber=p.customerNumber
group by c.customerName
order by total_amount desc;

-- 8 Find the trend of sales over years.
select year(o.orderDate)as order_year,sum(round(od.quantityOrdered*priceEach)) as total_sales 
from orderdetails od
join orders o 
on o.orderNumber=od.orderNumber
group by order_year;

-- 9 Which product line has highest stock but lowest sales?

 select p.productLine,max(p.quantityInstock) highest_stock,
 min(od.quantityOrdered)as low_sales from 
products p 
join orderdetails od 
on p.productCode=od.productCode
group by p.productLine
order by highest_stock desc,low_sales asc
limit 1;

-- 10 Detect customers with zero payments.
select customerNumber from customers 
where customerNumber not in(select customerNumber from payments);

-- 11 Find the slowest-moving products (very few orders)
select p.productName,od.productcode,sum(od.quantityordered)as total_ordered from orderdetails od
join products p
on p.productCode=od.productCode
group by p.productName,od.productCode
order by total_ordered asc
limit 5;


