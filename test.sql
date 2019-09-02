
set plpgsql.extra_warnings to 'all';

\pset format unaligned
\pset tuples_only true
\pset pager off

\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true


-- Run the testing block for AAU, Projects, Concretize
-- Load the TAP functions.
begin;
create extension if not exists pgtap;

-- Load all the definitions.
\ir ./definitions.sql
\ir ./definitions.sql

-- Plan the tests.
select plan(16);


select has_table('Table');
select has_column('Table', 'Field1');

select has_column('Table', 'Field2');
select col_not_null('Table', 'Field2');

select has_column('Table', 'Field3');
select col_has_default('Table', 'Field3');

select has_column('Table', 'Field4');
select col_not_null('Table', 'Field4');
select col_has_default('Table', 'Field4');

SELECT has_view('ViewTable');
select has_column('ViewTable', 'Field1');

select has_column('ViewTable', 'Field2');
select has_column('ViewTable', 'Field3');
select has_column('ViewTable', 'Field4');

\ir ./test-insert.sql
\ir ./test-update.sql

-- Finish the tests and clean up.
select * from finish();
rollback;
