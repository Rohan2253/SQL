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
