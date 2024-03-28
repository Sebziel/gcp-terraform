# Use the official MySQL image as our base image
FROM ubuntu:latest

COPY . /app
RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping -y
WORKDIR /app
RUN pip3 install .

#CMD ["pythondb", "-u 50"]