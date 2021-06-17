
#fandogh volume add --name vol1 -c 10
#docker build  --build-arg MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -t razear/mega-electric-mysql:latest -t razear/mega-electric-mysql:$SHA -f Dockerfile .



pip install fandogh-cli --upgrade
fandogh login --username $FANDOGH_USERNAME --password $FANDOGH_PASSWORD
fandogh namespace active --name $FANDOGH_NAMESPACE
fandogh service apply -f mysql-deployment.yml -p SHA=$SHA -p MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

#fandogh service deploy  --image razear/mega-electric-mysql --version $SHA --name mega-electric-mysql --internal  -p 3306  -d