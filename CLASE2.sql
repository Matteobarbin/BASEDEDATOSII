
CREATE DATABASE imdb;
USE imdb;


CREATE TABLE pelicula (
    id_pelicula INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    anio_de_estreno YEAR NOT NULL
);


CREATE TABLE actor (
    id_actor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL
);


CREATE TABLE actor_de_pelicula (
    id_actor INT,
    id_pelicula INT,
    PRIMARY KEY (id_actor, id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES actor(id_actor) ON DELETE CASCADE,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);


ALTER TABLE pelicula ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE actor ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


INSERT INTO actor (nombre, apellido) VALUES 
('Leonardo', 'DiCaprio'),
('Morgan', 'Freeman'),
('Scarlett', 'Johansson');


INSERT INTO pelicula (titulo, descripcion, anio_de_estreno) VALUES 
('Titanic', 'Una historia de amor en el fatídico viaje del Titanic.', 1997),
('El caballero de la noche', 'Batman enfrenta al Joker en Gotham.', 2008),
('Los Vengadores', 'Los héroes más poderosos de la Tierra se unen.', 2012);

-- Insertar datos en la tabla actor_de_pelicula
INSERT INTO actor_de_pelicula (id_actor, id_pelicula) VALUES 
(1, 1), 
(2, 2),
(3, 3); 