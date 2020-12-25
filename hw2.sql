-- 1 задание

create table employee (
id integer primary key,
name varchar(30) not null,
last_name varchar(30) not null,
age integer  check( age > 0 and age < 150),
passport varchar(10) unique, 
salary number(32,2) 
);

-- 2 задание

insert into employee 
(id, name, last_name, age, passport, salary)
values
(0, 'Harry', 'Potter', 30, 1234567890, 100000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(1, 'Harry1', 'Potter1', 30, 1234567891, 10000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(2, 'Harry2', 'Potter2', 30, 1234567892, 10000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(3, 'Harry3', 'Potter3', 30, 1234567893, 100000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(4, 'Harry4', 'Potter4', 30, 1234567894, 10000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(5, 'Harry5', 'Potter5', 30, 1234567895, 100000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(6, 'Harry6', 'Potter6', 31, 1234567896, 10000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(7, 'Harry7', 'Potter7', 31, 1234567897, 100000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(8, 'Harry8', 'Potter8', 33, 1234567898, 100000);

insert into employee 
(id, name, last_name, age, passport, salary)
values
(9, 'Harry9', 'Potter9', 30, 1234567899, 10000);

-- 3 задание

create view OverThirty 
(id, name, last_name, age, passport, salary )
as select 
id, name, last_name, age, passport, salary 
from employee
where age > 30;

-- 4 задание

create table Over20000salary as 
select 
id, name, last_name, age, passport, salary 
from employee
where salary > 20000;