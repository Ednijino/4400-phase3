-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team __
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
    if not exists (
		select 1 from customers where uname = ip_uname
        union all
		select 1 from users where uname = ip_uname
	) then
        insert into users(uname, first_name, last_name, address, birthdate)
        values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
        insert into customers(uname, rating, credit)
        values (ip_uname, ip_rating, ip_credit);
    end if;
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
    if not exists (select 1 from users where uname = ip_uname)
    and not exists(select 1 from employees where taxID = ip_taxID or uname = ip_uname)
    and not exists (select 1 from drone_pilots where licenseID = ip_licenseID or uname = ip_uname) 
    then
        insert into users(uname, first_name, last_name, address, birthdate)
        values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
        insert into employees(uname, taxID, service, salary)
        values (ip_uname, ip_taxID, ip_service, ip_salary);
        insert into drone_pilots(uname, licenseID, experience)
        values (ip_uname, ip_licenseID, ip_experience);
    end if;
end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
    if not exists (
		select 1 from products where barcode = ip_barcode
        union all
        select 1 from order_lines where barcode = ip_barcode
	) then
        insert into products(barcode, pname, weight)
        values (ip_barcode, ip_pname, ip_weight);
    end if;
end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
    if not exists (select * from drones where storeID = ip_storeID and droneTag = ip_droneTag) and
       not exists (select * from drones where pilot = ip_pilot) and
       exists (select * from stores where storeID = ip_storeID) then
        insert into drones(storeID, droneTag, capacity, remaining_trips, pilot)
        values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
    end if;
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
    if ip_money >= 0 then
        update customers set credit = credit + ip_money where uname = ip_uname;
    end if;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
    if exists (select * from drone_pilots where uname = ip_incoming_pilot) and
       not exists (select * from drones where pilot = ip_incoming_pilot) and
       exists (select * from drones where pilot = ip_outgoing_pilot) then
        update drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
    end if;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
    if ip_refueled_trips >= 0 then
        update drones set remaining_trips = remaining_trips + ip_refueled_trips
        where storeID = ip_drone_store and droneTag = ip_drone_tag;
    end if;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	declare v_credit integer default 0;
    declare v_capacity integer default 0;
    declare v_product_weight integer default 0;
    
    -- Check if the customer has enough credit
    select credit into v_credit from customers 
    where uname = ip_purchased_by;
    
    -- Get product weight
    select weight into v_product_weight from products
    where barcode = ip_barcode;
    
    -- Check drone capacity
    select capacity into v_capacity from drones 
    join products on ip_barcode = products.barcode
    where storeID = ip_carrier_store and droneTag = ip_carrier_tag;
    
    if not exists (select 1 from orders where orderID = ip_orderID) 
       and v_credit >= ip_quantity * ip_price 
       and v_capacity >= ip_quantity * v_product_weight
       and ip_price >= 0 
       and ip_quantity > 0 then
        insert into orders(orderID, sold_on, purchased_by, carrier_store, carrier_tag)
        values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
    end if;
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
    set @customer_name := (select purchased_by from orders where orderID = ip_orderID);
    set @drone_store := (select carrier_store from orders where orderID = ip_orderID);
    set @drone_tag := (select carrier_tag from orders where orderID = ip_orderID);
    set @weight := (select weight from products where barcode = ip_barcode);
    set @customer_name := (select purchased_by from orders where orderID = ip_orderID);
    if exists (select 1 from orders where orderID = ip_orderID)
    and exists (select 1 from products where barcode = ip_barcode) 
    and not exists (select 1 from order_lines where orderID = ip_orderID and barcode = ip_barcode) 
    and ip_price >= 0 and ip_quantity > 0
    and (select credit >= ip_quantity *  ip_price from customers where uname = @customer_name)
    and (
		select capacity >=  ip_quantity *  @weight 
        from drones where storeID = @drone_store and droneTag = @drone_tag
	) then
        insert into order_lines(orderID, barcode, price, quantity)
        values (ip_orderID, ip_barcode, ip_price, ip_quantity);
	end if;
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    set @totalCost := (select sum(price * quantity) from order_lines where orderID = ip_orderID);
    set @customer_name := (select purchased_by from orders where orderID = ip_orderID);
    set @drone_store := (select carrier_store from orders where orderID = ip_orderID);
    set @drone_tag := (select carrier_tag from orders where orderID = ip_orderID);
    set @pilot := (select pilot from drones where storeID = @drone_store and droneTag = @drone_tag);
    if exists (select 1 from orders where orderID = ip_orderID)
    and (
		select remaining_trips > 0 from drones where storeID = @drone_store and droneTag = @drone_tag
	) then
		update customers set credit = credit - @totalCost where uname = @customer_name;
		update stores set revenue = revenue + @totalCost where storeID = @drone_store;
		update drones set remaining_trips = remaining_trips - 1 where storeID = @drone_store and droneTag = @drone_tag;
		update drone_pilots set experience = experience + 1 where uname = @pilot;
        if @totalCost > 25 then update customers set rating = rating + 1 where uname = @customer_name; end if;
	else
		delete from orders where orderID = ip_orderID;
    end if;
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
	declare customer_name varchar(255);
    set @customer_name := (select purchased_by from orders where orderID = ip_orderID);
    if exists (select 1 from orders where orderID = ip_orderID)
    then
		update customers set rating = rating - 1 where uname = @customer_name;
	end if;
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as
-- replace this select query with your solution
SELECT 'users' AS category, COUNT(*) AS total FROM users
UNION
SELECT 'customers' AS category, COUNT(*) AS total FROM customers
UNION
SELECT 'employees' AS category, COUNT(*) AS total FROM employees
UNION
SELECT 'customer_employer_overlap' AS category, COUNT(*) AS total FROM customers 
JOIN employees ON customers.uname = employees.uname
UNION
SELECT 'drone_pilots' AS category, COUNT(*) AS total FROM drone_pilots
UNION
SELECT 'store_workers' AS category, COUNT(*) AS total FROM store_workers
UNION
SELECT 'other_employee_roles' AS category, COUNT(*) AS total FROM employees
WHERE uname NOT IN (SELECT uname FROM drone_pilots) AND uname NOT IN (SELECT uname FROM store_workers);
  

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- replace this select query with your solution
SELECT c.uname AS customer_name, c.rating, c.credit AS current_credit, COALESCE(SUM(ol.price * ol.quantity), 0) AS credit_already_allocated FROM customers c
LEFT JOIN orders o ON c.uname = o.purchased_by
LEFT JOIN order_lines ol ON o.orderID = ol.orderID
GROUP BY c.uname;

