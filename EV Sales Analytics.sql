######### EV Sales Analytics #########

#### Table Creation and Data load ####

CREATE TABLE ev_sales (
    year INT,
    month_name VARCHAR(20),
    Start_Of_Month DATE,
    state VARCHAR(100),
    vehicle_class VARCHAR(100),
    vehicle_category VARCHAR(100),
    vehicle_type VARCHAR(100),
    ev_sales_quantity INT
);


## Create Dimension Tables ##

CREATE TABLE dim_date (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    Start_Of_Month DATE UNIQUE,
    year INT,
    month_name VARCHAR(20)
);

INSERT INTO dim_date (date, year, month_name)
SELECT DISTINCT Start_Of_Month, year, month_name
FROM ev_sales;

CREATE TABLE dim_state (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(100) UNIQUE
);

INSERT INTO dim_state (state_name)
SELECT DISTINCT state FROM ev_sales;

CREATE TABLE dim_vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_class VARCHAR(100),
    vehicle_category VARCHAR(100),
    vehicle_type VARCHAR(100),
    UNIQUE (vehicle_class , vehicle_category , vehicle_type)
);

INSERT INTO dim_vehicle (vehicle_class, vehicle_category, vehicle_type)
SELECT DISTINCT vehicle_class, vehicle_category, vehicle_type
FROM ev_sales;

## Create Fact Table ##

CREATE TABLE fact_ev_sales (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    date_id INT,
    state_id INT,
    vehicle_id INT,
    ev_sales_quantity INT,
    FOREIGN KEY (date_id)
        REFERENCES dim_date (date_id),
    FOREIGN KEY (state_id)
        REFERENCES dim_state (state_id),
    FOREIGN KEY (vehicle_id)
        REFERENCES dim_vehicle (vehicle_id)
);


INSERT INTO fact_ev_sales (date_id, state_id, vehicle_id, ev_sales_quantity)
SELECT d.date_id, s.state_id, v.vehicle_id, st.ev_sales_quantity
FROM staging_ev_sales st
JOIN dim_date d ON st.date = d.date
JOIN dim_state s ON st.state = s.state_name
JOIN dim_vehicle v ON st.vehicle_class = v.vehicle_class
                   AND st.vehicle_category = v.vehicle_category
                   AND st.vehicle_type = v.vehicle_type;
                   
                   
-- 1. What is the total number of electric vehicles sold across all years? --

SELECT 
    FORMAT(SUM(EV_Sales_Quantity), 0) AS `Total Vehicle Sold`
FROM
    fact_ev_sales;
    
    
-- 2. How have EV sales trended on a yearly basis --

SELECT 
    d.Year,
    FORMAT(SUM(s.EV_Sales_Quantity), 0) AS `Total Vehicle Sold`
FROM
    fact_ev_sales AS s
        JOIN
    dim_date AS d USING (date_id)
GROUP BY d.Year
ORDER BY d.Year ASC;

--- 3. Which states contribute the most to EV adoption (Top 5 states by total sales)? --

with Rnk as (SELECT s.state_name, 
SUM(EV_Sales_Quantity) AS total_sales, 
dense_rank() over( order by SUM(EV_Sales_Quantity) desc) as Rank_State
FROM fact_ev_sales f
JOIN dim_state s ON f.state_id = s.state_id
GROUP BY s.state_name
ORDER BY total_sales DESC)

select state_name as State_Name, 
Format((total_sales),0) as Total_Sales, Rank_State
from Rnk
where Rank_State <= 5;


-- 4.Which states are lagging in EV adoption (Bottom 5 states by total sales)? --

with Rnk as (SELECT s.state_name, 
SUM(EV_Sales_Quantity) AS total_sales, 
dense_rank() over( order by SUM(EV_Sales_Quantity) asc) as Rank_State
FROM fact_ev_sales f
JOIN dim_state s ON f.state_id = s.state_id
GROUP BY s.state_name
ORDER BY total_sales DESC)

select state_name as State_Name, 
Format((total_sales),0) as Total_Sales, Rank_State
from Rnk
where Rank_State <= 5
order by Rank_State asc;

-- 5. What are the monthly sales trends, and do any seasonal patterns emerge? --

