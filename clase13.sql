INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
SELECT 1, 'Juan', 'Pérez', 'juan.perez@email.com', a.address_id, 1, NOW()
FROM address a
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'United States'
ORDER BY a.address_id DESC
LIMIT 1;

-- Agregar un alquiler
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
SELECT NOW(), 
       (SELECT inventory_id FROM inventory i 
        JOIN film f ON i.film_id = f.film_id
        WHERE f.title = 'ACADEMY DINOSAUR'
        ORDER BY i.inventory_id DESC LIMIT 1),
       (SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
       (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1);

-- Actualizar el año de las películas según el rating
UPDATE film
SET release_year = CASE rating
    WHEN 'G' THEN 2001
    WHEN 'PG' THEN 2002
    WHEN 'PG-13' THEN 2003
    WHEN 'R' THEN 2004
    WHEN 'NC-17' THEN 2005
    ELSE release_year
END;

-- Devolver una película
UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
    SELECT r.rental_id
    FROM rental r
    WHERE r.return_date IS NULL
    ORDER BY r.rental_date DESC
    LIMIT 1
);

-- Intentar borrar una película
-- Esto fallará si hay dependencias (rental, inventory, film_actor, etc.)
-- Solución: eliminar en orden dependencias antes de eliminar la película

-- Suponiendo que el título es 'ACADEMY DINOSAUR'
SET @film_id := (SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR');

DELETE FROM payment
WHERE rental_id IN (
    SELECT rental_id FROM rental
    WHERE inventory_id IN (
        SELECT inventory_id FROM inventory WHERE film_id = @film_id
    )
);

DELETE FROM rental
WHERE inventory_id IN (
    SELECT inventory_id FROM inventory WHERE film_id = @film_id
);

DELETE FROM inventory WHERE film_id = @film_id;
DELETE FROM film_actor WHERE film_id = @film_id;
DELETE FROM film_category WHERE film_id = @film_id;
DELETE FROM film WHERE film_id = @film_id;

-- Alquilar una película
-- Paso 1: Obtener un inventory_id disponible
-- (se usa directamente en la consulta como instruido)
-- Supongamos que el ID es 1234 (reemplazar por uno válido si es necesario)

-- Paso 2: Agregar entrada en rental
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    1234,
    (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1),
    (SELECT staff_id FROM staff ORDER BY RAND() LIMIT 1)
);

-- Paso 3: Agregar entrada en payment
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1),
    (SELECT staff_id FROM staff ORDER BY RAND() LIMIT 1),
    (SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1),
    5.99,
    NOW()
);