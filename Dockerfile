FROM mysql:8.0
ENV MYSQL_ROOT_PASSWORD the-secret-way-to-doing-stuff
ENV MYSQL_DATABASE inventory
ADD schema.sql /docker-entrypoint-initdb.d
EXPOSE 3306