create database if not exists  salesDataWalmart;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_percentage float(11,9) not null,
    gross_income decimal(12,4) not null,
    rating float(2,1)
);


select * from sales;


-- --------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------- feature engineering----------------------------------------------------------------

-- adding new column time_of_day

select 
 time,
	( case
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:00:01" and "16:00:00" then "Afternoon"
            else "Evening"
	  end
    ) as time_of_date
 from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day=	( case
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:00:01" and "16:00:00" then "Afternoon"
            else "Evening"
	  end);
      
-- day_name

select date,
	dayname(date)
from sales ;

alter table sales add column day_name varchar(10);

update sales 
set day_name=dayname(date);

-- month_name
select date,monthname(date) from sales;

alter table sales add column month_name varchar(10);

update sales set month_name=monthname(date);
-- --------------------------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------question answer---------------------------------------------------------
-- ------------------------------------------------generic -----------------------------------------------------------------
-- Q1) How many unique cities does the data have?
-- >
   select distinct city from sales;
   select count(distinct city)from sales;

-- Q2) In which city is each branch?
-- >
   select distinct city,branch from sales;
   
   -- --------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------product---------------------------------------------------------

-- Q1) How many unique productlines the data have?
-- >
	select distinct product_line from sales;
    select count( distinct product_line )from sales;
   
-- Q2) What is the most common paymennt method
-- >
    select 
    payment_method , 
    count(payment_method) as count 
    from sales 
    group by payment_method
    order by count desc;

-- Q3) What is the most selling product line?
-- >
	select 
    product_line , 
    count(product_line) as count 
    from sales 
    group by product_line
    order by count desc;
    
-- Q4) What is total revenue by month?
-- >
	select 
		month_name,sum(total) as total_revenue
        from sales
        group by month_name
        order by total_revenue;
        
-- 5. What month had the largest COGS?
-- >
select 
month_name,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- 6. What product line had the largest revenue?
select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- 7. What is the city with the largest revenue?
-- >
select city, 
sum(total) as total_revenue
from sales 
group by city
order by total_revenue;

-- 8)What product line had the largest VAT?
-- >
select product_line,
sum(VAT) as VAT
from sales
group by product_line
order by VAT;

-- 9)Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- 10) Which branch sold more products than average product sold?
select branch,
sum(quantity) as qty
from sales
group by branch
having qty >(select avg(quantity) from sales); 

-- 11)What is the most common product line by gender?
select gender,product_line ,
count(gender) as cnt
from sales 
group by gender, product_line
order by cnt desc;

-- 12. What is the average rating of each product line?

select 
product_line,
 avg(rating) as avg_rating
 from sales
 group by product_line
 order by avg_rating desc;
 
 
 -- ----------------------------------------------------sales---------------------------------------------------------------
 -- Q1)number of sales made in each time of the day?
 select 
 time_of_day,
 count(*)as total_sales
 from sales
 group by time_of_day;
 
 -- Q2)which of the customer type brings the most revenue?
 select customer_type,
 sum(total) as total_revenue
 from sales
 group by customer_type;
 
 -- Q3)Whcih city has the Vat?
 select city,
 avg(VAT) from sales group by city;
 
 -- Q4) which customer type pays the most VAT?
 select customer_type,
 avg(VAT) as VAT
 from sales 
 group by customer_type;
 
 
 -- -------------------------------------------------------------------------------------------------------------------------
 -- -------------------------------------------CUSTOMER ---------------------------------------------------------------------
 
 -- Q1) how many unique customer type does the data have?
 select distinct customer_type from sales;
 select count(distinct customer_type )from sales;
 
 -- Q2) How many unique payment method does the data have?
 select distinct payment_method from sales;
 select count(distinct payment_method)from sales;
 
 -- Q3)What is the most common customer type?
 select customer_type,
 count(customer_type) as cnt
 from sales
 group by customer_type 
 order by cnt desc;
 
 -- Q4)Which customer type buys the most?
  select customer_type,
 count(*) as cnt
 from sales
 group by customer_type 
 order by cnt desc;
 
 -- Q5) What is the gender of most of the customers?
 select gender,
 count(gender) as count
 from sales
 group by gender;
 
 -- Q6) What is gender distribution per branch?
 select branch,gender,
 count(gender) as cnt
 from sales
 group by branch,gender
 order by branch;

-- Q7) Which time of the day customer gives the most ratings?
select time_of_day,
count(*) as cnt
from sales 
group by time_of_day;

-- -- Q7) Which time of the day customer gives the most good ratings?
select time_of_day,
avg(rating) as rating
from sales 
group by time_of_day
order by rating desc;

 -- Q7) Which time of the day customer gives the most ratings per branch?
 select branch,time_of_day,
 avg(rating) as rating 
 from sales 
 group by branch,time_of_day
 order by rating desc;


-- which day of the week has  the best ratings?
select day_name,
avg(rating) as rating 
from sales
group by day_name
order by rating desc;

-- which day of the week has the best rating per branch?
select branch, day_name,
avg(rating) as rating 
from sales
group by branch,day_name
order by rating desc;
