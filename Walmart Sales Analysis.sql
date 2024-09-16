-- Create database
create database Walmart_db;

use walmart_db;

-- Create Backup Table
CREATE TABLE `walmart_sale` (
  `Invoice ID` varchar(100),
  `Branch` text,
  `City` text,
  `Customer type` text,
  `Gender` text,
  `Product line` text,
  `Unit price` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Tax 5%` double DEFAULT NULL,
  `Total` double DEFAULT NULL,
  `Date` date,
  `Time` text,
  `Payment` text,
  `cogs` double DEFAULT NULL,
  `gross margin percentage` double DEFAULT NULL,
  `gross income` double DEFAULT NULL,
  `Rating` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into walmart_sale
select * from walmart;

select * from walmart_sale order by 1 limit 10;


-- Data cleaning
ALTER TABLE walmart_sale
ADD PRIMARY KEY (`Invoice ID`);


-- Add the Time_of_Day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS Time_of_Day
FROM walmart_sale;

ALTER TABLE walmart_sale ADD COLUMN Time_of_Day VARCHAR(20);

UPDATE walmart_sale
SET Time_of_Day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

select time,Time_of_Day from walmart_sale;


-- Add Day column
ALTER TABLE walmart_sale ADD COLUMN Day VARCHAR(10);

UPDATE walmart_sale
SET Day = DAYNAME(date);

select date,Day from walmart_sale;


-- Add month column
SELECT
	date,
	MONTHNAME(date)
FROM walmart_sale;

ALTER TABLE walmart_sale ADD COLUMN Month VARCHAR(10);

UPDATE walmart_sale
SET Month = MONTHNAME(date);

select date,Month from walmart_sale;


-- Add Year Column
ALTER TABLE walmart_sale ADD COLUMN Year INT;

UPDATE walmart_sale
SET Year = YEAR(date);

SELECT Date, Year
FROM walmart_sale;


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM walmart_sale;


-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM walmart_sale;


-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT `Product line`
FROM walmart_sale;


-- What is the most selling product line
SELECT
    SUM(`Quantity`) AS qty,
    `Product line`
FROM walmart_sale
GROUP BY `Product line`
ORDER BY qty DESC;


-- What is the most selling product line
SELECT
    `Product line`,
    SUM(`Quantity`) AS qty
FROM walmart_sale
GROUP BY `Product line`
ORDER BY qty DESC;


-- What is the total revenue by month
SELECT
    DATE_FORMAT(Date, '%d-%m-%Y') AS month,
    round(sum(Total),3) AS Total_Revenue
FROM walmart_sale
GROUP BY DATE_FORMAT(Date, '%d-%m-%Y')
ORDER BY month;


-- What month had the largest COGS?
SELECT
    MONTHNAME(Date) AS month,
    round(SUM(cogs),3) AS Total_Cogs
FROM walmart_sale
GROUP BY MONTHNAME(Date)
ORDER BY Total_Cogs DESC;


-- What product line had the largest revenue?
SELECT
    `Product line`,
    round(SUM(`Total`),3) AS total_revenue
FROM
    `walmart_sale`
GROUP BY
    `Product line`
ORDER BY
    total_revenue DESC;
    

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	round(SUM(total),3) AS total_revenue
FROM walmart_sale
GROUP BY city, branch 
ORDER BY total_revenue;


-- What product line had the largest VAT?
SELECT
    `Product line`,
    ROUND(AVG(`Tax 5%`), 3) AS avg_tax
FROM walmart_sale
GROUP BY `Product line`
ORDER BY avg_tax DESC;



-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

-- Calculate the overall average quantity
WITH OverallAvg AS (
    SELECT 
        AVG(Quantity) AS avg_qnty
    FROM 
        walmart_sale
)

-- Classify each product line
SELECT
    `Product line`,
    CASE
        WHEN AVG(`Quantity`) > (SELECT avg_qnty FROM OverallAvg) THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM 
    walmart_sale
GROUP BY 
    `Product line`;    
    

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM walmart_sale
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmart_sale);


-- What is the most common product line by gender
SELECT
    `Gender`,
    `Product line`,
    COUNT(*) AS total_cnt
FROM 
    walmart_sale
GROUP BY 
    `Gender`, `Product line`
ORDER BY 
    total_cnt DESC;


-- What is the average rating of each product line
-- Calculate the average rating for each product line
SELECT
    `Product line`,
    ROUND(AVG(`Rating`), 2) AS avg_rating
FROM 
    walmart_sale
GROUP BY 
    `Product line`
ORDER BY 
    avg_rating DESC;


-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
    DISTINCT `Customer type`
FROM 
    walmart_sale;
    
    
-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM walmart_sale;


-- What is the most common customer type?
SELECT
	`Customer type`,
	count(*) as count
FROM walmart_sale
GROUP BY `Customer type`
ORDER BY count DESC;


-- Which customer type buys the most?
SELECT
	`Customer type`,
    COUNT(*)
FROM walmart_sale
GROUP BY `Customer type`;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart_sale
GROUP BY gender
ORDER BY gender_cnt DESC;


-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart_sale
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	Day,
	round(AVG(rating),3) AS avg_rating
FROM walmart_sale
GROUP BY Day
ORDER BY avg_rating DESC;


-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	Day,
	round(AVG(rating),3) AS avg_rating
FROM walmart_sale
WHERE branch = "A"
GROUP BY Day
ORDER BY avg_rating DESC;


-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	Day,
	round(AVG(rating),3) AS avg_rating
FROM walmart_sale
GROUP BY Day 
ORDER BY avg_rating DESC;

-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?


-- Which day of the week has the best average ratings per branch?
SELECT 
	Day,
	COUNT(Day) total_sales
FROM walmart_sale
WHERE branch = "C"
GROUP BY Day
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
    Day,
    COUNT(*) AS total_sales
FROM 
    walmart_sale
WHERE 
    `Day` = 'Sunday'
GROUP BY 
    Day
ORDER BY 
    total_sales DESC;


-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
    `Customer type`,
    round(SUM(`Total`),3) AS total_revenue
FROM 
    walmart_sale
GROUP BY 
    `Customer type`
ORDER BY 
    total_revenue DESC;


-- Which city has the largest tax/VAT percent?
SELECT
    `City`,
    ROUND(AVG(`Tax 5%`), 2) AS avg_tax_pct
FROM 
    walmart_sale
GROUP BY 
    `City`
ORDER BY 
    avg_tax_pct DESC;


-- Which customer type pays the most in VAT?
SELECT
    `Customer type`,
    round(AVG(`Tax 5%` / `Total` * 100),2) AS avg_tax_pct
FROM 
    walmart_sale
GROUP BY 
    `Customer type`
ORDER BY 
    avg_tax_pct;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------