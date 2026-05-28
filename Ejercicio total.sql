
--02 Muestra los nombres de todas las películas con una clasificación por 
--edades de ‘Rʼ.

select title from film
where rating ='R'

-- 03 Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.

select first_name, actor_id  from actor
where actor_id between 30 and 40

-- 04 Obtén las películas cuyo idioma coincide con el idioma original.

select title from film 
 where original_language_id is not null
 and language_id = original_language_id 
 'No hay resultado porque la columna original_language_id solo tiene valores nulos'
 
 --05 Ordena las películas por duración de forma ascendente.
--

select title, f.length  from film f 
 order by f.length 

 
 --06 Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su 
--apellido.

select a.actor_id, a.first_name, a.last_name  from actor a 
where 'ALLEN' in (a.last_name)

--07 Encuentra la cantidad total de películas en cada clasificación de la tabla 
--“filmˮ y muestra la clasificación junto con el recuento.

select rating,
		count(film_id) as total_peliculas
from film f 
group by rating

--08 Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una 
--duración mayor a 3 horas en la tabla film.

select title from film
where rating = 'PG-13'
or length > 180


--09 Encuentra la variabilidad de lo que costaría reemplazar las películas.

select round(variance(replacement_cost),2) as varianza from film


--10 Encuentra la mayor y menor duración de una película de nuestra BBDD.


select max(length) as max_duracion, 
min(length) as min_duracion
from film


--11 Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select a.rental_id, 
a.rental_date, 
sum(b.amount) as total_pagado
from rental as a
left join payment as b
	on a.rental_id = b.rental_id
group by a.rental_id, b.rental_id
order by a.rental_date desc

--12 Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.

select title from film 
where rating <> 'NC-17' or rating <>'G'


--13 Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
--y muestra la clasificación junto con el promedio de duración.

select rating, 
round(avg(length),2) as promedio
from film f 
group by rating


 --14 Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select title from film
where length >= 180

--15 ¿Cuánto dinero ha generado en total la empresa?

select sum(amount) as total_pagado
from payment

--16 Muestra los 10 clientes con mayor valor de id.

select customer_id, first_name 
from customer 
order by customer_id desc
limit 10

-- 17 Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.

select a.first_name, a.last_name, c.title  from actor as a
left join film_actor as b
	on a.actor_id = b.actor_id
left join film as c
	on b.film_id = c.film_id
where c.title = 'EGG IGBY'


-- 18 Selecciona todos los nombres de las películas únicos.

select distinct title from film f 

--19 Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.

select a.title, c.name from film as a
left join film_category as b
	on a.film_id = b.film_id 
left join category as c
	on b.category_id = c.category_id 
where c.name = 'Comedy'and a.length > 180

-- 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.

select  a.name,
round(avg(c.length),2) as promedio
from category as a
left join film_category as b
	on a.category_id = b.category_id 
left join film as c
	on b.film_id = c.film_id 
group by a.name
order by promedio desc

-- 21 ¿Cuál es la media de duración del alquiler de las películas?

select round(avg(rental_duration), 2) as media_duracion_alquiler
from film

SELECT AVG(return_date::date - rental_date::date)    
FROM rental

-- 22 Crea una columna con el nombre y apellidos de todos los actores y actrices.

Select actor_id, 
concat(first_name,' ', last_name) as nombre_completo
from actor

-- 23 Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

select rental_date::date, count(rental_id) as alquiler_por_dia
from rental 
group by rental_date::date
order by alquiler_por_dia desc

--24 Encuentra las películas con una duración superior al promedio.
select title, length
from film
where length > (
	select avg(length) 
	from film)
	
--25 Averigua el número de alquileres registrados por mes.
	
select extract(month from rental_date) as mes,
count(rental_id) as numero_alquiler
from rental
group by extract(month from rental_date)
order by mes

--26 Encuentra el promedio, la desviación estándar y varianza del total pagado.

select round(avg(amount),2) as media,
round(stddev(amount),2) as desviación,
round(variance(amount),2) as varianza
from payment

--27  ¿Qué películas se alquilan por encima del precio medio?

select a.title, b.amount from film as a
left join inventory as c
	on a.film_id = c.film_id
left join rental as d
	on c.inventory_id = d.inventory_id 
left join payment as b
	on d.rental_id = b.rental_id 
where amount > (
select avg(amount) as promedio
from payment)
order by amount desc


--28 Muestra el id de los actores que hayan participado en más de 40 películas.

select a.actor_id, a.first_name, a.last_name, 
count(c.film_id) as numero_peliculas
from actor as a
left join film_actor as b
	on a.actor_id = b.actor_id 
left join film as c
	on b.film_id = c.film_id
group by a.actor_id 
having count(c.film_id ) > 40

select actor_id,
count(film_id) as numero_peliculas
from film_actor
group by actor_id 
having count(film_id) > 40

--29 Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select a.title, count(b.inventory_id) as cantidad_inventario
from film as a
left join inventory as b
	on a.film_id = b.film_id
group by title 
having count(b.inventory_id) > 0
order by a.title

