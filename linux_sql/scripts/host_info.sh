#!/bin/bash

#This program runs once
#Arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
  echo  "Illegal number of parameters"
  exit 1
fi

#Setting var for commands that will be reused
specs=`lscpu`
hostname=$(hostname -f)

#Getting information
cpu_number=$(echo "$specs"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$specs" | egrep "^Arc\w+:" | awk '{print $2}')
cpu_model=$(echo "$specs" | egrep "^Model name:" | awk '{print substr($0, index($0,$3))}')
cpu_mhz=$(echo "$specs" | egrep "^Model name:" | awk '{print $7*1000}' | sed "s/GHz//" )
l2_cache=$(echo "$specs" | egrep "^L2" | awk '{print $3}')
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')

#Setting up insert statement to database
insert_stmt="INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem)
VALUES(1,'$hostname', '$cpu_number', '$cpu_achitecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$timestamp', '$total_mem' )"

export PGPASSWORD=$psql_password

#Insert into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?