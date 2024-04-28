-- Q1. Write a code to check NULL values.
SELECT *
FROM coronavirus
WHERE province IS NULL OR 
      country_region IS NULL OR 
      latitude IS NULL OR 
      longitude IS NULL OR 
      date_data IS NULL OR 
      confirmed IS NULL OR 
      deaths IS NULL OR 
      recovered IS NULL;
	  
-- Q2. If NULL values are present, update them with zeros for all columns. 
UPDATE coronavirus
SET 
    province = CASE WHEN province IS NULL THEN '0' ELSE province END,
    country_region = CASE WHEN country_region IS NULL THEN 0 ELSE country_region END,
    latitude = CASE WHEN latitude IS NULL THEN 0 ELSE latitude END,
    longitude = CASE WHEN longitude IS NULL THEN 0 ELSE longitude END,
    date_data = CASE WHEN date_data IS NULL THEN '0' ELSE date_data END,
    confirmed = CASE WHEN confirmed IS NULL THEN 0 ELSE confirmed END,
    deaths = CASE WHEN deaths IS NULL THEN 0 ELSE deaths END,
    recovered = CASE WHEN recovered IS NULL THEN 0 ELSE recovered END;
	
-- Q3. Check total number of rows.
SELECT COUNT(*) AS total_rows
FROM coronavirus;

-- Q4. Check what is start_date and end_date
SELECT MIN(date_data) AS start_date, MAX(date_data) AS end_date
FROM coronavirus;

-- Q5. Number of month present in dataset
SELECT EXTRACT(YEAR FROM date_data) AS year, COUNT(DISTINCT EXTRACT(MONTH FROM date_data)) AS num_month_present
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data);

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM date_data) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date_data) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date_data) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date_data) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date_data) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date_data) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date_data) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date_data) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date_data) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date_data) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date_data) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date_data) = 12 THEN 'December'
    END AS month,
    EXTRACT(YEAR FROM date_data) AS year,
    ROUND(AVG(confirmed), 2) AS avg_confirmed,
    ROUND(AVG(deaths), 2) AS avg_deaths,
    ROUND(AVG(recovered), 2) AS avg_recovered
FROM coronavirus
GROUP BY EXTRACT(MONTH FROM date_data), EXTRACT(YEAR FROM date_data)
ORDER BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month.
WITH FrequentData AS (
    SELECT
        CASE 
            WHEN EXTRACT(MONTH FROM date_data) = 1 THEN 'January'
            WHEN EXTRACT(MONTH FROM date_data) = 2 THEN 'February'
            WHEN EXTRACT(MONTH FROM date_data) = 3 THEN 'March'
            WHEN EXTRACT(MONTH FROM date_data) = 4 THEN 'April'
            WHEN EXTRACT(MONTH FROM date_data) = 5 THEN 'May'
            WHEN EXTRACT(MONTH FROM date_data) = 6 THEN 'June'
            WHEN EXTRACT(MONTH FROM date_data) = 7 THEN 'July'
            WHEN EXTRACT(MONTH FROM date_data) = 8 THEN 'August'
            WHEN EXTRACT(MONTH FROM date_data) = 9 THEN 'September'
            WHEN EXTRACT(MONTH FROM date_data) = 10 THEN 'October'
            WHEN EXTRACT(MONTH FROM date_data) = 11 THEN 'November'
            WHEN EXTRACT(MONTH FROM date_data) = 12 THEN 'December'
        END AS month,
        EXTRACT(YEAR FROM date_data) AS year,
        confirmed,
        deaths,
        recovered,
        RANK() OVER (PARTITION BY EXTRACT(MONTH FROM date_data), EXTRACT(YEAR FROM date_data) ORDER BY COUNT(*) DESC) AS rank
    FROM
        coronavirus
    GROUP BY EXTRACT(MONTH FROM date_data), EXTRACT(YEAR FROM date_data), confirmed, deaths, recovered
)
SELECT
    month,
    year,
    confirmed,
    deaths,
    recovered
FROM
    FrequentData
WHERE
    rank = 1
ORDER BY
    year, month;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
	EXTRACT(YEAR FROM date_data) AS year,
	MIN(confirmed) AS min_confirmed,
	MIN(deaths) AS min_deaths,
	MIN(recovered) AS min_recovered
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data)
ORDER BY EXTRACT(YEAR FROM date_data);

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
	EXTRACT(YEAR FROM date_data) AS year,
	MAX(confirmed) AS max_confirmed,
	MAX(deaths) AS max_deaths,
	MAX(recovered) AS max_recovered
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data)
ORDER BY EXTRACT(YEAR FROM date_data);

-- Q10. The total number of case of confirmed, deaths, recovered each month.
SELECT 
	EXTRACT(YEAR FROM date_data) AS year,
	SUM(confirmed) AS total_confirmed,
	SUM(deaths) AS total_deaths,
	SUM(recovered) AS total_recovered
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data)
ORDER BY EXTRACT(YEAR FROM date_data); 

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
	CASE 
        WHEN EXTRACT(MONTH FROM date_data) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date_data) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date_data) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date_data) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date_data) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date_data) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date_data) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date_data) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date_data) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date_data) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date_data) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date_data) = 12 THEN 'December'
    END AS month,
	EXTRACT(YEAR FROM date_data) AS year,
	SUM(confirmed) AS total_confirmed,
	ROUND(AVG(confirmed), 2) AS avg_confirmed,
	ROUND(VARIANCE(confirmed), 2) AS var_confirmed,
	ROUND(STDDEV(confirmed), 2) AS stddev_confirmed
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data) 
ORDER BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data);

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total deaths cases, their average, variance & STDEV )
SELECT 
	CASE 
        WHEN EXTRACT(MONTH FROM date_data) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date_data) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date_data) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date_data) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date_data) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date_data) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date_data) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date_data) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date_data) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date_data) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date_data) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date_data) = 12 THEN 'December'
    END AS month,
	EXTRACT(YEAR FROM date_data) AS year,
	SUM(deaths) AS total_deaths,
	ROUND(AVG(deaths), 2) AS avg_deaths,
	ROUND(VARIANCE(deaths), 2) AS var_deaths,
	ROUND(STDDEV(deaths), 2) AS stddev_deaths
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data) 
ORDER BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data);

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total recovered cases, their average, variance & STDEV )
SELECT 
	CASE 
        WHEN EXTRACT(MONTH FROM date_data) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date_data) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date_data) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date_data) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date_data) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date_data) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date_data) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date_data) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date_data) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date_data) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date_data) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date_data) = 12 THEN 'December'
    END AS month,
	EXTRACT(YEAR FROM date_data) AS year,
	SUM(recovered) AS total_recovered,
	ROUND(AVG(recovered), 2) AS avg_recovered,
	ROUND(VARIANCE(recovered), 2) AS var_recovered,
	ROUND(STDDEV(recovered), 2) AS stddev_recovered
FROM coronavirus
GROUP BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data) 
ORDER BY EXTRACT(YEAR FROM date_data), EXTRACT(MONTH FROM date_data);

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
	country_region, 
	SUM(confirmed) AS total_confirmed
FROM coronavirus
GROUP BY country_region
ORDER BY total_confirmed DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT 
	country_region, 
	SUM(deaths) AS total_deaths
FROM coronavirus
GROUP BY country_region
ORDER BY total_deaths
LIMIT 4;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
	country_region, 
	SUM(recovered) AS total_recovered
FROM coronavirus
GROUP BY country_region
ORDER BY total_recovered DESC
LIMIT 5;
	  
