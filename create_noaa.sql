SET statement_timeout = 0;                             
SET lock_timeout = 0;                                  
SET client_encoding = 'UTF8';                          
SET standard_conforming_strings = on;                  
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;                     
SET xmloption = content;                               
SET client_min_messages = warning;                     
SET row_security = off;    

CREATE DATABASE noaa_db;
ALTER DATABASE noaa_db OWNER TO pseed;
GRANT ALL ON DATABASE noaa_db TO pseed;

\c noaa_db;

CREATE TABLE public.noaa_data (
date_exec date NOT NULL, 
tmax integer,
tmin integer,
tavg integer,
prcp integer,
snwd integer,
snow integer,
hum integer, 
awdr integer, 
awnd integer, 
station_id character varying(11) NOT NULL,
description character varying(32),
PRIMARY KEY (station_id,date_exec)
);

COMMENT ON COLUMN public.noaa_data.tmax IS 'максимальна температура за добу, десяті долі градусів';
COMMENT ON COLUMN public.noaa_data.tmin IS 'мінімальна температура за добу, десяті долі градусів';
COMMENT ON COLUMN public.noaa_data.tavg IS 'середня температура за добу, десяті долі градусів';
COMMENT ON COLUMN public.noaa_data.prcp IS 'опади за добу, десяті долі мм';
COMMENT ON COLUMN public.noaa_data.hum  IS 'вологість повітря, %';
COMMENT ON COLUMN public.noaa_data.snow IS 'Снігопад, мм';
COMMENT ON COLUMN public.noaa_data.snwd IS 'Глибина снігу, мм';
COMMENT ON COLUMN public.noaa_data.awdr IS 'Середній добовий напрямок вітру (градуси)';
COMMENT ON COLUMN public.noaa_data.awnd IS 'Середня добова швидкість вітру (десяті частки метрів за секунду)';

ALTER TABLE noaa_data OWNER TO pseed;
