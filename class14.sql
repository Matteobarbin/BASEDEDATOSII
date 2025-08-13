use sakila;  

/*  Clase 14 Matteo Barbini  
1- Write a query that gets all the customers that live in Argentina.  
Show the first and last name in one column, the address and the city.  
*/  

select  
    concat(c.first_name, " ", c.last_name) as Full_name,  
    a.address,  
    cy.city  
from customer c  
inner join address a using(address_id)  
inner join city cy using(city_id)  
inner join country co using(country_id)  
where co.country like 'Argentina';  

/*  Clase 14 Matteo Barbini  
2- Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here:  
https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States.  
Hint: use case.  
*/  

select  
    f.title,  
    lan.name as language,  
    case f.rating  
        when 'G' then 'G (General Audiences) – All ages admitted.'  
        when 'PG' then 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'  
        when 'PG-13' then 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'  
        when 'R' then 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'  
        when 'NC-17' then 'C-17 (Adults Only) – No one 17 and under admitted.'  
        else 'NR - Not Rated'  
    end as 'rating description'  
from film f  
inner join language lan using(language_id);  

/*  Clase 14 Matteo Barbini  
3- Write a search query that shows all the films (title and release year) an actor was part of.  
Assume the actor comes from a text box introduced by hand from a web page.  
Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.  
*/  

SET @parametro_busqueda = 'Tom'; -- Ejecutar primero el SET y después la query  

select  
    f.title,  
    f.release_year,  
    concat(a.first_name," ",a.last_name) as Actor  
from film f  
inner join film_actor fa using(film_id)  
inner join actor a using(actor_id)  
where concat(a.first_name," ",a.last_name) like concat('%',upper(@parametro_busqueda),'%');  

/*  Clase 14 Matteo Barbini  
4- Find all the rentals done in the months of May and June.  
Show the film title, customer name and if it was returned or not.  
There should be returned column with two possible values 'Yes' and 'No'.  
*/  

select  
    f.title,  
    concat(c.first_name," ",c.last_name) as full_name,  
    case  
        when r.return_date is null then 'No'  
        else 'Yes'  
    end as returned  
from rental r  
inner join inventory i using(inventory_id)  
inner join film f using(film_id)  
inner join customer c using(customer_id)  
where month(r.rental_date) = 5 or month(r.rental_date) = 6;  

/*  Clase 14 Matteo Barbini  
5- Investigate CAST and CONVERT functions.  
Explain the differences if any, write examples based on sakila DB.  

Cast es la funcion estandar de SQL, mientras que convert es propia de MySQL.  
Ambas sirven para convertir el tipo de dato, por ej: de int a varchar, o de date a varchar.  
*/  

-- Usando Cast  
select f.title, cast(f.rating as char) as rating_text  
from film f;  

-- Usando Convert  
select f.title, convert(f.rating, char) as rating_text  
from film f;  

/*  Clase 14 Matteo Barbini  
6- Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function.  
Explain what they do. Which ones are not in MySql and write usage examples.  

Todas permiten reemplazar el valor cuando este es nulo.  
Ej: si return_date da NULL, se reemplaza por 'No devuelta'.  

IFNULL() → Sí está en MySQL. Sintaxis: ifnull(valor, reemplazo)  
COALESCE() → Sí está en MySQL, es estándar. Sintaxis: coalesce(valor1, valor2, ...) devuelve el primer valor no nulo.  
ISNULL() → No está como función en MySQL (solo como operador IS NULL).  
NVL() → No está en MySQL, solo en Oracle (en MySQL se usa IFNULL()).  
*/  

-- Usando ifnull()  
select  
    f.title,  
    concat(c.first_name," ",c.last_name) as full_name,  
    ifnull(return_date, "No devuelta") as 'fecha devuelta'  
from rental r  
inner join inventory i using(inventory_id)  
inner join film f using(film_id)  
inner join customer c using(customer_id)  
where return_date is null;  

-- Usando coalesce()  
select  
    f.title,  
    concat(c.first_name," ",c.last_name) as full_name,  
    coalesce(return_date, "No devuelta") as 'fecha devuelta'  
from rental r  
inner join inventory i using(inventory_id)  
inner join film f using(film_id)  
inner join customer c using(customer_id)  
where return_date is null;  