--30 Obtener los actores y el número de películas en las que ha actuado.

select concat(a.first_name, ' ', a.last_name) as nombre, 
count(c.film_id) as peliculas_actuadas
from actor as a
left join film_actor as b
	on a.actor_id = b.actor_id 
left join film as c
	on b.film_id = c.film_id 
group by nombre

--31 Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select a.title, c.first_name, c.last_name 
from film as a
left join film_actor as b
	on a.film_id = b.film_id
left join actor as c 
	on b.actor_id = c.actor_id 
order by a.title

--32 Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

select concat(a.first_name, ' ', a.last_name) as nombre, 
c.title 
from actor as a
left join film_actor as b
	on a.actor_id = b.actor_id 
left join film as c
	on b.film_id = c.film_id
order by nombre

--33 Obtener todas las películas que tenemos y todos los registros de alquiler.

select a.title, c.rental_id 
from film as a
left join inventory as b
	on a.film_id = b.film_id
left join rental as c
	on b.inventory_id = c.inventory_id
where c.rental_id is not null
order by a.title

--34 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select concat(a.first_name, ' ', a.last_name) as nombre,
sum(b.amount) as total_pagado
from customer as a
left join payment as b
	on a.customer_id = b.customer_id 
group by nombre
order by total_pagado 
limit 5

--35 Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select first_name, last_name from actor
where first_name = 'JOHNNY'

--36 Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.

alter table actor 
rename COLUMN first_name to Nombre;
alter table actor
rename column last_name to Apellido

--37 Encuentra el ID del actor más bajo y más alto en la tabla actor.

select min(actor_id) as id_minimo,
max(actor_id) as id_máximo
from actor

--38 Cuenta cuántos actores hay en la tabla “actorˮ.

select count(actor_id) as cantidad_actores
from actor

--39 Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select nombre, apellido from actor
order by apellido 

--40 Selecciona las primeras 5 películas de la tabla “filmˮ.

select title from film
limit 5

-- 41 Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select distinct nombre, 
count(actor_id) as numero_actores
from actor
group by nombre
order by numero_actores desc 

'Los nombres más repetidos son los de Julia, Kenneth y Penelope'


--42 Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select a.rental_id, b.first_name, b.last_name 
from rental as a
left join customer as b
 on a.customer_id =b.customer_id 

 
--43 Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
 
 select a.first_name, a.last_name, b.rental_id
 from customer as a 
 left join rental as b
 	on a.customer_id =b.customer_id 
 order by a.first_name, a.last_name 
 
 --44 Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

 select a.title, c.name
from film as a
left join film_category as b
	on a.film_id = b.film_id 
cross join category as c

'No, no aporta ningún valor esta consulta porque nos está asociando cada película a todos los tipos de categoría que existen en la tabla "category"'
'Cuando realmenta cada película solo tiene una categoría asociada'

--45 Encuentra los actores que han participado en películas de la categoría 'Action'.

select a.name, e.nombre, e.apellido  
from category as a
right join film_category as b
	on a.category_id = b.category_id 
right join film as c
	on b.film_id = c.film_id 
right join film_actor as d
	on c.film_id = d.film_id 
right join actor as e
	on d.actor_id = e.actor_id 
where a.name = 'Action'
order by e.nombre

--47 Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

select a.nombre, a.apellido, count(b.film_id) as peliculas_participadas
from actor as a
right join film_actor as b
	on a.actor_id = b.actor_id 
group by a.nombre, a.apellido
order by peliculas_participadas desc

--48 Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores 
-- y el número de películas en las que han participado.
create view actor_num_peliculas as
	select a.nombre, a.apellido, count(b.film_id) as peliculas_participadas
	from actor as a
	right join film_actor as b
		on a.actor_id = b.actor_id 
	group by a.nombre, a.apellido
	order by peliculas_participadas desc

-- 49 Calcula el número total de alquileres realizados por cada cliente.

select customer_id, count(rental_id) as n_alquileres
from rental 
group by customer_id
order by n_alquileres desc

-- 50 Calcula la duración total de las películas en la categoría 'Action'.

select a.name, sum(c.length) 
from category as a
right join film_category as b
 on a.category_id = b.category_id 
right join film as c
	on b.film_id = c.film_id 
where a.name = 'Action'
group by a.name

--51 Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.

create temporary table clientes_rentas_temporal as
select customer_id, count(rental_id) as n_alquileres
from rental 
group by customer_id
order by n_alquileres desc,

select * from clientes_rentas_temporal

--52 Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.

create temporary table peliculas_alquiladas as 
select a.title, count(c.rental_id) as n_alquileres
from film as a
right join inventory as b
	on a.film_id = b.film_id 
right join rental as c
	on b.inventory_id = c.inventory_id 
group by a.title 
having count(c.rental_id) >= 10
order by a.title 
	

--53 Encuentra el título de las películas que han sido alquiladas por el cliente 
-- con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena 
--los resultados alfabéticamente por título de película.

