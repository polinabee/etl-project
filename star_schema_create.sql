drop table if exists date_dimension;
create table date_dimension (
    order_date date unique primary key,
    day_of_week double precision,
    month_num double precision,
    year_num double precision
);

drop table if exists product_dimension;
create table product_dimension(
    product_code varchar unique primary key,
    product_name varchar,
    product_line varchar,
    buy_price money,
    msrp money,
    sales_per_product money,
    profit_per_product money
);

drop table if exists customer_dimension;
create table customer_dimension(
    customer_number integer unique primary key,
    customer_name varchar,
    city varchar,
    country varchar,
    money_spent money
);

drop table if exists sales_fact;
create table sales_fact(
    order_date date not null,
    order_number integer not null,
    customer_number integer not null,
    product_code varchar not null,
    price_each money,
    profit_each money,
    quantity_ordered integer,
    constraint tbl_pkey primary key(order_date,order_number,customer_number,product_code)
);