#!/bin/bash

docker build ./sz_mysql_image -t $LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/sz_mysql_image:v1

echo "Finished building image"

echo "Printing vars:"
echo $LOCATION
echo $PROJECT
echo $REPO_ID
echo "printing image name:"
echo "$LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/sz_mysql_image:v1"

docker push $LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/sz_mysql_image:v1

echo "Building pythondb utility image"
docker build ./PythonDB -t $LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/pythondb:v1
echo "Pushing pythondb utility image:"
docker push $LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/pythondb:v1


us-central1-docker.pkg.dev/playground-s-11-5ae8655e/my-repository/pythondb