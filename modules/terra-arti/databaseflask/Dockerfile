# Use the official MySQL image as our base image
FROM ubuntu:latest

ENV USERNAME=admin
ENV DBIP=sz-mysql-service
ENV PASSWORD=nimda

RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping dnsutils -y
RUN pip install sqlalchemy pymysql flask cryptography
COPY . /app
EXPOSE 5000

CMD [ "python3", "/app/dbflask.py"]