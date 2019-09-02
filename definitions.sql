
\ir ./JSONRPC.sql

create table if not exists "Table"
(
  "Field1" character varying(255),
  "Field2" character varying(255) not null,
  "Field3" character varying(255) default 'default field3',
  "Field4" character varying(255) not null default 'default field4'
)
with (
  OIDS=false
);

create or replace view "ViewTable"("Field1", "Field2", "Field3", "Field4") as (
  select
    "Field1",
    "Field2",
    "Field3",
    "Field4"
  from "Table"
);

\ir ./definition-trigger.sql