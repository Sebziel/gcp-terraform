#!/bin/bash

docker build $MODULE_PATH/$IMAGE -t $LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/$IMAGE:v1

echo "Finished building image"

echo "Printing vars:"
echo $LOCATION
echo $PROJECT
echo $REPO_ID
echo "$LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/$IMAGE:v1"

docker push $LOCATION-docker.pkg.dev/$PROJECT/$REPO_ID/$IMAGE:v1