#!/bin/bash
# Подготовка и загрузка метеоданных NOAA's National Weather Service в базу данных.
# Перед запуском нужно выставить переменные окружения с параметрами доступа к БД.
# . ~/env.sh

for date in 2021
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
          /TMAX/ { printf "select meteo_insert(\x27%s\x27, \x27%s\x27, \x27tmax\x27, %s);\n ",$1,$2,$4}
          /TMIN/ { printf "select meteo_insert(\x27%s\x27, \x27%s\x27, \x27tmin\x27, %s);\n ",$1,$2,$4}
          /TAVG/ { printf "select meteo_insert(\x27%s\x27, \x27%s\x27, \x27tavg\x27, %s);\n ",$1,$2,$4}
          /SNDW/ { printf "select meteo_insert(\x27%s\x27, \x27%s\x27, \x27snwd\x27, %s);\n ",$1,$2,$4}
          /SNOW/ { printf "select meteo_insert(\x27%s\x27, \x27%s\x27, \x27snow\x27, %s);\n ",$1,$2,$4}
          /PRCP/ { printf "select meteo_insert(\x27%s\x27, \x27%s\x27, \x27prcp\x27, %s);\n ",$1,$2,$4}
          ' ukraine.csv > climate.sql
	fi
date
echo $date," insert into DB"
psql -U $PGUSER -h $PGHOST -d $PGDATABASE -f climate.sql > pg_insert.out
echo "complete"
date
done
