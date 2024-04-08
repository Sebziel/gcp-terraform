FROM ubuntu:latest

RUN apt-get update
RUN apt install nano iputils-ping dnsutils openjdk-17-jdk maven git curl -y
RUN git clone https://github.com/spring-projects/spring-petclinic.git
WORKDIR /spring-petclinic
#To build and run locally:
#RUN ./mvnw package
#CMD ["tail", "-f", "/dev/null"]