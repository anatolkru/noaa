#!/bin/bash
# Подготовка и загрузка метеоданных NOAA's National Weather Service в базу данных.
# Перед запуском нужно выставить переменные окружения с параметрами доступа к БД.
# . ~/env.sh
# При необходимости перед первым запуском создать и подготовить БД noaa_db
# sudo -s ; su - postgres; psql
# postgres=# \i create_noaa.sql

if [[ -f climate.sql  ]]
  then
    rm climate.sql
fi

for date in 2022
  do
  n_file=$date
  wget -c ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/$n_file.csv.gz
  if [[ -f $n_file.csv.gz ]] 
    then 
      if [[ -f  $n_file.csv ]]
        then
          rm $n_file.csv
      fi
      gunzip -k $n_file.csv.gz 
      grep UPM $n_file.csv > ukraine.csv
      awk 'BEGIN { FS=","; }  
          /TMAX/  { printf "insert into noaa_data (station_id,date_exec,tmax) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set tmax=EXCLUDED.tmax;\n",$1,$2,$4}
          /TMIM/  { printf "insert into noaa_data (station_id,date_exec,tmin) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set tmin=EXCLUDED.tmin;\n",$1,$2,$4}
          /TAVG/  { printf "insert into noaa_data (station_id,date_exec,tavg) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set tavg=EXCLUDED.tavg;\n",$1,$2,$4}
          /SNWD/  { printf "insert into noaa_data (station_id,date_exec,snwd) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set snwd=EXCLUDED.snwd;\n",$1,$2,$4}
          /SNOW/  { printf "insert into noaa_data (station_id,date_exec,snow) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set snow=EXCLUDED.snow;\n",$1,$2,$4}
          /PRCP/  { printf "insert into noaa_data (station_id,date_exec,prcp) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set prcp=EXCLUDED.prcp;\n",$1,$2,$4}
          /AWDR/  { printf "insert into noaa_data (station_id,date_exec,awdr) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set awdr=EXCLUDED.awdr;\n",$1,$2,$4}
          /AWND/  { printf "insert into noaa_data (station_id,date_exec,awnd) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set awnd=EXCLUDED.awnd;\n",$1,$2,$4}
          /HUM/  { printf "insert into noaa_data (station_id,date_exec,hum) values (\x27%s\x27,\x27%s\x27,%s) on conflict (station_id,date_exec) do update set hum=EXCLUDED.hum;\n",$1,$2,$4}
          ' ukraine.csv >> climate.sql
	fi
echo "Insert into DB"
date
psql -U $PGUSER -h $PGHOST -d noaa_db -f climate.sql > pg_insert.out
date
echo "Complete!!!"
done
