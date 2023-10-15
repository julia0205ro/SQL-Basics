--создание таблицы 
create table delivery (
	delivery_id serial primary key,
	address_id int references address(address_id) not null,
	delivery_date date not null,
	time_range text[] not null,
	staff_id int references staff(staff_id) not null,
	status del_status not null default 'в обработке', 
	last_update timestamp,
	create_date timestamp default now(),
	deleted boolean not null default false
)

ALTER TABLE delivery RENAME COLUMN create_date TO created_date;

select * from delivery 

--добавим в таблицу с заказами ограничение внешнего ключа для столбца с доставкой
alter table orders add constraint orders_delivery_fkey foreign key (delivery_id)
	references delivery(delivery_id)
	
--изменим данные в заказах, добавив данные по идентификатору доставки
insert into delivery (address_id, delivery_date, time_range, staff_id)
values(102, '2022.02.25', array['10:00:00', '18:00:00'], 2),
(34, '2022.02.25', array['10:00:00', '18:00:00'], 2),
(12, '2022.02.25', array['10:00:00', '18:00:00'], 2),
(78, '2022.02.25', array['10:00:00', '18:00:00'], 2),
(55, '2022.02.25', array['10:00:00', '18:00:00'], 2)


update orders 
set delivery_id = 1
where order_id = 1

update orders 
set delivery_id = 2
where order_id = 2

update orders 
set delivery_id = 3
where order_id = 3

update orders 
set delivery_id = 4
where order_id = 4

update orders 
set delivery_id = 5
where order_id = 5

select * from orders 

--попробуем удалить запись из доставки 
delete from delivery 
where delivery_id = 1

--получим данные из каких городов какие заказы совершались 
select o.order_id, c.city 
from orders o
join delivery d on o.delivery_id = d.delivery_id
join address a on a.address_id = d.address_id
join city c on c.city_id = a.city_id 

--получим все возможные комбинации имен пользователей, так, чтобы имя А не было равно имени А
select c.first_name, c2.first_name 
from customer c 
cross join customer c2 
where c.first_name != c2.first_name 

--получим список заказов по которым отсутствует доставка 
select o.order_id, d.delivery_id
from orders o 
left join delivery d on d.delivery_id = o.delivery_id 
where d.delivery_id is null 

--получим данные по сумме платежей, минимальному, максимальному платежу и количеству платежей 
-- по каждому пользователю 
select c.last_name, c.first_name, sum(amount), min(amount), max(amount), avg(amount)
from customer c 
join orders o on o.customer_id = c.customer_id 
group by c.customer_id 

--получим данные по сумме платежей, минимальному, максимальному платежу и количеству платежей 
-- по каждому пользователю, при этом размер платежа должен быть более 100 и сумма платежей
--должна быть более 20000
select c.last_name, c.first_name, sum(amount), min(amount), max(amount), avg(amount)
from customer c 
join orders o on o.customer_id = c.customer_id 
where amount > 100
group by c.customer_id 
having sum(amount) > 20000

--Какое количество платежей было совершено?
select count(amount) from orders;

--Какое количество товаров находится в категории “Игрушки”?
select count(category) from category c
join product p 
on c.category_id = p.category_id 
where category = 'Игрушки'

--В какой категории находится больше всего товаров?
select category from category c
join product p 
on c.category_id = p.category_id 
group by category
order by count(product) desc
limit 1

--Сколько “Черепах” купила Williams Linda?
select sum(opl.amount) from orders o  
join customer c on o.customer_id = c.customer_id 
join order_product_list opl on opl.order_id = o.order_id 
join product p on p.product_id = opl.product_id 
where last_name = 'Williams' and first_name = 'Linda' and 
product = 'Черепаха'