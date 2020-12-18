date_query = '''select distinct order_date,
                extract(ISODOW from order_date) day_of_week,
                extract(MONTH from order_date) month_num,
                extract(YEAR from order_date) year_num
                from public.orders'''

sales_query = '''create or replace view sales_fact as (select order_date,
           od.order_number,
           customer_number,
           p.product_code,
           price_each,
           price_each - buy_price profit_each,
           quantity_ordered
    from public.order_details od
    join public.orders o
        on o.order_number = od.order_number
    join public.products p
    on p.product_code = od.product_code)'''

product_query = '''select p.product_code,
           product_name,
           product_line,
           buy_price,
           msrp,
           sales_per_product,
           profit_per_product
    from public.products p
    join (
        select
                 product_code,
                sum(price_each * quantity_ordered) sales_per_product,
                sum(profit_each * quantity_ordered) profit_per_product
        from sales_fact group by 1) sf
    on sf.product_code = p.product_code'''

customer_query = '''select c.customer_number,
           customer_name,
           city,
           country,
           money_spent
    from public.customers c
    join (select customer_number, sum(price_each*quantity_ordered) money_spent from sales_fact
        group by 1) sf
        on sf.customer_number = c.customer_number'''