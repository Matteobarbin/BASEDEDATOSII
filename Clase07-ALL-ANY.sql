Use sakila;
#1 --
SELECT title, rating
  FROM film
 WHERE length = (SELECT MIN(length) FROM film);
 
 #2 --
SELECT title 
  FROM film 
 WHERE length = (SELECT MIN(length) FROM film)
   AND NOT EXISTS (
      SELECT 1
        FROM film f2
       WHERE f2.length = (SELECT MIN(length) FROM film)
         AND f2.film_id <> film.film_id);
 
 #3 --
 
 SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    MIN(p.amount) AS lowest_payment
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
JOIN 
    address a ON c.address_id = a.address_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, a.address;
    
#4 --
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    MIN(p.amount) AS min_payment,
    MAX(p.amount) AS max_payment
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name;
