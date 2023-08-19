# Pre-requisits

docker volume create config-volume <br>
docker volume create db-volume

# Start Application 
docker-compose -f docker-composer.yaml up --build -d

# Check Version 
docker exec -it $(docker ps | grep "chain-main-image" | awk '{print $1}') bin/chain-maind version
