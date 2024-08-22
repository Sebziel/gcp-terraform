# Use the official MySQL image as our base image
FROM ubuntu:latest

COPY . /app
RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping python3-venv -y
RUN python3 -m venv /app/venv
WORKDIR /app
RUN /app/venv/bin/pip install .

#Commented out, as in this project k8s is used, and the amount of users is defined in the deployment file.
#CMD ["pythondb", "-u 50"]