import pandas
import jaydebeapi

conn = jaydebeapi.connect('oracle.jdbc.driver.OracleDriver','jdbc:oracle:thin:demipt/8@de-oracle.8.ru:1521/8',['8','8'],'/home/8/Документы/8/sqldeveloper/jdbc/lib/ojdbc8.jar')
curs = conn.cursor()

df = pandas.read_excel( 'cities_population.xlsx', sheet_name='cities', header=0, index_col=None, engine='openpyxl')
curs.executemany( """insert into demipt.chrn_cities( city, country, population ) values ( ?, ?, ? ) """, df.values.tolist() )

curs.execute("""select 
    ct.city,
    cnt.country_name country,
    ct.population
from demipt.chrn_cities ct
left join demipt.countries cnt
on ct.country = cnt.id
""")
result = curs.fetchall()

names = [ x[0] for x in curs.description ]
df = pandas.DataFrame( result, columns = names )

df.to_excel( 'cities_output.xlsx', sheet_name='cities', header=True, index=False )

curs.close()
conn.close()