select title 
from (
	select a.rental_id, a.return_date, 
	concat(b.first_name, ' ', b.last_name) as nombre,
	a.inventory_id,
	d.title 
	from rental as a
	left join customer as b
		on a.customer_id = b.customer_id
	left join inventory as c
		on a.inventory_id =c.inventory_id 
	left join film as d
		on c.film_id = d.film_id
	where a.return_date is null) as peliculas_no_devueltas
where nombre = 'TAMMY SANDERS'
order by title

--54 Encuentra los nombres de los actores que han actuado en al menos una película 
-- que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.

create temporary table pelicula_categoria as 
select a.film_id, a.title, c.name  
from film as a
left join film_category as b
	on a.film_id = b.film_id
left join category as c
	on b.category_id = c.category_id;
	
create temporary table actor_peliculas as 
select a.actor_id, b.nombre, b.apellido, c.title, a.film_id
from film_actor as a
left join actor as b
	on a.actor_id = b.actor_id
left join film as c
	on a.film_id = c.film_id;

select distinct a.nombre, a.apellido
from actor_peliculas as a
left join pelicula_categoria as b
	on a.film_id = b.film_id
where name = 'Sci-Fi'
order by a.apellido 

	
--55 Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después
--de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados 
-- alfabéticamente por apellido.




select distinct a.nombre, a.apellido 
from  actor as a
right join film_actor as b
	on a.actor_id = b.actor_id 
right join inventory as c
	on b.film_id = c.film_id 
right join rental as d
	on c.inventory_id = d.inventory_id 
where d.rental_date >(--Fecha que se alquiló pro primera vez SPARTACUS CHEAPER
	select min(c.rental_date)  
	from film as a
	right join inventory as b
		on a.film_id = b.film_id 
	right join rental as c
		on b.inventory_id = c.inventory_id 
	where a.title = 'SPARTACUS CHEAPER' 
	)
	
order by a.apellido 


--56 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.

select distinct actor_id, nombre, apellido 
from actor
where actor_id not IN(
	select distinct a.actor_id
	from actor_peliculas as a -- tabla temporal creada en el ejercicio 54
	left join pelicula_categoria as b -- tabla temporal creada en el ejercicio 54
		on a.film_id = b.film_id
	where name = 'Music'
	)
order by nombre, apellido

--57 Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

select dias_alquiler, title
from(select (a.return_date::date - a.rental_date::date) as dias_alquiler, c.title 
				from rental as a
				left join inventory as b
					on a.inventory_id = b.inventory_id
				left join film as c
					on b.film_id = c.film_id) as alquileres
where dias_alquiler > 8
order by dias_alquiler desc


--58 Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.

'create temporary table pelicula_categoria as 
select a.film_id, a.title, c.name  
from film as a
left join film_category as b
	on a.film_id = b.film_id
left join category as c
	on b.category_id = c.category_id;'

select  title from pelicula_categoria
where name = 'Animation'


--59 Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. 
--Ordena los resultados alfabéticamente por título de película.

select title from film 
where length =(
	select length from film
	where title = 'DANCING FEVER')
order by title


--60 Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas.
-- Ordena los resultados alfabéticamente por apellido.


select a.customer_id, c.first_name, c.last_name, count(distinct b.film_id) as n_peliculas_alquiladas
from rental as a --(select a.rental_id, a.customer_id, b.inventory_id, b.film_id
left join inventory as b
	on a.inventory_id = b.inventory_id
left join customer as c
	on a.customer_id = c.customer_id 	
group by a.customer_id, c.first_name, c.last_name 
having count(distinct b.film_id) >=7
order by c.last_name 

--61 Encuentra la cantidad total de películas alquiladas por categoría y 
-- muestra el nombre de la categoría junto con el recuento de alquileres.

select a.name, count(b.film_id) as n_alquileres 
from category as a
right join film_category as b
	on a.category_id = b.category_id 
right join inventory as c
	on b.film_id = c.film_id 
right join rental as d
	on c.inventory_id = d.inventory_id 
group by a.name
order by n_alquileres desc

--62  Encuentra el número de películas por categoría estrenadas en 2006.
with ventas_2006 as(
	select film_id, title 
	from film 
	where release_year = 2006
)
select b.name, Count(c.film_id) as n_peliculas
from film_category as a
left join category as b
	on a.category_id = b.category_id 
left join ventas_2006 as c
	on a.film_id = c.film_id 
group by b.name
order by n_peliculas desc
	
'select b.name, Count(a.film_id) as n_peliculas
from film_category as a
left join category as b
	on a.category_id = b.category_id 
left join film as c
	on a.film_id = c.film_id 
where c.release_year = 2006
group by b.name
order by n_peliculas desc'

--63 Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.


select * 
from store as a
cross join staff as b


--64 Encuentra la cantidad total de películas alquiladas por cada cliente y 
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
--películas alquiladas.

select a.customer_id, c.first_name, c.last_name, count(distinct b.film_id) as n_peliculas_alquiladas
from rental as a 
left join inventory as b
	on a.inventory_id = b.inventory_id
left join customer as c
	on a.customer_id = c.customer_id 	
group by a.customer_id, c.first_name, c.last_name 

