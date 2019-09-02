FROM centos:latest

RUN yum update -y

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm epel-release.noarch

RUN yum install -y postgresql10.x86_64

RUN mkdir /sql
WORKDIR /sql

COPY . .

ENV PGPASSWORD="test"
ENV PGHOST="test-prepare"
ENV PGUSER="test"
ENV PGDATABASE="test"

CMD ["psql", "-f", "test.sql"]
