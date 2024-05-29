/* Question Set 1 - Easy */

/* Q1. Who is the senior most employee based on job title? */

SELECT first_name, last_name, title FROM employee
ORDER BY levels DESC
LIMIT 1;


/* Q2. Which countries have the most invoices? */

SELECT COUNT (*) AS Number_of_invoices, billing_country FROM invoice
GROUP BY billing_country
ORDER BY Number_of_invoices DESC;


/* Q3. What are top 3 values of total invoice? */

SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3;


/* Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city
that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals. */

SELECT billing_city, SUM (total) AS Invoice_total FROM invoice
GROUP BY billing_city
ORDER BY Invoice_total DESC
LIMIT 1;


/* Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the
most money. */

SELECT first_name, last_name, SUM (total) AS Total_spent FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY first_name, last_name
ORDER BY Total_spent DESC
LIMIT 1;




/* Question Set 2 - Moderate */

/* Q1. Write query to return the email, first name, last name, & genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre_name FROM customer AS c
JOIN invoice AS i
ON c.customer_id = i.customer_id
JOIN invoice_line AS il
ON i.invoice_id = il.invoice_id
JOIN track AS t
ON il.track_id = t.track_id
JOIN genre AS g
ON t.genre_id = g.genre_id
WHERE g.name IN ('Rock')
ORDER BY email;


/* Q2. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the artist name and total track count of the top 10
rock bands. */

SELECT artist.name AS Artist_name, COUNT (artist.artist_id) AS Number_of_songs FROM artist
JOIN album
ON artist.artist_id = album.artist_id
JOIN track
ON album.album_id = track.album_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
GROUP BY Artist_name
ORDER BY Number_of_songs DESC
LIMIT 10;


/* Q3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song
length with the longest songs listed first. */

SELECT name, milliseconds FROM track
WHERE milliseconds > (SELECT AVG (milliseconds) AS Avg_track_length FROM track)
ORDER BY milliseconds DESC;




/* Question Set 3 - Advance */

/* Q1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent. */

SELECT c.first_name, c.last_name, ar.name AS artist_name, SUM (il.unit_price * il.quantity) AS total_spent FROM customer AS c
JOIN invoice AS i
ON c.customer_id = i.customer_id
JOIN invoice_line AS il
ON i.invoice_id = il.invoice_id
JOIN track AS t
ON il.track_id = t.track_id
JOIN album AS al
ON t.album_id = al.album_id
JOIN artist AS ar
ON al.artist_id = ar.artist_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;


/* Q2. We want to find out the most popular Music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write
a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres. */

WITH popular_genre AS (
    SELECT c.country, g.name AS genre_name, COUNT (il.quantity) AS purchases,
    ROW_NUMBER () OVER (PARTITION BY c.country ORDER BY COUNT (il.quantity) DESC) AS Row_number 
    FROM customer AS c 
    JOIN invoice AS i
    ON c.customer_id = i.customer_id
    JOIN invoice_line AS il
    ON i.invoice_id = il.invoice_id
    JOIN track AS t
    ON il.track_id = t.track_id
    JOIN genre AS g
    ON t.genre_id = g.genre_id
    GROUP BY 1, 2
    ORDER BY 1 ASC, 3 DESC )
SELECT * FROM popular_genre
WHERE Row_number <= 1;


/* Q3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer
and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH customer_and_country AS (
    SELECT billing_country, first_name, last_name, SUM (total) AS total_amount_spent,
    ROW_NUMBER () OVER (PARTITION BY billing_country ORDER BY SUM (total) DESC) AS Row_number
    FROM customer
    JOIN invoice
    ON customer.customer_id = invoice.customer_id
    GROUP BY 1, 2, 3
    ORDER BY 1 ASC, 5 DESC )
SELECT * FROM customer_and_country
WHERE Row_number <= 1;


/* Thank You :) */