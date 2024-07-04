-- Clase 1 a la 12

SELECT *
FROM  (
	select ROW_NUMBER() OVER() as ROW_ID, *
	from platzi.alumnos 
) as ALUMNOS_WITH_ROW_NUM
where ROW_ID between 1 AND 5
;

select *
from platzi.alumnos
limit 5;

select *
from PLATZI.alumnos 
fetch first 5 rows only;

select distinct COLEGIATURA
from platzi.alumnos as A1
where 2 = (
	select COUNT (distinct colegiatura)
	from platzi.alumnos A2
	where A1.colegiatura <= A2.COLEGIATURA
)
;

select distinct COLEGIATURA, tutor_id 
from platzi.alumnos
where TUTOR_ID = 20
order by colegiatura desc 
limit 1  offset 1;

select *
from platzi.alumnos as DATOS_ALUMNOS
inner join (
	select distinct colegiatura
	from platzi.alumnos A2
	where tutor_id =20
	order by colegiatura desc 
	limit 1 offset 1
) as SEGUNDA_MAYOR_COLEGIATURA
on datos_alumnos.colegiatura = SEGUNDA_MAYOR_COLEGIATURA.COLEGIATURA
;

select *
from platzi.alumnos as DATOS_ALUMNOS
where colegiatura = (
	select distinct colegiatura
	from platzi.alumnos
	where tutor_id =20
	order by colegiatura desc 
	limit 1 offset 1
) 
;

select *
from platzi.alumnos
order by id  
limit 500 offset 500 ;

select *
from platzi.alumnos 
offset (select(count(id)/2) from platzi.alumnos)
;

select row_number() over() as row_id, *
from platzi.alumnos 
offset (
	select count (*)/2
	from platzi.alumnos 
);



-- Reto clase 12
select  *
from platzi.alumnos 
where id not in (
	select  id 
	from platzi.alumnos
	where tutor_id = 30
);

-- Clase 13

select extract (year from fecha_incorporacion) as anio_incorporacion
from platzi.alumnos;

select *
from platzi.alumnos;

select  date_part('year', fecha_incorporacion) as anio_incorporacion
from platzi.alumnos;

select  date_part('year', fecha_incorporacion) as anio_incorporacion,
	date_part('month', fecha_incorporacion) as mes_incorporacion,
	date_part('day', fecha_incorporacion) as dia_incorporacion
from platzi.alumnos;

-- Reto Clase 13 sacar el detalle de la hora

select  date_part('hour', fecha_incorporacion) as hora_incorporacion,
	date_part('minutes', fecha_incorporacion) as minutos_incorporacion,
	date_part('seconds', fecha_incorporacion) as segundos_incorporacion
from platzi.alumnos;

-- Clase 14

select *
from platzi.alumnos
where  (extract(year from fecha_incorporacion)) = 2019;

select *
from platzi.alumnos 
where date_part('year', fecha_incorporacion) = 2018; 

select *
from (
	select * ,
		date_part('year', fecha_incorporacion) as anio_incorporacion
	from platzi.alumnos
) as alumnos_con_anio
where (anio_incorporacion) = 2020
;

-- Reto Clase 14 Filtrar los alumnos de Mayo 2018

select *
from (
	select * ,
		date_part('year', fecha_incorporacion) as anio_incorporacion,
		date_part('month', fecha_incorporacion) as mes_incorporacion
	from platzi.alumnos
) as alumnos_con_anio_mes
where (anio_incorporacion) = 2020 and mes_incorporacion = 5
;

-- Clase 15 Duplicados

-- a continuacion coment con el query para agregar el duplicado con fines del ejercicio
--insert into platzi.alumnos (id, nombre, apellido, email, colegiatura, fecha_incorporacion, carrera_id, 
--tutor_id) values (1001, 'Pamelina', null, 'pmylchreestrr@salon.com', 4800, '2020-04-26 10:18:51', 12, 16);

select *
from  platzi.alumnos as ou
where (
	select count(*)
	from platzi.alumnos as inr
	where ou.id = inr.id
) > 1;


-- Hash text --
SELECT (platzi.alumnos.*)::text, COUNT(*)
FROM platzi.alumnos
GROUP BY platzi.alumnos.*
HAVING COUNT(*) > 1;

-- Hash excluyendo ID --
SELECT (
	platzi.alumnos.nombre,
	platzi.alumnos.apellido,
	platzi.alumnos.email,
	platzi.alumnos.colegiatura,
	platzi.alumnos.fecha_incorporacion,
	platzi.alumnos.carrera_id,
	platzi.alumnos.tutor_id
	)::text, COUNT(*)
