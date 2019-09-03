
delete from "ViewTable"
where
  "ID" = 4;

select is(
  (select json_agg(t)::text from (
    select "ID", "Field1", "Field2", "Field3", "Field4"
    from "Table" order by "ID") t),
'[{"ID":1,"Field1":"Case 1::Value 1","Field2":"Case 1::Value 2","Field3":"Case 1::Value 3","Field4":"Case 1::Value 4"}, 
 {"ID":2,"Field1":null,"Field2":"Case 2::Value 2","Field3":"Case 2::Value 3","Field4":"Case 2::Value 4"}, 
 {"ID":3,"Field1":null,"Field2":"Case 3::Value 2","Field3":"default field3","Field4":"Case 3::Value 4"}]',
  'Table has the expected cases for delete'
);