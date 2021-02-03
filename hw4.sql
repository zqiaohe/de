--26

SELECT AVG(price) FROM (SELECT price FROM Product p
LEFT JOIN pc
ON p.model=pc.model
WHERE maker = 'A'

UNION ALL

SELECT price FROM product p
LEFT JOIN laptop l
ON p.model=l.model
WHERE maker = 'A') p

--27

SELECT maker, AVG(hd) FROM (
	SELECT maker, hd FROM product p 
	LEFT JOIN pc
	ON pc.model = p.MODEL 
	WHERE maker IN (
		SELECT maker FROM product WHERE type='Printer' and hd != 0
	)
) p
GROUP BY maker


--28

SELECT COUNT(maker) FROM (
	SELECT DISTINCT maker FROM Product 
	GROUP BY maker
	HAVING count(model)=1) p

--29

SELECT i.point, i.date, inc, out 
FROM income_o i LEFT JOIN outcome_o o 
ON i.point =o.point AND i.date=o.date
UNION
SELECT o.point, o.date, inc, out 
FROM income_o i RIGHT JOIN outcome_o o 
ON i.point =o.point AND i.date=o.date

--30

SELECT point, date, SUM(out), SUM(inc) FROM(
	SELECT i.point, i.date, out, inc 
	FROM income i LEFT JOIN Outcome o 
	ON I.point = o.point 
	AND i.date = o.date 
	AND i.code = o.code
	UNION ALL
	SELECT o.point, o.date, out, inc
	FROM income i RIGHT JOIN Outcome o 
	ON I.point = o.point 
	AND i.date = o.date 
	AND i.code = o.code) t
GROUP BY point, date


--31

SELECT clASs, country FROM clASses
WHERE bore >= 16

--32

SELECT sh.country, CAST(AVG((sh.bore*sh.bore*sh.bore)/2) AS NUMERIC(6,2)) AS mw FROM(
	SELECT s.name, c.country, c.bore 
	FROM ships s LEFT JOIN clASses c
	ON c.clASs = s.clASs
	UNION
	SELECT o.ship, c.country, c.bore 
	FROM outcomes o INNER JOIN clASses c 
	ON o.ship = c.clASs)
sh GROUP BY sh.country

--33

SELECT sh.country, CAST(AVG((sh.bore*sh.bore*sh.bore)/2) AS NUMERIC(6,2)) AS mw FROM(
	SELECT s.name, c.country, c.bore FROM ships s LEFT JOIN clASses c ON c.clASs = s.clASs
	UNION
	SELECT o.ship, c.country, c.bore FROM outcomes o INNER JOIN clASses c ON 
	o.ship = c.clASs)
sh GROUP BY sh.country

--34

SELECT s.name FROM ships s
LEFT JOIN clASses c 
ON s.clASs = c.clASs
WHERE s.launched >= 1922
AND c.displacement > 35000
AND c.type = 'bb'

-- 35

SELECT model, type FROM product
WHERE model NOT LIKE '%[^0-9]%'
OR model NOT LIKE '%[^A-Z]%'


-- ОЧИСТКА ДАННЫХ
CREATE TABLE dataSource_01 AS  
SELECT  
    first_name,	 
    last_name,	 
    email,	 
    CASE 
        WHEN substr(PHONE, 1, 1) = '8' THEN  '+7' || substr(PHONE, 2) 
        ELSE phone 
    END AS phone, 
    gender 
FROM ( 
    SELECT  
        CASE  
            WHEN instr(first_name, ' ') = 0 
                THEN first_name 
            WHEN last_name is NULL  
                THEN substr(first_name, 1, instr(first_name, ' ')-1) 
            WHEN first_name is NULL  
                THEN substr(last_name, 1, instr(last_name, ' ')-1) 
        END AS first_name, 
        CASE  
            WHEN instr(last_name, ' ') = 0 
                THEN last_name 
            WHEN first_name is NULL  
                THEN substr(last_name, instr(last_name, ' ')+1) 
            WHEN last_name is NULL  
                THEN substr(first_name, instr(first_name, ' ')+1) 
        END AS last_name, 
        CASE 
            WHEN instr(email, '@') <> 0 
                THEN CASE  
                    WHEN instr(email, ' ') = 0 
                        THEN email 
                    ELSE substr(email, 0,  instr(email, ' ')) 
                END  
        END AS email, 
         
        CASE 
            WHEN instr(email, '@') <> 0 
                THEN CASE  
                    WHEN instr(email, ' ') = 0 
                        THEN NULL 
                    ELSE regexp_replace(substr(email,instr(email, ' ')+1), '[_ \-]') 
                END  
            ELSE regexp_replace(email, '[_ \-]') 
        END AS phone, 
        CASE  
            WHEN substr(gender, 1, 1) = 'F' THEN 0 
            ELSE 1 
        END AS gender 
    FROM 
    (
    	SELECT * FROM dataSource
    	UNION ALL 
		SELECT * FROM dataSource
    	) ds

     ) t;
SELECT * FROM dataSource_01;


