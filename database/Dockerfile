FROM mysql:8.0

COPY database/schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY database/init.sql /docker-entrypoint-initdb.d/02-init.sql
