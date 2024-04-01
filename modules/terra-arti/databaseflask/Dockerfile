# Use the official MySQL image as our base image
FROM ubuntu:latest

ENV USERNAME=admin
ENV DBIP=172.17.0.3
ENV PASSWORD=nimda

RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping dnsutils -y
RUN pip install sqlalchemy pymysql flask cryptography
COPY . /app

CMD ["tail", "-f", "/dev/null"]