docker build . -t dbflask
docker run -d dbflask
docker exec -it {image_id} /bin/bash