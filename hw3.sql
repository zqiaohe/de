
-- 6

SELECT DISTINCT prd.maker, lpt.speed
FROM prd AS prd INNER JOIN 
 laptop AS lpt ON lpt.model = prd.model
WHERE lpt.hd >= 10 AND 
 type = 'Laptop';

-- 7

SELECT prd.model, pc.price 
FROM pc 
INNER JOIN prd AS prd
ON pc.model = prd.model
WHERE maker = 'B'
UNION
SELECT prd.model, lpt.price
FROM laptop as lpt
INNER JOIN prd as prd 
ON lpt.model = prd.model
WHERE maker = 'B'
UNION
SELECT prd.model, prnt.price
FROM printer AS prnt
INNER JOIN prd as prd 
ON prd.model = prnt.model
WHERE maker='B';

-- 8

SELECT prd.maker
FROM product as prd
WHERE type IN ('Laptop','PC')
EXCEPT
SELECT prd.maker
FROM product AS prd
WHERE type = 'Laptop';

-- 9

SELECT DISTINCT maker 
FROM product AS prd
INNER JOIN PC 
ON PC.model = prd.model
WHERE speed >= 450;

-- 10

SELECT model, price 
FROM printer
WHERE 
price = (SELECT MAX(price) FROM Printer);

-- 11

SELECT AVG(speed) FROM PC;

-- 12

SELECT AVG(speed) FROM Laptop
WHERE price > 1000;

-- 13

SELECT AVG(speed) 
FROM PC 
INNER JOIN product AS prd
ON PC.model = prd.model
WHERE maker = 'A';

-- 14

SELECT s.class, s.name, c.country 
FROM ships s 
INNER JOIN classes c 
ON c.class=s.class AND c.numGuns>=10;

-- 15

SELECT HD FROM PC 
GROUP BY HD 
HAVING COUNT(HD)>=2;

-- 16

SELECT DISTINCT a.model, b.model, a.speed, a.ram
FROM PC AS a, PC AS b
WHERE a.speed = b.speed 
AND a.ram = b.ram 
AND a.model>b.model;

-- 17

SELECT DISTINCT p.type, a.model, a.speed 
FROM Laptop AS a, PC AS b, Product AS p 
WHERE a.speed < ALL(
   SELECT speed FROM PC)
AND p.model=a.model;

-- 18

SELECT DISTINCT maker, price
FROM Printer AS A
INNER JOIN Product AS B
ON B.model=A.model
WHERE price = (SELECT 
	MIN(price) FROM printer 
	WHERE color='y') 
AND color='y';

-- 19

SELECT maker, AVG(screen) 
FROM Product AS p
INNER JOIN Laptop AS l
ON p.model=l.model 
GROUP BY maker;

-- 20

SELECT maker, COUNT(p.model) 
FROM Product AS p 
WHERE p.type = 'pc'
GROUP BY maker
HAVING COUNT(p.model)>=3;

-- 21

SELECT p.maker, MAX(price) 
FROM pc
INNER JOIN Product AS p
ON p.model = pc.model 
GROUP BY p.maker;

-- 22

SELECT speed, AVG(price) FROM PC
WHERE speed>600
GROUP BY speed

-- 23

SELECT Product.maker
FROM Product
INNER JOIN PC
ON Product.model = PC.model
WHERE PC.speed>=750
INTERSECT
SELECT Product.maker
FROM Product
INNER JOIN Laptop
ON Product.model = Laptop.model
WHERE Laptop.speed>=750

-- 24

WITH uni AS (
SELECT model, price FROM PC
 UNION ALL
SELECT model, price FROM Laptop
 UNION ALL 
SELECT model, price FROM Printer)

SELECT DISTINCT model FROM uni
WHERE price = (SELECT MAX(price) FROM uni);

-- 25

SELECT maker
FROM product pr2
WHERE pr2.type = 'Printer' AND
pr2.maker IN (
SELECT pr.maker
FROM product pr
WHERE pr.model IN (
SELECT pc3.model
FROM pc AS pc3
WHERE pc3.speed = (
SELECT max(speed)
FROM pc
WHERE ram = (
SELECT min(ram)
FROM pc
)
) AND
pc3.ram = (
SELECT min(ram)
FROM pc
)
GROUP BY pc3.model
)
GROUP BY maker
)
GROUP BY maker;
