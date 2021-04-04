SELECT SUM(ORDER_TOTAL), CUSTOMER_ID, FIRST_NAME FROM oe.orders
LEFT JOIN hr.employees ON CUSTOMER_ID = EMPLOYEE_ID
WHERE to_char(order_date, 'YYYY') = '2007' GROUP BY CUSTOMER_ID


SELECT SUM(ORDER_TOTAL) as summa, CUSTOMER_ID, FIRST_NAME, LAST_NAME FROM oe.orders
LEFT JOIN hr.employees ON CUSTOMER_ID = EMPLOYEE_ID
WHERE to_char(order_date, 'YYYY') = '2007' 
GROUP BY CUSTOMER_ID, FIRST_NAME, LAST_NAME
ORDER BY summa desc

SELECT SUM(ORDER_TOTAL) as summa, CUSTOMER_ID, FIRST_NAME, LAST_NAME,  SUM(ORDER_TOTAL) * 0.001 FROM oe.orders
LEFT JOIN hr.employees ON CUSTOMER_ID = EMPLOYEE_ID
WHERE to_char(order_date, 'YYYY') = '2007' 
GROUP BY CUSTOMER_ID, FIRST_NAME, LAST_NAME
ORDER BY summa desc

SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME, ROW_NUMBER() OVER (order by summa desc) rn, summa, salary FROM (
SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME, SUM(ORDER_TOTAL) summa, Salary FROM oe.orders
LEFT JOIN hr.employees ON CUSTOMER_ID = EMPLOYEE_ID
WHERE to_char(order_date, 'YYYY') = '2007' 
GROUP BY CUSTOMER_ID, FIRST_NAME, LAST_NAME, Salary
ORDER BY summa desc) t
