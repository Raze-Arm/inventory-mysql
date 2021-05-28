
fandogh volume add --name vol1 -c 10

fandogh service apply -f fandogh-mysql-deployment.yml -p mysql_root_password=$MYSQL_PASSWORD  -d
