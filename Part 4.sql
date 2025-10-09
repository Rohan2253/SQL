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
