import pandas
import jaydebeapi

conn = jaydebeapi.connect('oracle.jdbc.driver.OracleDriver','jdbc:oracle:thin:demipt/gandalfthegrey@de-oracle.chronosavant.ru:1521/deoracle',['demipt','gandalfthegrey'],'/home/zorigma/Документы/opt/sqldeveloper/jdbc/lib/ojdbc8.jar')
curs = conn.cursor()

df = pandas.read_excel( 'medicine.xlsx', sheet_name='hard', header=0, index_col=None, engine='openpyxl')
curs.execute(""" DROP TABLE demipt.analiz""")
curs.execute("""CREATE TABLE demipt.analiz
             (patid INTEGER not null,
              ancode CHAR(100) not null,
              anvalue CHAR(100) not null)
""")

curs.executemany( """INSERT into demipt.analiz ( patid, ancode, anvalue) values ( ?, ?, ? ) """, df.values.tolist() )

curs.execute("""
	SELECT mn2.name, mn2.phone, man2.name as anname,
	CASE
		WHEN substr(a1.anvalue, 1, 1) = 'П' then 'Положительный'
		WHEN substr(a1.anvalue, 1, 1) = '+' then 'Положительный'
		WHEN substr(a1.anvalue, 1, 1) = 'О' then 'Отрицательный'
		WHEN substr(a1.anvalue, 1, 1) = '-' then 'Отрицательный'
		WHEN regexp_replace(a1.anvalue, '[^[:digit:]]') > man2.max_value then 'Повышенный'
		WHEN regexp_replace(a1.anvalue, '[^[:digit:]]')  < man2.min_value then 'Пониженный'
		ELSE 'Нормальный'
    END AS value
	FROM
	(SELECT patid from 
	(SELECT patid,
	CASE
	WHEN substr(anvalue, 1, 1) = 'П' then 1
	WHEN substr(anvalue, 1, 1) = '+' then 1
	WHEN substr(anvalue, 1, 1) = 'О' then 0
	WHEN substr(anvalue, 1, 1) = '-' then 0
	WHEN regexp_replace(anvalue, '[^[:digit:]]') > man.max_value then 1
	WHEN regexp_replace(anvalue, '[^[:digit:]]')  < man.min_value then 1
	ELSE 0  END AS value  
	FROM demipt.analiz an
    LEFT JOIN med_an_name man
    ON trim(man.CODE) = trim(an.ancode)) tab
    group by patid
    having SUM(value) >=2) t1
    LEFT JOIN demipt.analiz a1
    ON t1.patid = a1.patid
    LEFT JOIN med_an_name man2
    ON trim(man2.CODE) = trim(a1.ancode)
    LEFT JOIN  med_names mn2 
    ON mn2.ID = a1.patid
    WHERE substr(a1.anvalue, 1, 1) = 'П' or substr(a1.anvalue, 1, 1) = '+' 
    or regexp_replace(a1.anvalue, '[^[:digit:]]') > man2.max_value
    or regexp_replace(a1.anvalue, '[^[:digit:]]')  < man2.min_value 

""")

result = curs.fetchall()

names = [ x[0] for x in curs.description ]
df = pandas.DataFrame( result, columns = names )
df.to_excel( 'minfo.xlsx', sheet_name='m', header=True, index=False )
curs.execute(""" DROP TABLE demipt.analiz2""")
curs.execute("""CREATE TABLE demipt.analiz2
             (name CHAR(100) not null,
              phone CHAR(100) not null,
              anname CHAR(100) not null,
              value CHAR(100) not null)
""")
curs.executemany( """INSERT into demipt.analiz2 ( name, phone, anname, value) values ( ?, ?, ?, ?) """, df.values.tolist() )
curs.close()
conn.close()