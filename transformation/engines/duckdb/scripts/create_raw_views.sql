create schema if not exists raw;

create or replace view raw.comext_oil_imports_value 
as
select *
from read_parquet('__DATA_PATH__/processed/comext/facts/oil_imports/value/*.parquet');

create or replace view raw.comext_oil_imports_quantity 
as
select *
from read_parquet('__DATA_PATH__/processed/comext/facts/oil_imports/quantity/*.parquet');

create or replace view raw.comext_gas_imports_value
as
select *
from read_parquet('__DATA_PATH__/processed/comext/facts/gas_imports/value/*.parquet');

create or replace view raw.comext_gas_imports_quantity
as
select *
from read_parquet('__DATA_PATH__/processed/comext/facts/gas_imports/quantity/*.parquet');

create or replace view raw.eurostat_dimensions_freq
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/FREQ.csv');

create or replace view raw.eurostat_dimensions_unit
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/UNIT.csv');

create or replace view raw.eurostat_dimensions_geo
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/GEO.csv');

create or replace view raw.eurostat_dimensions_siec
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/SIEC.csv');

create or replace view raw.eurostat_dimensions_partner
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/PARTNER.csv');