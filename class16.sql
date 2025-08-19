
-- CONSTRAINTS Y TRIGGERS - ejercicios


-- creo tabla employees
drop table if exists employees;
create table employees (
    employeeNumber int primary key auto_increment,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
    email varchar(100) not null unique, -- no puede ser null y tampoco repetido
    jobTitle varchar(50)
);

-- cargo algunos datos
insert into employees (firstName, lastName, email, jobTitle)
values
('John','Doe','john.doe@email.com','Manager'),
('Jane','Smith','jane.smith@email.com','Assistant');


-- 1) insert con null

-- esto tira error porque email es not null
-- insert into employees (firstName,lastName,email,jobTitle)
-- values ('Carlos','Perez',null,'Intern');


-- 2) updates raros

-- si resto 20 al employeeNumber puede haber conflicto con la PK
update employees set employeeNumber = employeeNumber - 20;
-- tira error por clave duplicada o valor inválido

-- si le sumo 20 anda bien porque todos los numeros siguen siendo unicos
update employees set employeeNumber = employeeNumber + 20;


-- 3) columna age con check

alter table employees add age int check (age between 16 and 70);

-- probando
-- insert into employees (firstName,lastName,email,jobTitle,age)
-- values ('Mario','Lopez','mario@email.com','Staff',25); -- ok
-- insert into employees (firstName,lastName,email,jobTitle,age)
-- values ('Ana','Gomez','ana@email.com','Intern',12); -- no deja


-- 4) integridad film / actor / film_actor

-- en sakila:
-- film tiene film_id como PK
-- actor tiene actor_id como PK
-- film_actor junta las dos con foreign keys (film_id y actor_id)
-- asi no se puede meter un actor o film que no exista, mantiene la integridad


-- 5) triggers de lastUpdate y lastUpdateUser

alter table employees add lastUpdate datetime;
alter table employees add lastUpdateUser varchar(50);

delimiter $$

create trigger emp_insert
before insert on employees
for each row
begin
  set new.lastUpdate = now();
  set new.lastUpdateUser = user();
end$$

create trigger emp_update
before update on employees
for each row
begin
  set new.lastUpdate = now();
  set new.lastUpdateUser = user();
end$$

delimiter ;


-- 6) triggers de sakila en film_text

-- hay 3: insert, update y delete
-- sirven para mantener film_text sincronizado con film
-- insert: mete el registro en film_text cuando entra uno nuevo en film
-- update: actualiza titulo y descripcion en film_text si cambian en film
-- delete: borra de film_text si se borra de film
