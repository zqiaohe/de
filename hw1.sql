SELECT model, speed, hd 
FROM PC 
WHERE price < 500;

SELECT DISTINCT Maker 
FROM Product
WHERE type = 'Printer';

SELECT model, ram, screen 
FROM Laptop
WHERE price > 1000;

SELECT * FROM Printer
WHERE color = 'y';

SELECT model, speed, hd 
FROM PC
WHERE cd in ('12x', '24x') AND price < 600;
