
#fandogh volume add --name vol1 -c 10
#docker build  --build-arg MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -t razear/mega-electric-mysql:latest -t razear/mega-electric-mysql:$SHA -f Dockerfile .
docker build  --build-arg -t razear/mega-electric-mysql:latest -t razear/mega-electric-mysql:$SHA -f Dockerfile .
docker push razear/mega-electric-mysql:latest
docker push razear/mega-electric-mysql:$SHA

 \


fandogh service apply -f mysql-deployment.yml -p SHA=$SHA -p MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

#fandogh service deploy  --image razear/mega-electric-mysql --version $SHA --name mega-electric-mysql --internal  -p 3306  -d