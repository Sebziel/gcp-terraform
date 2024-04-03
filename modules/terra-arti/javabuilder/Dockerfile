FROM ubuntu:latest

RUN apt-get update
RUN apt install python3-pip nano  mysql-client iputils-ping dnsutils openjdk-17-jdk maven git -y
RUN git clone https://github.com/spring-projects/spring-petclinic.git
WORKDIR /spring-petclinic
#RUN ./mvnw package
#CMD ["tail", "-f", "/dev/null"]