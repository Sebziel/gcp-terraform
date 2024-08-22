# Use the official MySQL image as our base image
FROM ubuntu:latest

RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping dnsutils curl zip python3-venv -y

CMD ["tail", "-f", "/dev/null"]