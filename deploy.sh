
#fandogh volume add --name vol1 -c 10

fandogh service apply -f fandogh-mysql-deployment.yml -p DB_PASSWORD=$MYSQL_PASSWORD
