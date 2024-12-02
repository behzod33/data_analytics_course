-- 1) Создание таблицы students 

create table students (
	student_id serial primary key,
	student_name varchar(100) not null,
	username varchar(50) unique not null,
	bio text,
	mobile varchar(20),
	has_picture boolean
);

-- Заполнение таблицы students данными

insert into students (student_name, username, bio, mobile, has_picture)
values 
   ('Darth Behzod', 'behzod_31', 'I am always satisfied with the best', '559009474', true),
   ('Jamik', 'Jamik2306', 'Могуч пахуч и волосат', '987244060', true),
   ('Alexandra Leshukovich', 'Alexandraleshaya', 'Amor fati - полюби свою судьбу', '900013777', true),
   ('Farhod JKH', 'FarhodJKH', null, null, false);

select * from students;

-- 2) Создание таблицы lessons

create table lessons (
	lesson_id serial primary key,
	lesson_name varchar(100) not null,
	lesson_date date not null,
	attendance boolean
);

-- Заполнение таблицы lessons данными

insert into lessons (lesson_name, lesson_date, attendance)
values 
	('Git Введение', '2024-10-09', true),
	('Github. Работа с ветками', '2024-10-11', true),
	('Git collaboration', '2024-10-14', true),
	('SQL знакомство', '2024-10-16', true),
	('Операторы выборки, фильтрации и агрегации данных', '2024-10-18', true),
	('Работа с текстом и датой', '2024-10-21', true),
	('Создание, редактирование и удаление таблиц', '2024-10-23', true);

select * from lessons;


-- 3) Создание таблицы scores с внешними ключами

create table scores (
	score_id serial primary key,
	user_id int references students(student_id),
	lesson_id int references lessons(lesson_id),
	score int
);

-- Заполнение таблицы lessons данными

insert into scores (user_id, lesson_id, score)
values 
   (1, 1, 83),
   (1, 2, 90),
   (1, 3, 100),
   (1, 4, null),
   (1, 5, null),
   (1, 6, null);

select * from scores;
   
   
-- 4) Добавление индекса к столбцу username
   
create index idx_username on students(username);  

-- 5)
   

create view my_results as
select 
   s.student_id,
   s.student_name,
   s.username,
   s.mobile,
   (select count(*) from lessons l join scores sc on l.lesson_id = sc.lesson_id where sc.user_id = s.student_id and l.attendance = true) as lessons_attended,
   (select avg(score) from scores sc where sc.user_id = s.student_id) as avg_score
from students s
where s.username = 'behzod_31';

select * from my_results;
