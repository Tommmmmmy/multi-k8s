# A bash script that will help travis CI to deploy images to google cloud kubernetes
# The reason why we need two tags for each image:
# latest: for other teammates to start with this image easily
# Git SHA: tag each image version with git SHA so that kubectl can tell the image
# is different thus trigger an update in the container
docker build -t tommytang1995/multi-client:latest -t tommytang1995/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t tommytang1995/multi-server:latest -t tommytang1995/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t tommytang1995/multi-worker:latest -t tommytang1995/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push tommytang1995/multi-client:latest
docker push tommytang1995/multi-client:$SHA
docker push tommytang1995/multi-server:latest
docker push tommytang1995/multi-server:$SHA
docker push tommytang1995/multi-worker:latest
docker push tommytang1995/multi-worker:$SHA

# Apply all deployments and services under k8s dir
kubectl apply -f k8s

# Update images in three containers automatically
kubectl set image deployments/server-deployment server=tommytang1995/multi-server:$SHA
kubectl set image deployments/client-deployment client=tommytang1995/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=tommytang1995/multi-worker:$SHA