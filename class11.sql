
use sakila;
-- 🔹 1. Find all the film titles that are not in the inventory
SELECT title as titulo
FROM film
WHERE film_id NOT IN (
    SELECT DISTINCT film_id
    FROM inventory
);

-- 2 Find all the films that are in the inventory but were never rented
-- Mostrar title e inventory_id
-- (Usamos LEFT JOIN y buscamos NULL en la tabla rental)
SELECT f.title, i.inventory_id
FROM inventory i
JOIN film f ON i.film_id = f.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;
-- 3. Reporte con:
-- Nombre del cliente (first, last), store_id, título de la película, cuándo fue alquilada y devuelta,
-- ordenado por store_id y apellido del cliente.
SELECT 
    c.first_name AS customer_first,
    c.last_name AS customer_last,
    cu.store_id,
    f.title,
    r.rental_date,
    r.return_date
FROM rental r
JOIN customer cu ON r.customer_id = cu.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY cu.store_id, c.last_name;

-- 4. Show sales per store (dinero generado por alquileres)
SELECT 
    s.store_id,
    SUM(p.amount) AS total_sales
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id;

-- 5. Mostrar:
-- Ciudad, país, info del gerente y total de ventas de cada tienda
-- (Usamos CONCAT() para mostrar nombres compuestos)
SELECT 
    CONCAT(ci.city, ', ', co.country) AS location,
    CONCAT(st.first_name, ' ', st.last_name) AS manager_name,
    SUM(p.amount) AS total_sales
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN staff st ON s.manager_staff_id = st.staff_id
JOIN staff st2 ON s.store_id = st2.store_id
JOIN payment p ON st2.staff_id = p.staff_id
GROUP BY s.store_id;
