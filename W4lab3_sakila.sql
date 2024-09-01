-- 1)

USE sakila;

SHOW tables;

-- You need to use SQL built-in functions to gain insights relating to the duration of movies:

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.

SELECT 
    MAX(length) AS max_duration,
    MIN(length) AS min_duration
FROM sakila.film;

SELECT title, length AS max_duration, NULL AS min_duration
FROM sakila.film
WHERE length = (SELECT MAX(length) FROM sakila.film)
UNION
SELECT title, NULL AS max_duration, length AS min_duration
FROM sakila.film
WHERE length = (SELECT MIN(length) FROM sakila.film);

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions.

SELECT 
    FLOOR(AVG(length) / 60) AS avg_hours,
    MOD(FLOOR(AVG(length)), 60) AS avg_minutes
FROM sakila.film;



-- You need to gain insights related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.

SELECT * from sakila.rental

SELECT 
    DATEDIFF(MAX(rental_date), MIN(rental_date)) AS days_operating
FROM sakila.rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.

SELECT * from sakila.rental

SELECT *, DATE_FORMAT(CONVERT(rental_date, DATE), '%M') as month, DATE_FORMAT(CONVERT(rental_date, DATE), '%D') as day
FROM sakila.rental
LIMIT 20;


-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.

SELECT *, DATE_FORMAT(CONVERT(rental_date, DATE), '%M') as month, DATE_FORMAT(CONVERT(rental_date, DATE), '%D') as day, DAYNAME(rental_date) AS day_of_week
FROM sakila.rental
LIMIT 20;

SELECT *, DATE_FORMAT(CONVERT(rental_date, DATE), '%M') as month, DATE_FORMAT(CONVERT(rental_date, DATE), '%D') as day, DAYNAME(rental_date) AS day_of_week
CASE
	WHEN DAYNAME(rental_date) = 'Sunday' then 'weekend'
    WHEN DAYNAME(rental_date) = 'Saturday' then 'weekend'
    ELSE 'weekday'
END as DAY_TYPE,
FROM sakila.rental
LIMIT 20;

SELECT 
    *,
    DATE_FORMAT(rental_date, '%M') AS month,
    DATE_FORMAT(rental_date, '%D') AS day,
    DAYNAME(rental_date) AS day_of_week,
    CASE
        WHEN DAYNAME(rental_date) IN ('Sunday', 'Saturday') THEN 'weekend'
        ELSE 'weekday'
    END AS day_type
FROM 
    sakila.rental
LIMIT 20;



-- 3) You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.

SELECT title, IFNULL(rental_duration,'not available') as rental_duration FROM sakila.film
ORDER BY rental_duration ASC;

-- Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
-- To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. 
-- The results should be ordered by last name in ascending order to make it easier to use the data.

SELECT * from sakila.customer;

SELECT email, first_name, last_name,
LEFT (email,3) as short_email
FROM sakila.customer;

SELECT *,
CONCAT(first_name,last_name) as concat_cust
FROM sakila.customer;



SELECT 
    email, 
    first_name, 
    last_name,
    LEFT(email, 3) AS short_email,
    CONCAT(first_name,' ', last_name) AS full_name
FROM sakila.customer;



-- Challenge 2
-- Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

SELECT COUNT(title)
FROM sakila.film;

-- 1.2 The number of films for each rating.

SELECT 
    rating, 
    COUNT(rating) AS rating_count
FROM sakila.film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

SELECT 
    rating, 
    COUNT(rating) AS rating_count
FROM sakila.film
GROUP BY rating
ORDER BY rating_count DESC;

-- Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.

SELECT
rating,
ROUND(AVG(length),2) as average_duration
FROM sakila.film
GROUP BY rating
ORDER BY average_duration DESC;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.

SELECT rating, AVG(length) AS average_duration
FROM sakila.film
GROUP BY rating
HAVING AVG(length) > 120;


-- Bonus: determine which last names are not repeated in the table actor.

SELECT 
    last_name,
    COUNT(last_name) AS duplicate_count
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) = 1;
