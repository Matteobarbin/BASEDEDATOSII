Use sakila;
SELECT co.country_id, co.country, COUNT(ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id, co.country
ORDER BY co.country, co.country_id;


SELECT co.country, COUNT(ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country
HAVING city_count > 10
ORDER BY city_count DESC;

SELECT 
    cu.first_name,
    cu.last_name,
    a.address,
    COUNT(r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_spent
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN rental r ON cu.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cu.customer_id
ORDER BY total_spent DESC;


SELECT 
    cat.name AS category,
    AVG(f.length) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY avg_duration DESC;


SELECT 
    f.rating,
    SUM(p.amount) AS total_sales
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_sales DESC;
