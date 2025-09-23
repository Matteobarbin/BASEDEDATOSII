-- 1)
EXPLAIN ANALYZE SELECT * FROM address WHERE postal_code IN ('12345','54321');
EXPLAIN ANALYZE SELECT * FROM address WHERE postal_code NOT IN ('12345','54321');
EXPLAIN ANALYZE
SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('12345','54321');

CREATE INDEX idx_postal_code ON address(postal_code);

EXPLAIN ANALYZE SELECT * FROM address WHERE postal_code IN ('12345','54321');
EXPLAIN ANALYZE SELECT * FROM address WHERE postal_code NOT IN ('12345','54321');
EXPLAIN ANALYZE
SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('12345','54321');

-- 2)
EXPLAIN ANALYZE SELECT * FROM actor WHERE first_name = 'PENELOPE';
EXPLAIN ANALYZE SELECT * FROM actor WHERE last_name = 'GUINESS';
EXPLAIN ANALYZE SELECT * FROM actor WHERE first_name LIKE 'A%';
EXPLAIN ANALYZE SELECT * FROM actor WHERE last_name LIKE 'B%';

-- 3)
EXPLAIN ANALYZE SELECT * FROM film WHERE description LIKE '%Epic%';
EXPLAIN ANALYZE SELECT * FROM film WHERE description LIKE '%Action%';
EXPLAIN ANALYZE SELECT * FROM film_text WHERE MATCH(title, description) AGAINST ('Epic' IN NATURAL LANGUAGE MODE);
EXPLAIN ANALYZE SELECT * FROM film_text WHERE MATCH(title, description) AGAINST ('Action' IN NATURAL LANGUAGE MODE);