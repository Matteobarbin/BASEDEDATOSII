/******************************
1️⃣ FUNCIÓN: obtener_copias_pelicula
******************************/

DELIMITER //
CREATE FUNCTION obtener_copias_pelicula(film_ref VARCHAR(100), id_tienda INT)
RETURNS INT
DETERMINISTIC
BEGIN
    /*
       Esta función devuelve cuántas copias de una película hay en una tienda.
       Puede recibir como primer parámetro el ID de la película o su título.
    */
    DECLARE cantidad INT DEFAULT 0;

    SELECT COUNT(inv.inventory_id)
    INTO cantidad
    FROM inventory inv
    INNER JOIN film f ON inv.film_id = f.film_id
    WHERE inv.store_id = id_tienda
      AND (f.film_id = film_ref OR f.title = film_ref);

    RETURN cantidad;
END//
DELIMITER ;

-- 🔹 EJEMPLOS DE USO:
SELECT obtener_copias_pelicula(2, 1) AS total_por_id;
SELECT obtener_copias_pelicula('ACE GOLDFINGER', 2) AS total_por_nombre;



/******************************
2️⃣ PROCEDIMIENTO: clientes_en_pais
******************************/

DELIMITER //
CREATE PROCEDURE clientes_en_pais(
    IN nombre_pais VARCHAR(50),
    OUT resultado TEXT
)
BEGIN
    /*
       Este procedimiento genera una lista con los nombres completos
       de los clientes que viven en el país indicado.
       Usa un CURSOR para recorrer cada registro.
    */

    DECLARE terminado INT DEFAULT 0;
    DECLARE nom VARCHAR(45);
    DECLARE ape VARCHAR(45);
    DECLARE lista TEXT DEFAULT '';

    DECLARE cur_clientes CURSOR FOR
        SELECT c.first_name, c.last_name
        FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = nombre_pais;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;

    OPEN cur_clientes;
    leer: LOOP
        FETCH cur_clientes INTO nom, ape;
        IF terminado THEN
            LEAVE leer;
        END IF;
        SET lista = CONCAT(lista, nom, ' ', ape, '; ');
    END LOOP;
    CLOSE cur_clientes;

    SET resultado = lista;
END//
DELIMITER ;

-- 🔹 EJEMPLOS DE USO:
CALL clientes_en_pais('Canada', @lista);
SELECT @lista AS clientes_en_Canada;



/******************************
3️⃣ REVISIÓN DE FUNCIONES Y PROCEDIMIENTOS EXISTENTES EN SAKILA
******************************/

/* ✅ FUNCIÓN: inventory_in_stock
   Esta función indica si un ítem del inventario está disponible (TRUE)
   o alquilado actualmente (FALSE).
*/

-- CÓDIGO ORIGINAL:
DELIMITER //
CREATE FUNCTION inventory_in_stock(p_inventory_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE cantidad_alquileres INT;
    DECLARE sin_devolver INT;

    SELECT COUNT(*) INTO cantidad_alquileres
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF cantidad_alquileres = 0 THEN
        RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO sin_devolver
    FROM rental
    WHERE inventory_id = p_inventory_id
      AND return_date IS NULL;

    IF sin_devolver > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END//
DELIMITER ;

-- 🔹 EXPLICACIÓN:
-- Comprueba si un artículo fue alquilado y si fue devuelto o no.
-- TRUE → disponible
-- FALSE → aún alquilado

-- 🔹 EJEMPLO DE USO:
SELECT inventory_in_stock(10);


/* ✅ PROCEDIMIENTO: film_in_stock
   Devuelve las copias de una película disponibles en una tienda
   y la cantidad total por parámetro de salida.
*/

-- CÓDIGO ORIGINAL:
DELIMITER //
CREATE PROCEDURE film_in_stock(
    IN film_id_in INT,
    IN store_id_in INT,
    OUT cantidad INT
)
READS SQL DATA
BEGIN
    SELECT inventory_id
    FROM inventory
    WHERE film_id = film_id_in
      AND store_id = store_id_in
      AND inventory_in_stock(inventory_id);

    SELECT FOUND_ROWS() INTO cantidad;
END//
DELIMITER ;

-- 🔹 EXPLICACIÓN:
-- 1. Busca todas las copias del film.
-- 2. Filtra solo las disponibles con inventory_in_stock().
-- 3. Guarda el número de copias en el parámetro de salida.

-- 🔹 EJEMPLOS DE USO:
CALL film_in_stock(3, 1, @copias);
SELECT @copias AS cantidad_disponible;

-----------------------------------------------------------------------------------------
-- FIN DEL DOCUMENTO (versión alternativa)
-----------------------------------------------------------------------------------------