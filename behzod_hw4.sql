/*
 * 1)
 * Behzod Jumaev
 * 
 * Домашка по SQL
Создайте многострочный комментарий со следующей информацией:
ваши имя и фамилия
описание задачи
Напишите код, который вернёт из таблицы track поля name и genreid
Напишите код, который вернёт из таблицы track поля name, composer, unitprice. Переименуйте поля на song, author и price соответственно. Расположите поля так, чтобы сначало следовало название произведения, далее его цена и в конце список авторов.
Напишите код, который вернёт из таблицы track название произведения и его длительность в минутах. Результат должен быть отсортирован по длительности произведения по убыванию.
Напишите код, который вернёт из таблицы track поля name и genreid, и только первые 15 строк.
Напишите код, который вернёт из таблицы track все поля и все строки начиная с 50-й строки.
Напишите код, который вернёт из таблицы track названия всех произведений, чей объём больше 100 мегабайт.
Напишите код, который вернёт из таблицы track поля name и composer, где composer не равен "U2". Код должен вернуть записи с 10 по 20-й включительно.
Напишите код, который из таблицы invoice вернёт дату самой первой и самой последней покупки.
Напишите код, который вернёт размер среднего чека для покупок из США.
Напишите код, который вернёт список городов в которых имеется более одного клиента.
В репозитории, который вы создавали для предыдущего урока, создайте новую ветку и сохраните файл с кодом решения перечисленных задач в эту ветку.
Сделайте коммит, пуш и создайте pull request.
В классруме прикрепите скриншот вкладки files changed вашего pull request-а.
 */

-- 2)

select "name"
	, genre_id 
from track;


-- 3)

select "name" as song
	, unit_price as price
	, composer as author 
from track;



-- 4)

select "name" as song
	, milliseconds/60000. as minutes 
from track;


-- 5)

select "name", genre_id 
from track limit 15;



-- 6)

select * from track 
offset 50;

-- 7) 

select "name" from track 
where bytes > (100*1024);

-- 8) 

select "name", composer
from track
where (composer != 'U2') 
	and (track_id between 10 and 20); 

-- 9)

select min(invoice_date)
	, max(invoice_date) 
from invoice;

-- 10)

select avg(total) 
from invoice
where billing_country = 'USA';

-- 11)

select billing_city
from invoice
group by billing_city 
HAVING COUNT(*) > 1;
 
