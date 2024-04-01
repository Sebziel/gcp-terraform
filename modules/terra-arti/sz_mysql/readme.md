# Project SZ-MySQL

### Usefull commands
'''docker build . -t mysql''' - build image
'''docker run -d -p 3306:3306 --name mysql mysql''' -run container

Connecting locally (requires mysql clinet):
'''mysql -h 127.0.0.1 -u admin -p'''


## Description

This project encapsulates a MySQL database within a Docker container. It contains a pre-configured Dockerfile that builds a MySQL 8.0 server using the official MySQL image. The MySQL server has been configured with a database, user credentials, and initiation scripts for the construction of user and order tables included. A backup of an already created database with 25000 users (including the base users) and 5000 orders is also part of the project.

## Files

- `Dockerfile`: Contains the instructions for Docker to build the MySQL server.
- `baseusers.sql`: Initial configuration script that creates users table and adds in examples of base users.
- `orders.sql`: Initial configuration script that creates orders table.
- `database.sql.tar.gz`: A compressed SQL file that includes a backup of already created database with 25000 users (including the base users) and 5000 orders.
- `readme.md`: The file you are reading right now.

## Setup/Installation

1. Install Docker on your system
2. Clone this repository to your local machine. 
3. Navigate to the cloned directory in your terminal.

To build the Docker image using the Dockerfile, run the following command in terminal:

```bash
docker build -t my_sql_server .
```

To launch the MySQL server as a Docker container, use:

```bash
docker run -d -p 3306:3306 --name my_sql_instance my_sql_server
```

## Connecting to the Database

To connect to the running MySQL instance, execute : 

```bash
docker exec -it my_sql_instance mysql -u admin -p
```

And enter the password `nimda` when prompted.

Once you are connected, you will have access to the `mydatabase` schema and all its tables.

The MySQL server will be accessible from other Docker containers or from your local host on port 3306.

## Usage Notes
- If you wish to initialize the database a different way, you can modify the Dockerfile and uncomment the COPY instructions for `baseusers.sql` and `orders.sql` and comment the COPY and RUN instructions for `database.sql.tar.gz`. Then, rebuild the image. 
- If you want to generate some random data, you can call the `InsertRandomData()` procedure included in the `orders.sql` file.
- Ensure port 3306 is not being used by another service on your host machine when you start the Docker container. If that is the case, choose a different host port in the `docker run` command.