--отношение стоимости товаров к единице стоимости этих товаров 
select opl.product_id, sum(o.amount)
from orders o 
join order_product_list opl on o.order_id = opl.order_id 
group by opl.product_id 

select product_id, price 
from product p 

select t.product_id, sum / price
from (select opl.product_id, sum(o.amount)
from orders o 
join order_product_list opl on o.order_id = opl.order_id 
group by opl.product_id) t
join (select product_id, price 
from product p) t2 on t2.product_id = t.product_id

select t.product_id, sum / (select price from product p where p.product_id = t.product_id) 
from (select opl.product_id, sum(o.amount)
from orders o 
join order_product_list opl on o.order_id = opl.order_id 
group by opl.product_id) t

--отношение стоимости товаров к еденице стоимости этих товаров 
select distinct opl.product_id, sum (o.amount) over (partition by p.product_id) / price
from orders o
join order_product_list opl on o.order_id = opl.order_id 
join product p on p.product_id = opl.order_id 

--получим данные о каждом 1000 заказе 
select *
from (
select order_id, customer_id, amount, 
	row_number () over (order by order_id)
from orders o) t 
where t.row_number % 1000 = 0

--получим накопительную сумму платежей по каждому пользователю 
select order_id, customer_id , amount ,
	sum(amount) over (partition by customer_id order by order_id)
from orders 

select order_id, customer_id , amount ,
	avg(amount) over (partition by customer_id order by order_id)
from orders 


--нужно поятоянно получать данные по последнему заказу пользователя 
create view task_1 as 
select *
from (
select order_id , customer_id , amount ,
	row_number() over (partition by customer_id order by order_id desc)
from orders o) t 
where row_number = 1

select * from task_1

--то же с материализованным представлением 
create materialized view task_2 as 
select *
from (
select order_id , customer_id , amount ,
	row_number() over (partition by customer_id order by order_id desc)
from orders o) t 
where row_number = 1
with no data 

select * from task_2

--обновим данные в материализованном представлении
refresh materialized view task_2

--удалим материализованное представление 
drop materialized view task_2 

--Найдите категорию товара, 
--у которой наибольшее процентное отношение количества товаров
--от общего количества товаров. 
--Какова будет процентная доля у этой категории?
select category, sum(amount)/(select sum(amount) as t from order_product_list opl)*100 as per_cent 
from order_product_list opl
join product p on opl.product_id = p.product_id 
join category c on p.category_id = c.category_id 
group by category
order by per_cent desc









