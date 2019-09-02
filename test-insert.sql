/*
  Conclusion sobre INSERT
  considerese la definicion de la siguiente columna:

    "Field3" character varying(255) default 'default field3',

  Claramente es posible realizar un insert
  INSERT INTO "Table"("Field2", "Field3") VALUES ('value 2', null);
  de modo que en la nueva entrada la columna "Field3" sea igual a null.

  Dicha operacion es valida para el caso cuando se trabaja con la tabla directamente,
  sin embargo, al utilizar una vista proxy, no existe la forma de determinar
  si la columna es igual a null o simplemente no esta indicada en la clausula INSERT.

  Por lo tanto, las dos siguientes clasulas son identicas:

  INSERT INTO "ViewTable"("Field2", "Field3") VALUES ('value 2', null);
  INSERT INTO "ViewTable"("Field2") VALUES ('value 2');
*/

--                    NotNull                               NotNull
--                                       Default            Default
insert into "ViewTable"
  ("Field1",          "Field2",          "Field3",          "Field4") values
  ('Case 1::Value 1', 'Case 1::Value 2', 'Case 1::Value 3', 'Case 1::Value 4');
/*
{"Field1":"Case 1::Value 1",
 "Field2":"Case 1::Value 2",
 "Field3":"Case 1::Value 3",
 "Field4":"Case 1::Value 4"}
*/

insert into "ViewTable"
  (                   "Field2",          "Field3", "Field4") values
  (                   'Case 2::Value 2', 'Case 2::Value 3', 'Case 2::Value 4');
/*
{"Field1":null,
 "Field2":"Case 2::Value 2",
 "Field3":"Case 2::Value 3",
 "Field4":"Case 2::Value 4"}
*/

insert into "ViewTable"
  (                   "Field2",                             "Field4") values
  (                   'Case 3::Value 2',                    'Case 3::Value 4');
/*
{"Field1":null,
 "Field2":"Case 3::Value 2",
 "Field3":"default field3",
 "Field4":"Case 3::Value 4"}
*/

insert into "ViewTable"
  (                   "Field2") values
  (                   'Case 4::Value 2');
/*
{"Field1":null,
 "Field2":"Case 4::Value 2",
 "Field3":"default field3",
 "Field4":"default field4"}
*/

select is(
  (select json_agg(t)::text from (
    select "Field1", "Field2", "Field3", "Field4"
    from "Table") t),
'[{"Field1":"Case 1::Value 1","Field2":"Case 1::Value 2","Field3":"Case 1::Value 3","Field4":"Case 1::Value 4"}, 
 {"Field1":null,"Field2":"Case 2::Value 2","Field3":"Case 2::Value 3","Field4":"Case 2::Value 4"}, 
 {"Field1":null,"Field2":"Case 3::Value 2","Field3":"default field3","Field4":"Case 3::Value 4"}, 
 {"Field1":null,"Field2":"Case 4::Value 2","Field3":"default field3","Field4":"default field4"}]',
  'Table has the expected cases for insert'
);