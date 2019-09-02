FROM postgres:10

RUN apt-get update
RUN apt-get -y install postgresql-10-pgtap

ENV POSTGRES_PASSWORD="postgres"

RUN echo "create user test with password 'test'; create database \"test\" owner test;" > /docker-entrypoint-initdb.d/boot.sql
