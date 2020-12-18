
--- Get the top 3 product lines that have proven most profitable (highest total profit)
select product_line, sum(profit_per_product) profit_per_line from product_dimension
group by 1 order by profit_per_line desc limit 3;
/* product_line | profit_per_line
--------------+-----------------
 Classic Cars |   $1,526,212.20
 Vintage Cars |     $737,268.33
 Motorcycles  |     $469,255.30
(3 rows) */

--- Get the top 3 products by most items sold
select product_name, sum(quantity_ordered) units_sold from sales_fact
join product_dimension pd on sales_fact.product_code = pd.product_code
group by 1 order by 1 desc limit 3;
/*       product_name        | units_sold
---------------------------+------------
 The USS Constitution Ship |       1020
 The Titanic               |        952
 The Schooner Bluenose     |        934
(3 rows) */

--- Get the number of orders (amount of distinct orders) per day of the week
select day_of_week, count(order_number) from sales_fact
join date_dimension dd on sales_fact.order_date = dd.order_date
group by 1 order by 1;
/* day_of_week | count
-------------+-------
           1 |   407
           2 |   540
           3 |   573
           4 |   575
           5 |   634
           6 |   146
           7 |   121
(7 rows)*/

-- List the customers who have bought more goods (in $ amount) than the average customer
select customer_number, customer_name, money_spent from customer_dimension
where money_spent::numeric > (select avg(money_spent::numeric) from customer_dimension);
/* customer_number |        customer_name         | money_spent
-----------------+------------------------------+-------------
             363 | Online Diecast Creations Co. | $116,449.29
             121 | Baane Mini Imports           | $104,224.79
             141 | Euro+ Shopping Channel       | $820,689.54
             145 | Danish Wholesale Imports     | $129,085.12
             278 | Rovelli Gifts                | $127,529.69
             131 | Land of Toys Inc.            | $149,085.15
             187 | AV Stores, Co.               | $148,410.09
             124 | Mini Gifts Distributors Ltd. | $591,827.34
             148 | Dragon Souveniers, Ltd.      | $156,251.03
             382 | Salzburg Collectables        | $137,480.07
             114 | Australian Collectors, Co.   | $180,585.07
             353 | Reims Collectables           | $126,983.19
             458 | Corrida Auto Replicas, Ltd   | $112,440.09
             151 | Muscle Machine Inc           | $177,913.95
             323 | Down Under Souveniers, Inc   | $154,622.08
             496 | Kelly's Gift Shop            | $137,460.79
             282 | Souveniers And Things Co.    | $133,907.12
             161 | Technics Stores Inc.         | $104,545.22
             334 | Suominen Souveniers          | $103,896.74
             320 | Mini Creations Ltd.          | $101,872.52
             276 | Anna's Decorations, Ltd      | $137,034.22
             321 | Corporate Gift Ideas Co.     | $132,340.78
             448 | Scandinavian Gift Ideas      | $120,943.53
             386 | L'ordine Souveniers          | $125,505.57
             146 | Saveley & Henriot, Co.       | $130,305.35
             166 | Handji Gifts& Co             | $107,746.75
             298 | Vida Sport, Ltd              | $108,777.92
             450 | The Sharp Gifts Warehouse    | $143,536.27
             201 | UK Collectables, Ltd.        | $106,610.72
             398 | Tokyo Collectables, Ltd      | $105,548.73
             157 | Diecast Classics Inc.        | $104,358.69
             119 | La Rochelle Gifts            | $158,573.12
(32 rows)*/

--- Get the average profit margin per product line
--- (profit margin is profit divided by gross sales amount)
select product_line, avg(profit_per_product/sales_per_product)
from product_dimension group by 1;
/*   product_line   |         avg
------------------+---------------------
 Classic Cars     |  0.3908956331918145
 Trains           |  0.3635228104089017
 Planes           |  0.3799715567269915
 Trucks and Buses | 0.40361433605832087
 Vintage Cars     |  0.4069016453526883
 Motorcycles      | 0.40958201887461576
 Ships            |  0.4007007836055673
(7 rows)*/