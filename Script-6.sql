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
