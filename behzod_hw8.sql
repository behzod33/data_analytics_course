-- Задача №1

select 
    e.employee_id,
    concat(e.first_name, ' ', e.last_name) as full_name,
    count(c.customer_id) as customer_count,
    round((count(c.customer_id) * 100.0 / (select count(*) from customer)), 2) as customer_percent
from employee e
left join customer c on e.employee_id = c.support_rep_id
group by e.employee_id, full_name
order by customer_count;


-- Задача №2

select 
    a.title as album_name,
    ar.name as artist_name
from album a
join artist ar on a.artist_id = ar.artist_id
left join track t on a.album_id = t.album_id
left join invoice_line il on t.track_id = il.track_id
where il.track_id is null;


-- Задача №3

with monthly_sales as (
    select 
        i.customer_id,
        concat(c.first_name, ' ', c.last_name) as full_name,
        to_char(i.invoice_date, 'yyyymm') as monthkey,
        sum(i.total) as total
    from invoice i
    join customer c on i.customer_id = c.customer_id
    group by i.customer_id, full_name, monthkey
)
select 
    customer_id,
    full_name,
    monthkey,
    total,
    round(total * 100.0 / sum(total) over (partition by monthkey), 2) as monthly_percent,
    sum(total) over (partition by customer_id, extract(year from to_date(monthkey, 'yyyymm'))
                     order by monthkey) as cumulative_total,
    avg(total) over (partition by customer_id order by monthkey rows between 2 preceding and current row) as moving_average,
    total - lag(total) over (partition by customer_id order by monthkey) as period_difference
from monthly_sales
order by monthkey;


-- Задача №4

select 
    e.employee_id,
    concat(e.first_name, ' ', e.last_name) as full_name
from employee e
left join employee m on e.employee_id = m.reports_to
where m.employee_id is null;


-- Задача №5

select 
    i.customer_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    min(i.invoice_date) as first_purchase_date,
    max(i.invoice_date) as last_purchase_date,
    extract(year from age(max(i.invoice_date), min(i.invoice_date))) as diff_in_years
from invoice i
join customer c on i.customer_id = c.customer_id
group by i.customer_id, full_name;


-- Задача №6

select 
    extract(year from i.invoice_date) as year,
    a.title as album_name,
    ar.name as artist_name,
    count(il.track_id) as track_sales
from album a
join artist ar on a.artist_id = ar.artist_id
join track t on a.album_id = t.album_id
join invoice_line il on t.track_id = il.track_id
join invoice i on il.invoice_id = i.invoice_id
group by year, album_name, artist_name
order by year, track_sales desc
limit 3;


-- Задача №7

select distinct 
    t.track_id,
    t.name as track_name
from track t
join invoice_line il on t.track_id = il.track_id
join invoice i on il.invoice_id = i.invoice_id
where i.billing_country = 'USA'
and t.track_id in (
    select t2.track_id
    from track t2
    join invoice_line il2 on t2.track_id = il2.track_id
    join invoice i2 on il2.invoice_id = i2.invoice_id
    where i2.billing_country = 'Canada'
);


-- Задача №8

select distinct 
    t.track_id,
    t.name as track_name
from track t
join invoice_line il on t.track_id = il.track_id
join invoice i on il.invoice_id = i.invoice_id
where i.billing_country = 'Canada'
and t.track_id not in (
    select t2.track_id
    from track t2
    join invoice_line il2 on t2.track_id = il2.track_id
    join invoice i2 on il2.invoice_id = i2.invoice_id
    where i2.billing_country = 'USA'
);
