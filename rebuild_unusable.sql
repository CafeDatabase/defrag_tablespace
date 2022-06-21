create or replace procedure rebuild_unusable is
       sentencia varchar2(1000);
begin
    for x in (select owner, index_name from dba_indexes where status='UNUSABLE')
    loop
       sentencia:='alter index '||x.owner||'.'||x.index_name||' rebuild online parallel 120';
       execute immediate sentencia;
    end loop;
    for x in (select index_owner, index_name, partition_name from dba_ind_partitions where status='UNUSABLE')
    loop
       sentencia:='alter index '||x.index_owner||'.'||x.index_name||' rebuild partition '||x.partition_name||' online parallel';
       execute immediate sentencia;
    end loop;
end;
/
