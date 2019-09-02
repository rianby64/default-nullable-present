
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

create or replace function viewtable_insteadof()
  returns trigger
  language 'plpgsql' volatile
as $$
declare
  r record;
begin
  -- Construcciones genericas para INSERT, DELETE, UPDATE
  if tg_op = 'INSERT' then
    raise notice 'new = %', to_json(new);
    for r in (
      select
        row_to_json(ctx) as "Context",
        lower(tg_op) as "Method",
        row_to_json(t) as "Row"
      from (
        select
          tg_table_name as "Source",
          '_' || tg_table_name as "Target",
          current_database() as "Db",
          true as "Prime"
        ) as ctx, (
          select
            case when new."Field1" is null -- null,     not default
              then null
              else new."Field1"
            end as "Field1",
            case when new."Field2" is null -- not null, not default
              then null
              else new."Field2"
            end as "Field2",
            case when new."Field3" is null -- null,     default
              then 'default field3' -- repeat default value
              else new."Field3"
            end as "Field3",
            case when new."Field4" is null -- not null, default
              then 'default field4' -- repreat default value
              else new."Field4"
            end as "Field4"
        ) t
    ) loop
      perform send_jsonrpc(row_to_json(r));
    end loop;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    return new;
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;

  return null;
end;
$$;


drop trigger if exists action_viewtable on "ViewTable" cascade;
create trigger action_viewtable
  instead of insert or update or delete on "ViewTable"
  for each row
  execute procedure viewtable_insteadof();