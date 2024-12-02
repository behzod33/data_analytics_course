-- 1) Информация по каждому сотруднику: 
-- ID, полное имя, позиция, ID менеджера, полное имя и позиция менеджера

select 
    e.employee_id,
    concat(e.first_name, ' ', e.last_name) as full_name,
    e.title,
    e.reports_to,
    (select concat(m.first_name, ' ', m.last_name, ', ', m.title)
     from employee m 
     where m.employee_id = e.reports_to) as manager_info
from employee e;


-- 2) Список чеков, сумма которых больше среднего чека за 2023 год

select 
    invoice_id,
    invoice_date,
    to_char(invoice_date, 'yyyymm') as month_key,
    customer_id,
    total
from invoice
where 
    total > (select avg(total) 
             from invoice 
             where extract(year from invoice_date) = 2023)
and extract(year from invoice_date) = 2023;


-- 3) Дополнение предыдущего запроса email-ом клиента

select 
    i.invoice_id,
    i.invoice_date,
    to_char(i.invoice_date, 'yyyymm') as month_key,
    i.customer_id,
    i.total,
    (select c.email 
     from customer c 
     where c.customer_id = i.customer_id) as email
from invoice i
where 
    i.total > (select avg(total) 
               from invoice 
               where extract(year from invoice_date) = 2023)
and extract(year from invoice_date) = 2023;


-- 4) Фильтрация, чтобы в запросе не было клиентов с доменом gmail

select 
    i.invoice_id,
    i.invoice_date,
    to_char(i.invoice_date, 'yyyymm') as month_key,
    i.customer_id,
    i.total,
    (select c.email 
     from customer c 
     where c.customer_id = i.customer_id) as email
from invoice i
where 
    i.total > (select avg(total) 
               from invoice 
               where extract(year from invoice_date) = 2023)
and extract(year from invoice_date) = 2023
and (select c.email 
     from customer c 
     where c.customer_id = i.customer_id) not like '%@gmail.com';


-- 5) Процент от общей выручки за 2024 год, который принёс каждый чек
    
select 
    i.invoice_id,
    i.total,
    (i.total / (select sum(total) 
                from invoice 
                where extract(year from invoice_date) = 2024)) * 100 as percent_of_total
from invoice i
where extract(year from invoice_date) = 2024;


-- 6) Процент от общей выручки за 2024 год, который принёс каждый клиент

select 
    i.customer_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    (select sum(i2.total) 
     from invoice i2 
     where i2.customer_id = i.customer_id 
     and extract(year from i2.invoice_date) = 2024) as total_by_customer,
    ((select sum(i2.total) 
      from invoice i2 
      where i2.customer_id = i.customer_id 
      and extract(year from i2.invoice_date) = 2024) / 
     (select sum(total) 
      from invoice 
      where extract(year from invoice_date) = 2024)) * 100 as percent_of_total
from invoice i
join customer c on i.customer_id = c.customer_id
where extract(year from i.invoice_date) = 2024
group by i.customer_id, c.first_name, c.last_name;


