drop table if exists congress_members;

create table if not exists congress_members (
  id text primary key,
  name text,
  birthday date,
  gender text,
  office text,
  state text,
  district integer,
  latest_term_start date,
  latest_term_end date,
  party text
);

insert into congress_members
select 
  legislators.value ->> '$.id.bioguide' as id,
  legislators.value ->> '$.name.official_full' as name,
  legislators.value ->> '$.bio.birthday' as birthday,
  legislators.value ->> '$.bio.gender' as gender,
  latest_term.value ->> '$.type' as office,
  latest_term.value ->> '$.state' as state,
  latest_term.value ->> '$.district' as district,
  latest_term.value ->> '$.start' as latest_term_start,
  latest_term.value ->> '$.end' as latest_term_end,
  latest_term.value ->> '$.party' as party
from json_each(readfile('legislators-current.json')) as legislators
left join json_each(legislators.value, '$.terms') as latest_term 
  on date('now') between latest_term.value ->> '$.start' and latest_term.value ->> '$.end';

select * 
from congress_members
limit 10;