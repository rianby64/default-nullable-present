
create or replace function send_jsonrpc(request json)
  returns void
  language 'plpgsql' volatile
as $$
declare
  source text;
  target text;
  prime boolean;
  context json;
  row json;
  pk json;
  method text;
  r record;
  p record;
begin
  context := request ->> 'Context';
  source := context ->> 'Source';
  target := context ->> 'Target';
  prime := context ->> 'Prime';
  method := request ->> 'Method';
  row := request ->> 'Row';
  pk := request ->> 'PK';

  select
    "ID",
    "Field1",
    "Field2",
    "Field3",
    "Field4"
    from json_to_record(row)
    as "Table"(
      "ID" integer,
      "Field1" character varying(255),
      "Field2" character varying(255),
      "Field3" character varying(255),
      "Field4" character varying(255)
    )
    into r;

  select
    "ID"
    from json_to_record(pk)
    as "Table"(
      "ID" integer
    )
    into p;

  if method = 'insert' then
    insert into "Table"(
      "Field1",
      "Field2",
      "Field3",
      "Field4"
    ) values (
      r."Field1",
      r."Field2",
      r."Field3",
      r."Field4"
    );
    return;
  end if;

  if method = 'delete' then
    raise notice 'using delete = %', p;
    delete from "Table" where "ID"=p."ID";
    return;
  end if;

  if method = 'update' then
    update "Table" set
      "Field1"=r."Field1",
      "Field2"=r."Field2",
      "Field3"=r."Field3",
      "Field4"=r."Field4"
    where
      "ID"=r."ID";
    return;
  end if;

end;
$$;