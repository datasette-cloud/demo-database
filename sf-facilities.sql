create table sf_facilities (
  facility_id text,
  common_name text,
  owned_leased text,
  land_id integer,
  supervisor_district text,
  dept_id integer,
  department_name text,
  city_tenants text,
  address text,
  city text,
  zip_code text,
  data_loaded_at timestamp,
  data_last_updated timestamp,
  data_as_of timestamp,
  gross_sq_ft integer,
  block_lot text,
  latitude float,
  longitude float
);

insert into sf_facilities
select 
  value ->> '$.properties.facility_id'          as facility_id,
  value ->> '$.properties.common_name'          as common_name,
  value ->> '$.properties.owned_leased'         as owned_leased,
  value ->> '$.properties.land_id'              as land_id,
  value ->> '$.properties.supervisor_district'  as supervisor_district,
  value ->> '$.properties.dept_id'              as dept_id,
  value ->> '$.properties.department_name'      as department_name,
  value ->> '$.properties.city_tenants'         as city_tenants,
  value ->> '$.properties.address'              as address,

  value ->> '$.properties.city'                 as city,
  value ->> '$.properties.zip_code'             as zip_code,
  value ->> '$.properties.data_loaded_at'       as data_loaded_at,
  value ->> '$.properties.data_last_updated'    as data_last_updated,
  value ->> '$.properties.data_as_of'           as data_as_of,
  value ->> '$.properties.gross_sq_ft'          as gross_sq_ft,
  value ->> '$.properties.block_lot'            as block_lot,
  value ->> '$.properties.latitude'             as latitude,
  value ->> '$.properties.longitude'            as longitude
from json_each(
  readfile('sf-facilities.geojson'),
  '$.features'
);