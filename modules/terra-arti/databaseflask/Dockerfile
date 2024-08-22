# Use the official MySQL image as our base image
FROM ubuntu:latest

ENV USERNAME=admin
ENV DBIP=sz-mysql-service
ENV PASSWORD=nimda

RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping dnsutils python3-venv -y
RUN python3 -m venv /app/venv
RUN /app/venv/bin/pip install sqlalchemy pymysql flask cryptography
COPY . /app
EXPOSE 5000

CMD [ "/app/venv/bin/python", "/app/dbflask.py"]