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

create or replace view raw.eurostat_freq_dimensions
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/FREQ.csv');

create or replace view raw.eurostat_unit_dimensions
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/UNIT.csv');

create or replace view raw.eurostat_geo_dimensions
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/GEO.csv');

create or replace view raw.eurostat_siec_dimensions
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/SIEC.csv');

create or replace view raw.eurostat_partner_dimensions
as
select *
from read_csv('__DATA_PATH__/processed/eurostat/dimensions/PARTNER.csv');