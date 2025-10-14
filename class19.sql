-- 1) Crear el usuario 'data_analyst' y otorgarle permisos limitados
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'AnalystP@ssw0rd';
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'data_analyst'@'localhost';

-- Salida esperada:
-- GRANT SELECT, UPDATE, DELETE ON `sakila`.* TO 'data_analyst'@'localhost'


-- 2) Iniciar sesión con 'data_analyst' e intentar crear una tabla (debe fallar)
-- mysql -u data_analyst -p -h localhost sakila
CREATE TABLE sakila.test_table (
  id INT PRIMARY KEY
);

-- Resultado esperado:
-- ERROR 1044 (42000): Access denied for user 'data_analyst'@'localhost' to database 'sakila'


-- 3) Actualizar el título de una película (funciona)
UPDATE sakila.film
SET title = 'El Gran Cambio'
WHERE film_id = 1;

SELECT film_id, title FROM sakila.film WHERE film_id = 1;

-- Resultado esperado:
-- +---------+-----------------+
-- | film_id | title           |
-- +---------+-----------------+
-- |       1 | El Gran Cambio  |
-- +---------+-----------------+


-- 4) Revocar el permiso UPDATE desde root
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'data_analyst'@'localhost';

-- Resultado esperado:
-- GRANT SELECT, DELETE ON `sakila`.* TO 'data_analyst'@'localhost'


-- 5) Intentar actualizar nuevamente (debe fallar)
-- mysql -u data_analyst -p -h localhost sakila
UPDATE sakila.film
SET title = 'Intento Fallido'
WHERE film_id = 1;

-- Resultado esperado:
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
