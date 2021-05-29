FROM mysql:8.0
ENV MYSQL_ROOT_PASSWORD the-secret-way-to-doing-stuff
ENV MYSQL_DATABASE inventory

EXPOSE 3306