#!/bin/bash

## enviorment 

export no_proxy=169.254.*
db_instance=$(${User}/${Password}@${Instance}:${Port}/${SID})

## execute

### Get Instance-id
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)

### Get Oracle Tablespaces
total_size_mb=$(/usr/bin/sqlplus ${db_instance} @oracle_tablespace_total.sql; exit; )
total_used_mb=$(/usr/bin/sqlplus ${db_instance} @oracle_tablespace_used.sql; exit; )
total_free_bytes=$(/usr/bin/sqlplus ${db_instance} @oracle_tablespace_free.sql; exit; )
total_used_rates=$(/usr/bin/sqlplus ${db_instance} @oracle_tablespace_rates.sql; exit; )

### Put AWS CloudWatch Metric
aws cloudwatch put-metric-data \
--metric-name total-size-mb \
--dimensions Instance=${instance_id} \
--namespace "Custom" --value ${total_size_mb}

aws cloudwatch \
put-metric-data \
--metric-name total-used-mb \
--dimensions Instance=${instance_id} \
--namespace "Custom" --value ${total_used_mb}

aws cloudwatch \
put-metric-data \
--metric-name total-free-bytes \
--dimensions Instance=${instance_id} \
--namespace "Custom" --value ${total_free_bytes}

aws cloudwatch \
put-metric-data \
--metric-name total-used-rates \
--dimensions Instance=${instance_id} \
--namespace "Custom" --value ${total_used_rates}

exit
