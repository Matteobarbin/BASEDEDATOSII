use sakila;
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name IN (
    SELECT last_name
    FROM actor
    GROUP BY last_name
    HAVING COUNT(*) > 1
)
ORDER BY last_name, first_name;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT DISTINCT actor_id FROM film_actor
);

SELECT r.customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY r.customer_id
HAVING COUNT(DISTINCT f.film_id) = 1;

SELECT r.customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY r.customer_id
HAVING COUNT(DISTINCT f.film_id) > 1;


SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD');


SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR'
AND a.actor_id NOT IN (
    SELECT a2.actor_id
    FROM actor a2
    JOIN film_actor fa2 ON a2.actor_id = fa2.actor_id
    JOIN film f2 ON fa2.film_id = f2.film_id
    WHERE f2.title = 'CATCH AMISTAD'
);


SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa1.actor_id
    FROM film_actor fa1
    JOIN film f1 ON fa1.film_id = f1.film_id
    WHERE f1.title = 'BETRAYED REAR'
)
AND a.actor_id IN (
    SELECT fa2.actor_id
    FROM film_actor fa2
    JOIN film f2 ON fa2.film_id = f2.film_id
    WHERE f2.title = 'CATCH AMISTAD'
);


SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);