FROM platzi.alumnos
GROUP BY platzi.alumnos.nombre,
	platzi.alumnos.apellido,
	platzi.alumnos.email,
	platzi.alumnos.colegiatura,
	platzi.alumnos.fecha_incorporacion,
	platzi.alumnos.carrera_id,
	platzi.alumnos.tutor_id
HAVING COUNT(*) > 1;

-- Partición por todos los campos excepto ID --
SELECT	*
FROM (
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
			nombre,
			apellido,
			email,
			colegiatura,
			fecha_incorporacion,
			carrera_id,
			tutor_id
		ORDER BY id asc
	) AS row,
	*
	FROM platzi.alumnos
) duplicados
WHERE duplicados.row > 1;

--Reto clase 15 borrar el dato duplicado

delete  from platzi.alumnos 
where id in (
	select id
	FROM (
		SELECT id,
		ROW_NUMBER() OVER(
			PARTITION BY
				nombre,
				apellido,
				email,
				colegiatura,
				fecha_incorporacion,
				carrera_id,
				tutor_id
			ORDER BY id asc
		) AS row,
		FROM platzi.alumnos
	) as duplicados
	WHERE duplicados.row > 1
);

-- Clase 16 Selectores de Rango

select *
from platzi.alumnos 
where  tutor_id IN(1,2,3,4);

select *
from platzi.alumnos 
where tutor_id >= 1
	and tutor_id <=11;

select *
from platzi.alumnos 
where tutor_id between 1 and 10;

select *
from platzi.alumnos
where  tutor_id between 1 and 10;

select int4range(10, 20) @> 3;

select numrange(11.1, 22.2) && numrange (20.0, 30.0);

select upper(int8range(15,25));

select lower(int8range(15,25));

select int4range(10,20) * int4range(15, 25);

select isempty (numrange(1,5));

select *
from platzi.alumnos
where int4range(1, 20) @> tutor_id ;

-- Reto Clase 16 seleccionar * los datos que se encuentren en la interseccion tutor_id y id_carrera  

select numrange(
	(select min(tutor_id) from platzi.alumnos),
	(select max(tutor_id) from platzi.alumnos)
) * numrange(
	(select min(carrera_id) from platzi.alumnos),
	(select max(carrera_id) from platzi.alumnos)
);

-- Clase 17 minimos y maximos de una tabla

select fecha_incorporacion
from platzi.alumnos 
order by fecha_incorporacion  desc 
limit 1;

select CARRERA_ID, MAX(FECHA_INCORPORACION)
from platzi.alumnos 
group by carrera_id 
order by carrera_id ;

-- RETO 1 clase 17 sacar el minimo nombre por id tutor

select tutor_id, MIN(nombre)
from platzi.alumnos 
group by tutor_id 
order by tutor_id ;

-- RETO 2 clase 17 sacar el minimo nombre de toda la tabla.

select MIN(nombre)
from platzi.alumnos ;

--Clase 18 Selfish

select  a.nombre,
		a.apellido,
		t.nombre,
		t.apellido
from platzi.alumnos as a
	inner join platzi.alumnos as t on a.tutor_id = t.ID;

select 
		-- concat(a.nombre, ' ', a.apellido) as alumno,
		concat(t.nombre, ' ', t.apellido) as tutor,
		count(*) as alumnos_por_tutor
from platzi.alumnos as a
	inner join platzi.alumnos as t on a.tutor_id = t.ID
group by tutor
order by alumnos_por_tutor desc
limit 10;

--Reto Clase 18 buscar el promedio de alumnos por tutor
select avg(alumnos_por_tutor) as promedio_alumnos_por_tutor
from (
	select 
			-- concat(a.nombre, ' ', a.apellido) as alumno,
			concat(t.nombre, ' ', t.apellido) as tutor,
			count(*) as alumnos_por_tutor
	from platzi.alumnos as a
		inner join platzi.alumnos as t on a.tutor_id = t.ID
	group by tutor
) as alumnos_tutor
;

-- Clase 19 resolviendo diferencias

select carrera_id, count(*) as cuenta
from platzi.alumnos
group by carrera_id 
order by cuenta desc;

-- borrado para efectos del caso
--delete from platzi.carreras
--where id between 30 and 40;

select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	left join platzi.carreras as c
	on a.carrera_id  = c.id 
where c.id is null 
order by a.carrera_id ;

-- Reto 1 clase 19 no excluir ningun dato de la tabla Alumnos

select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	left join platzi.carreras as c
	on a.carrera_id  = c.id 
order by a.carrera_id ;

