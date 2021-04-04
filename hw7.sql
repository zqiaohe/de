
-- 1

SELECT customer_id, first_name, last_name, rn, summa, salary, 
	CASE 
		WHEN rn <= 3 THEN summa * 0.001
		ELSE 0 
	END premia 
FROM 
(	SELECT customer_id, first_name, last_name, 
		ROW_NUMBER() OVER (order by summa desc) rn, 
		summa, salary 
	FROM 
	(	SELECT customer_id, first_name, last_name, 
			SUM(order_total) summa, Salary 
		FROM oe.orders
		LEFT JOIN hr.employees ON customer_id = employee_id
		WHERE to_char(order_date, 'YYYY') = '2007' 
		GROUP BY customer_id, first_name, last_name, Salary
		ORDER BY summa desc
	)t
)t2

--2

SELECT DISTINCT t.phone, c.first_name, c.last_name FROM
(	SELECT phone, create_dt, 
		LAG(SUM(value), 1) OVER (PARTITION BY phone ORDER BY phone, create_dt) prev_value, 
		SUM(value) value, 
		LEAD(SUM(value), 1) OVER (PARTITION BY phone ORDER BY phone, create_dt) next_value 
	FROM baratin.payment_logs
	GROUP BY phone, create_dt
	ORDER BY phone, create_dt) t
LEFT JOIN baratin.phones pb ON pb.phone_num = t.phone
LEFT JOIN baratin.accounts a ON pb.account = a.account_id
LEFT JOIN baratin.clients c ON a.client = c.client_id
WHERE t.prev_value < t.value and t.value < t.next_value
