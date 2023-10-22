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
