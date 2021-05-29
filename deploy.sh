
#fandogh volume add --name vol1 -c 10

#fandogh service apply -f fandogh-mysql-deployment.yml -p DB_PASSWORD=the-secret-way-to-doing-stuff


fandogh managed-service deploy mysql 5.7 \
     -c service_name=mega-electric-mysql \
     -c mysql_root_password=the-secret-way-to-doing-stuff\
     -c phpmyadmin_enabled=false \
     -m 500Mi