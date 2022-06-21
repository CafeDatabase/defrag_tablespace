-- DEFRAGMENTA_TABLESPACE.SQL --

set verify off
set lines 200
set pages 10000
set heading off
set echo off
set feedback off
-- define tablespace_origen=ORIGIN
-- define tablespace_destino=SOURCE
-- define t_extension_inicial=1
accept tablespace_origen prompt 'Tablespace source: '
accept tablespace_destino prompt 'Tablespace target: '
accept t_extension_inicial default '1' prompt 'Size of initial segment extent [default 1M]:'
spool defragmenta_&tablespace_origen-&tablespace_destino-script.sql
select 'alter table '||owner||'.'||table_name||
       ' move tablespace &tablespace_destino storage (initial &t_extension_inicial M) nologging parallel;'
       ||chr(10)|| ' -- exec rebuild_unusable;'
from dba_tables
where upper(tablespace_name)='&tablespace_origen'
union all
select 'alter table '||table_owner||'.'||table_name||
       ' move partition '||partition_name||
       '   tablespace &tablespace_destino storage (initial &t_extension_inicial M) nologging parallel;'
       ||chr(10)|| '-- exec rebuild_unusable;'
from dba_tab_partitions
where upper(tablespace_name)='&tablespace_origen'
union all
select 'alter index '||owner||'.'||index_name||
       ' rebuild tablespace &tablespace_destino storage (initial &t_extension_inicial M) nologging parallel;'
from dba_indexes
where upper(tablespace_name)='&tablespace_origen'
union all
select 'alter index '||index_owner||'.'||index_name||
       ' rebuild partition '||partition_name||
       ' tablespace &tablespace_destino storage (initial &t_extension_inicial M) nologging parallel;'
from dba_ind_partitions
where upper(tablespace_name)='&tablespace_origen'
union all
select 'alter table '||owner||'.'||table_name||' move lob ('||column_name||') store as  (tablespace &tablespace_destino) nologging parallel;'
from dba_lobs where tablespace_name='&tablespace_origen'
union all
select 'alter table '||table_owner||'.'||table_name||' move partition '||PARTITION_NAME||' lob ('||column_name||') store as  (tablespace &tablespace_destino) nologging parallel;'
from dba_lob_partitions where tablespace_name='&tablespace_origen'
union all
select 'alter tablespace &tablespace_origen coalesce;' from dual
union all
select 'exec rebuild_unusable;' from dual;
spool off
select 'Script generated successfully. Run   @defragmenta_&tablespace_origen-&tablespace_destino-script.sql   to defrag.' from dual;