-- Reto 2 clase 19 no excluir ningun dato de ambas tablas

select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	full outer join platzi.carreras as c
	on a.carrera_id  = c.id 
order by a.carrera_id ;

-- Clase 20 JOINS

-- left join exclusivo
select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	left join platzi.carreras as c
	on a.carrera_id = c.id
where c.id is null;

-- left join inclusivo
select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	left join platzi.carreras as c
	on a.carrera_id = c.id
order by c.id desc;

-- righ join 

select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	right join platzi.carreras as c
	on a.carrera_id = c.id
order by c.id desc;

-- righ join exclusivo
select 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	right join platzi.carreras as c
	on a.carrera_id = c.id
where a.id is null
order by c.id desc;

--  join por default o inner join 
select
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	inner join platzi.carreras as c
	on a.carrera_id = c.id
order by c.id desc;

--  full outer join (sin contar lo que tengan en comun)
select
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	full outer join platzi.carreras as c
	on a.carrera_id = c.id
where a.id is null or c.id is null 
order by a.carrera_id desc, c.id desc;

--  full outer join (contando lo que tengan en comun)
select
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
from platzi.alumnos as a
	full outer join platzi.carreras as c
	on a.carrera_id = c.id
order by c.id desc;

--Clase 21 Triangulando con LPAD 

select lpad('sql', 15, '*');

select lpad('sql', id, '*')
from platzi.alumnos 
where id < 10;

select lpad('*', id, '*'), carrera_id 
from platzi.alumnos 
where id < 10
order by carrera_id ;

select lpad('*', cast(row_id as int), '*')
from (
	select row_number() over(order by carrera_id) as row_id, *
	from platzi.alumnos
) as alumnos_with_row_id
where row_id <=5
order by carrera_id;

-- Reto clase 21 RPAD

select Rpad('sql', 15, '*');

select Rpad('sql', id, '*')
from platzi.alumnos 
where id < 10;


-- Clase 22 Generando rangos

select *
from generate_series(1, 4);

select *
from generate_series(5, 1, -2);

select *
from generate_series(4, 3, -1);

select *
from generate_series(4, 4);

select *
from generate_series(3, 4, -1);

select *
from generate_series(1.1, 4, 1.3);

select current_date + s.a as dates
from generate_series(0,14,7) as s(a)
;

select *
from generate_series('2020-09-01 00:00:00'::timestamp,
					'2020-09-04 12:00:00','10 hours');

select a.id,
		a.nombre,
		a.apellido,
		a.carrera_id,
		s.a
from platzi.alumnos as a
	inner join generate_series(0,10) as s(a)
	on s.a = a.carrera_id 
order by a.carrera_id;


-- Clase 22 Reto generar un triangulo con generate_series

select lpad('*', cast(ordinality as int), '*')
from generate_series(10, 2, -2) with ordinality;

select *
from generate_series(100, 2, -2) with ordinality;

-- clase 23 Expresiones regulares

select email
from platzi.alumnos 
where email ~*'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}'
;

-- Clase 27 Windows Function

select *,
	AVG(colegiatura) over(partition by carrera_id)
from platzi.alumnos;

select *,
	AVG(colegiatura) over()
from platzi.alumnos;

select *,
	sum(colegiatura) over(partition by carrera_id order by colegiatura )
from platzi.alumnos;

select *
from ( 
	select *,
	RANK() over(partition by carrera_id order by colegiatura DESC) as brand_rank
	from platzi.alumnos
) as ranked_colegiaturas_por_carrera
where brand_rank < 3
order by brand_rank;

-- clase 28 Windows Function

select row_number () over() as row_id, *
from platzi.alumnos ;

select row_number () over(order by fecha_incorporacion) as row_id, *
from platzi.alumnos ;

select first_value (colegiatura) over(partition by carrera_id) as row_id, *
from platzi.alumnos ;

select last_value (colegiatura) over(partition by carrera_id) as row_id, *
from platzi.alumnos ;

select nth_value (colegiatura, 3) over(partition by carrera_id) as row_id, *
from platzi.alumnos ;

select *,
	rank() over(partition by carrera_id order by colegiatura desc) as colegiatura_rank
from platzi.alumnos 
order by carrera_id, colegiatura_rank ;

select *,
	dense_rank () over(partition by carrera_id order by colegiatura desc) as colegiatura_rank
from platzi.alumnos 
order by carrera_id, colegiatura_rank ;

select *,
	percent_rank() over(partition by carrera_id order by colegiatura desc) as colegiatura_rank
from platzi.alumnos 
order by carrera_id, colegiatura_rank ;


