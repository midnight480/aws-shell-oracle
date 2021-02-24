
SET HEADING OFF

select
  round(nvl((total_bytes - free_total_bytes) / total_bytes * 100,100),2)
from
  ( select
        tablespace_name,
        sum(bytes) total_bytes
    from
        dba_data_files
    where
        tablespace_name = 'USERS'
    group by
        tablespace_name
  ),
  ( select
        tablespace_name free_tablespace_name,
        sum(bytes) free_total_bytes
    from
        dba_free_space
    where
        tablespace_name = 'USERS'
    group by
        tablespace_name
  )
where
  tablespace_name = free_tablespace_name(+)
/