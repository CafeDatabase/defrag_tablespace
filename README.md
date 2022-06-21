# defrag_tablespace
This project is made with one script to generate de SQL defrag commands, and a procedure named "rebuild_unusable" to rebuild all unusable indexes and index partitions after the segment reallocation.

This code assumes the following:

1.- The tablespace you want to defrag / move all segments to an empty tablespace, contains only segment of type TABLES, TABLE PARTITIONS, INDEXES, INDEX PARTITIONS, LOBs and LOB PARTITIONS.

2.- The target tablespace is preferiblely empty, and its size is minimum the total amount of bytes allocated by segments in the initial tablespace. 

After you launch the script in sqlplus, you will be prompted for the source tablespace and the target tablespace. Those two variables can't contain spaces and must match the tablespace name, so you must enter them in uppercase.

It will generate a script named   defragmenta_SOURCETBS-TARGETTBS-script.sql and you may launch it directly in the sqlplus console like this



$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Tue Jun 21 16:58:54 2022
Version 19.14.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.14.0.0.0

SQL>  @defragmenta_tablespace.sql
Tablespace source: ORIGIN
Tablespace target: TARGET
Size of initial segment extent  [default 1M]:

<SQL command generation and spooled to an sql script>
SQL commands --> ALTER TABLE MOVE / ALTER INDEX MOVE / etc.
<\SQL command generation and spooled to an sql script>
Script generated successfully. Run    @defragmenta_SOURCETBS-TARGETTBS-script.sql   to defrag.

  
And now you can just run the script and let all segments reorganize in the target tablespace.  

@defragmenta_SOURCETBS-TARGETTBS-script.sql