-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
SELECT 
    d.storeID AS drone_serves_store,
    d.droneTag as drone_tag,
    d.pilot as pilot,
    d.capacity AS total_weight_allowed,
    COALESCE(SUM(p.weight * ol.quantity), 0) AS current_weight,
    d.remaining_trips AS deliveries_allowed,
    (SELECT COUNT(o.orderID) FROM orders o
     WHERE o.carrier_store = d.storeID AND o.carrier_tag = d.droneTag) AS deliveries_in_progress
FROM drones d
LEFT JOIN orders o ON d.storeID = o.carrier_store AND d.droneTag = o.carrier_tag
LEFT JOIN order_lines ol ON o.orderID = ol.orderID
left JOIN products p ON ol.barcode = p.barcode
GROUP BY d.storeID, d.droneTag;

-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
-- replace this select query with your solution
SELECT 
    p.barcode,
    p.pname AS product_name,
    p.weight,
    MIN(ol.price) AS lowest_price,
    MAX(ol.price) AS highest_price,
    COALESCE(MIN(ol.quantity), 0) AS lowest_quantity,
    COALESCE(MAX(ol.quantity), 0) AS highest_quantity,
    COALESCE(SUM(ol.quantity), 0) AS total_quantity
FROM products p
LEFT JOIN order_lines ol ON p.barcode = ol.barcode
GROUP BY p.barcode;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
SELECT 
    dp.uname AS pilot,
    dp.licenseID AS licenseID,
    d.storeID AS drone_serves_store,
    d.droneTag AS drone_tag,
    dp.experience AS successful_deliveries,
	COALESCE(COUNT(o.orderID), 0) as pending_deliveries
FROM drone_pilots dp
LEFT JOIN drones d ON dp.uname = d.pilot
LEFT JOIN orders o ON d.storeID = o.carrier_store AND d.droneTag = o.carrier_tag
GROUP BY dp.uname, d.storeID, d.droneTag;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
SELECT 
	s.storeID as store_id,
    s.sname as sname,
    s.manager as manager,
    s.revenue as revenue,
    SUM(ol.price * ol.quantity) AS incoming_revenue,
    COUNT(DISTINCT o.orderID) AS incoming_orders
FROM stores s
JOIN orders o ON o.carrier_store = s.storeID
JOIN order_lines ol ON o.orderID = ol.orderID
GROUP BY s.storeID;
-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
-- replace this select query with your solution
SELECT 
    o.orderID,
    SUM(ol.price * ol.quantity) AS cost,
    COUNT(DISTINCT ol.barcode) AS num_products,
    SUM(p.weight * ol.quantity) AS payload,
    GROUP_CONCAT(p.pname SEPARATOR ', ') AS contents
FROM orders o
JOIN order_lines ol ON o.orderID = ol.orderID
JOIN products p ON ol.barcode = p.barcode
GROUP BY o.orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin

	if ip_uname is null then
		leave sp_main;
	end if;
	if not exists(select 1 from orders where orders.purchased_by = ip_uname) then
		delete from customers where customers.uname = ip_uname;
	end if;

end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	if ip_uname is null then
		leave sp_main;
	end if;
    if not exists(select 1 from drones where drones.pilot = ip_uname) then
		delete from drone_pilots where drone_pilots.uname = ip_uname;
	end if;
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	if ip_barcode is null then 
		leave sp_main;
	end if;
     if not exists (select 1 from order_lines where order_lines.barcode = ip_barcode) then
		delete from products where products.barcode = ip_barcode;
	end if;
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin

	if ip_storeID is null or ip_droneTag is null then
		leave sp_main;
	end if;
	if not exists (select 1 from orders where orders.carrier_store = ip_storeID and orders.carrier_tag = ip_droneTag) then
		delete from drones where drones.storeID = ip_storeID and drones.droneTag = ip_droneTag;
	end if;
end //
delimiter ;
