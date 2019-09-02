
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
  method text;
  r record;
begin
  context := request ->> 'Context';
  source := context ->> 'Source';
  target := context ->> 'Target';
  prime := context ->> 'Prime';
  method := request ->> 'Method';
  row := request ->> 'Row';

  select
    "Field1",
    "Field2",
    "Field3",
    "Field4"
    from json_to_record(row)
    as "Table"(
      "Field1" character varying(255),
      "Field2" character varying(255),
      "Field3" character varying(255),
      "Field4" character varying(255)
    )
    into r;

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
    return;
  end if;

  if method = 'update' then
    return;
  end if;

end;
$$;