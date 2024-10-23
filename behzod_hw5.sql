-- 1) Список телефонных номеров без скобок
select 
    phone
from customer
where 
    phone !~ '[()]';

-- 2) Изменение регистра текста 'lorem ipsum'
select initcap(lower('lorem ipsum'));

-- 3) Список песен, содержащих слово 'run'
select 
    name
from track
where 
    name ilike '%run%';

-- 4) Список клиентов с почтовым ящиком на 'gmail'
select 
    first_name, 
    last_name, 
    email
from customer
where 
    email like '%@gmail.com';

-- 5) Произведение с самым длинным названием
select 
    name
from track
order by 
    length(name) desc
limit 1;

-- 6) Общая сумма продаж за 2021 год по месяцам
select 
    extract(month from invoice_date) as month_id, 
    sum(total) as sales_sum
from invoice
where 
    extract(year from invoice_date) = 2021
group by 
    month_id
order by 
    month_id;

-- 7) Общая сумма продаж за 2021 год с названием месяца
select 
    extract(month from invoice_date) as month_id, 
    to_char(invoice_date, 'month') as month_name, 
    sum(total) as sales_sum
from invoice
where 
    extract(year from invoice_date) = 2021
group by 
    month_id, month_name
order by 
    month_id;

-- 8) Три самых возрастных сотрудника компании
select 
    first_name || ' ' || last_name as full_name, 
    birth_date, 
    extract(year from age(birth_date)) as age_now
from employee
order by 
    age_now desc
limit 3;

-- 9) Средний возраст сотрудников через 3 года и 4 месяца
select 
    avg(extract(year from age(birth_date + interval '3 years 4 months'))) as avg_age_future
from employee;

-- 10) Сумма продаж по годам и странам, с фильтрацией по сумме более 20
select 
    extract(year from invoice_date) as year, 
    billing_country, 
    sum(total) as sales_sum
from invoice
group by 
    year, billing_country
having 
    sum(total) > 20
order by 
    year asc, sales_sum desc;
