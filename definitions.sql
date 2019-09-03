
create or replace function send_jsonrpc(request json)
  returns void
  language 'plpgsql' volatile
as $$
begin
  perform pg_notify('jsonrpc', request::text);
end;
$$;

create table if not exists "Table"
(
  "ID" serial,
  "Field1" character varying(255),
  "Field2" character varying(255) not null,
  "Field3" character varying(255) default 'default field3',
  "Field4" character varying(255) not null default 'default field4',
  constraint "Table_pkey" primary key ("ID")
)
with (
  OIDS=false
);

create or replace view "ViewTable"("ID", "Field1", "Field2", "Field3", "Field4") as (
  select
    "ID",
    "Field1",
    "Field2",
    "Field3",
    "Field4"
  from "Table"
);

\ir ./definition-trigger.sql