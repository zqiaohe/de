
-- Создаем таблицу-источник, заполняем ее записями

drop table demipt.bzsq_source1;
create table demipt.bzsq_source1(
	id number,
	val varchar2(50),
	update_dt date );

insert into demipt.bzsq_source1( id, val, update_dt ) values ( 1, 'A', sysdate );
insert into demipt.bzsq_source1( id, val, update_dt ) values ( 2, 'B', sysdate );
insert into demipt.bzsq_source1( id, val, update_dt ) values ( 3, 'C', sysdate );
commit;

-- Создаем таблицу STG
drop table demipt.bzsq_stg1;
create table demipt.bzsq_stg1(
	id number,
	val varchar2(50),
	update_dt date );
drop table demipt.bzsq_stg1_del;
create table demipt.bzsq_stg1_del(
	id number );

-- Создаем таблицу-приемник (таблицу хранилища данных)
drop table demipt.bzsq_target1;
create table demipt.bzsq_target1(
	id number,
	val varchar2(50),
	effective_from_dt date,
	effective_to_dt date,
	deleted_flg char( 1 )
	);

-- Создаем таблицу с метададанными и заполняем ее начальным решением (пока данных не было, ставим заведомо минимальную дату - 1900 год)
drop table demipt.bzsq_meta1;
create table demipt.bzsq_meta1(
	dbname varchar2(30),
	tablename varchar2(30),
	last_update date );
insert into demipt.bzsq_meta1( dbname, tablename, last_update ) values ( 'DEMIPT', 'TARGET1', to_date( '1900-01-01', 'YYYY-MM-DD' ) );	
commit;

-- Выполяем инкрементальную загрузку

-- начало транзакции

-- 1. Очистка данных из STG
delete from demipt.bzsq_stg1;
delete from demipt.bzsq_stg1_del;

-- 2. Захват данных из источника в STG
insert into demipt.bzsq_stg1( id, val, update_dt )
select 
	id, 
	val, 
	update_dt 
from demipt.bzsq_source1
where update_dt > (
	select last_update from meta1 where dbname = 'DEMIPT' and tablename = 'TARGET1'
);

-- 3. Вливаем данные в хранилище

insert into demipt.bzsq_target1( id, val, effective_from_dt, effective_to_dt, deleted_flg )
select
	id,
	val,
	update_dt,
	to_date( '2999-12-31', 'YYYY-MM-DD' ),
	'N'
from demipt.bzsq_stg1;

merge into demipt.bzsq_target1
using stg1
on ( demipt.bzsq_target1.id = demipt.bzsq_stg1.id and demipt.bzsq_target1.effective_from_dt < demipt.bzsq_stg1.update_dt )
when matched then update set 
    demipt.bzsq_target1.effective_to_dt = demipt.bzsq_stg1.update_dt - interval '1' second
		where demipt.bzsq_target1.effective_to_dt = to_date( '2999-12-31', 'YYYY-MM-DD' );

-- 4. Захватываем ключи для проверки удалений (опционально) 

insert into demipt.bzsq_target1( id )
select id from demipt.bzsq_stg1 
left join bzsq_target1 on 
;

-- 5. Удаляем удаленные записи в целевой таблице (опционально)

insert into demipt.bzsq_stg1_del( id )
select id from demipt.bzsq_source1;


-- 6. Обновляем метаданные - дату максимальной загрузуки
update demipt.bzsq_meta1 
set last_update = ( select max( update_dt ) from demipt.bzsq_stg1 )
where  dbname = 'DEMIPT' and tablename = 'TARGET1';

-- 7. Фиксируется транзакция
commit;