-- Shows time-series analysis with SQL ---

SELECT CONCAT(d.year, '-', d.month_name) AS period,
       format(SUM(f.ev_sales_quantity),0) AS monthly_sales,
       format(LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year, d.Start_Of_Month),0) AS prev_month_sales,
       concat(ROUND(((SUM(f.ev_sales_quantity) - 
               LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year, d.Start_Of_Month)) 
               / LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year, d.Start_Of_Month)) * 100, 2),"%") AS mom_growth
FROM fact_ev_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month_name, d.Start_Of_Month
ORDER BY d.year, d.Start_Of_Month;


-- 6. What is the year-over-year growth rate of EV sales? --

--- Shows Window Functions (LAG) + growth % calculation. --- 

SELECT d.year, format(SUM(f.ev_sales_quantity),0) AS total_sales,
       LAG(format(SUM(f.ev_sales_quantity),0)) OVER (ORDER BY d.year) AS prev_year,
       concat(ROUND(((SUM(f.ev_sales_quantity) - LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year)) 
              / LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year)) * 100, 2), "%") AS growth_percent
FROM fact_ev_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY d.year;


-- 7. How do different vehicle categories (2W, 3W, 4W, etc.) contribute to overall EV adoption? --

SELECT v.vehicle_category, format(SUM(f.ev_sales_quantity),0) AS total_sales,
       concat(ROUND(SUM(f.ev_sales_quantity) * 100.0 / 
             (SELECT SUM(ev_sales_quantity) FROM fact_ev_sales), 2), "%") AS percent_share
FROM fact_ev_sales f
JOIN dim_vehicle v ON f.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_category
ORDER BY SUM(f.ev_sales_quantity) DESC;



-- 8.Which states demonstrate the highest growth momentum in EV adoption each year (Top 3 states per year)? --

--- Shows ranking functions (dense_rank) to find top/bottom N states. ---

SELECT year, state_name, format(total_sales,0) as total_sales
FROM (
    SELECT d.year, s.state_name, SUM(f.ev_sales_quantity) AS total_sales,
           dense_rank() OVER (PARTITION BY d.year ORDER BY SUM(f.ev_sales_quantity) DESC) AS rn
    FROM fact_ev_sales f
    JOIN dim_date d ON f.date_id = d.date_id
    JOIN dim_state s ON f.state_id = s.state_id
    GROUP BY d.year, s.state_name
) ranked
WHERE rn <= 3;


-- 9. Which states consistently underperform in EV adoption each year (Bottom 3 states per year)? --

SELECT year, state_name, format(total_sales,0) as total_sales
FROM (
    SELECT d.year, s.state_name, SUM(f.ev_sales_quantity) AS total_sales,
           dense_rank() OVER (PARTITION BY d.year ORDER BY SUM(f.ev_sales_quantity) asc) AS rn
    FROM fact_ev_sales f
    JOIN dim_date d ON f.date_id = d.date_id
    JOIN dim_state s ON f.state_id = s.state_id
    GROUP BY d.year, s.state_name
) ranked
WHERE rn <= 3;

-- 10. In which years did EV sales surpass the 100,000-unit benchmark, indicating rapid adoption? --

WITH yearly_sales AS (
   SELECT d.year, SUM(f.ev_sales_quantity) AS total_sales
   FROM fact_ev_sales f
   JOIN dim_date d ON f.date_id = d.date_id
   GROUP BY d.year
)
SELECT * FROM yearly_sales WHERE total_sales > 100000;

--- 11. Store Procedure ----

DELIMITER //
CREATE PROCEDURE GetTopStatesByYear(IN yr INT)
BEGIN
with Rnk as (SELECT s.state_name, SUM(EV_Sales_Quantity) AS total_sales, dense_rank() over( order by SUM(EV_Sales_Quantity) desc) as Rank_State
FROM fact_ev_sales f
JOIN dim_state s ON f.state_id = s.state_id
GROUP BY s.state_name
ORDER BY total_sales DESC)

select state_name as State_Name, Format((total_sales),0) as Total_Sales, Rank_State
from Rnk
where Rank_State <= 5;
END //
DELIMITER ;

CALL GetTopStatesByYear(2024);





