
#fandogh volume add --name vol1 -c 10
docker build  -t razear/mega-electric-mysql:latest -t razear/mega-electric-mysql:$SHA -f Dockerfile .
docker push razear/mega-electric-web-app:latest
docker push razear/mega-electric-web-app:$SHA
#fandogh service apply -f mysql-deployment.yml -p DB_PASSWORD=the-secret-way-to-doing-stuff

fandogh service deploy  --image razear/mega-electric-mysql --version $SHA --name mega-electric-mysql --internal  -p 3306 -d