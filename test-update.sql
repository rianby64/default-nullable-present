
update "ViewTable"
set
  "Field1" = 'update Case 1::Value 1',
  "Field2" = 'update Case 1::Value 2',
  "Field3" = 'update Case 1::Value 3',
  "Field4" = 'update Case 1::Value 4'
where
  "ID" = 1;

update "ViewTable"
set
  "Field1" = 'update Case 2::Value 1',
  "Field2" = 'update Case 2::Value 2',
  "Field3" = 'update Case 2::Value 3'
where
  "ID" = 2;

update "ViewTable"
set
  "Field1" = 'update Case 3::Value 1',
  "Field2" = 'update Case 3::Value 2'
where
  "ID" = 3;

update "ViewTable"
set
  "Field1" = 'update Case 4::Value 1'
where
  "ID" = 4;

select is(
  (select json_agg(t)::text from (
    select "ID", "Field1", "Field2", "Field3", "Field4"
    from "Table" order by "ID") t),
'[{"ID":1,"Field1":"update Case 1::Value 1","Field2":"update Case 1::Value 2","Field3":"update Case 1::Value 3","Field4":"update Case 1::Value 4"}, 
 {"ID":2,"Field1":"update Case 2::Value 1","Field2":"update Case 2::Value 2","Field3":"update Case 2::Value 3","Field4":"Case 2::Value 4"}, 
 {"ID":3,"Field1":"update Case 3::Value 1","Field2":"update Case 3::Value 2","Field3":"default field3","Field4":"Case 3::Value 4"}, 
 {"ID":4,"Field1":"update Case 4::Value 1","Field2":"Case 4::Value 2","Field3":"default field3","Field4":"default field4"}]',
  'Table has the expected cases for update'
);