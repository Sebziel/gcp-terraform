# PythonDB Project Readme

## Introduction

This project is titled PythonDB. It is primarily written in Python 3.12, and is developed to generate random user data for storage in a MySQL database which could prove valuable for development or testing purposes.

## Technologies Used

- Python: The project is entirely written in Python.
- Docker: The application is containerized using Docker for easy deployment and scaling.
- MySQL: All the data is stored using a MySQL database.
- SQLAlchemy: The SQLAlchemy library is used for object-relational mapping (ORM) hence, acting as an intermediary for Python to interact with the databases.
- faker: The Faker library is used to generate fake user data. 
- pymysql: The PyMySQL library aids Python to make connections with MySQL.
- click: The click library is used to create command line interfaces.

## How to Run

The entry point for the PythonDB application is the Cli.py file. A typical command to run the project can look like this:

```sh
python -m PythonDb.cli -u 50 -v
```
This command states that Python module (-m) PythonDb.cli to generate (-u) 50 users in verbose (-v) mode will be run.

Instead of executing the `cli.py` directly, it is more suitable to install the PythonDb package and then execute the installed command `pythondb` as follows:

```
pip install .
pythondb -u 50 -v
```

Which by default is installed in dockercontainer

## DB Configuration 

The database can be configured by changing the following line in DbConnection.py:

```sh
engine=create_engine("mysql+pymysql://admin:nimda@sz-mysql-service.default.svc.cluster.local/mydatabase")
```

Here, the connection string for the database is defined including the database engine (mysql+pymysql), the user (admin), the password (nimda), the host (sz-mysql-service.default.svc.cluster.local), and the name of the database (mydatabase). Please note, these values should be adjusted to match your specific database configuration.

In case your database runs on a different port, you need to specify it in the host part right after a colon.

## Note

The PythonDB project can be run standalone, however it was designed to be deployed on Kubernetes for more streamlined scaling according to the number of users. The number of users can be defined in the Kubernetes deployment file under such circumstances.