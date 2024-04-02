# Project databaseFlask

### Usefull commands

'''docker build . -t dbflask''' - build image
'''docker run -d dbflask''' - run image
'''docker exec -it {image_id} /bin/bash''' - exec into image
Projects requires a running mysqlinstance, that can be found in ../sz_mysql directory. In order to configure connetion locally instead of using the k8s deployments, change the *DBIP* Variable in dockerfile and rebuild the image.

## Overview 

This project consists of a basic Flask application that uses SQLAlchemy to connect to a MySQL database. It provides an API for retrieving and searching for users in the database.

## Application Files
- **app.py**: This script sets up the SQLAlchemy engine to connect with the MySQL database and defines a User model to represent a user table from the database. It includes functions for retrieving a defined number of users, and for querying users by firstname and lastname.

- **dbflask.py**: This script is the Flask application that provides the API endpoints for the functionality in app.py. It can return a specified number of users from the database and can find users matching a given firstname and lastname. It uses JSON to present the information from the database in a readable format.

- **Dockerfile**: This file is used to dockerize the application. It sets up a Linux environment with python, pip, MySQL client module, and other necessary tools, then copies the application into the container and sets it to run when the container is started.

## Libraries Used
- `sqlalchemy`: SQL toolkit and Object-Relational Mapping (ORM) system for Python.
- `flask`: A web framework, it’s a Python module that lets you develop web applications easily.
- `os`: Provides a way of using operating system dependent functionality.
- `pymysql`: Python MySQL client library.
- `cryptography`: Used to solve many cryptography tasks you might face in a web application.

## Purpose of the project
The main aim of this project is to create an API that provides a way to retrieve and search for users from a MySQL database. The project demonstrates working with databases in Flask using SQLAlchemy, and showcases the process of dockerizing a Python application.

## URL Definitions & Expected Outcomes

The DBFlask application has the following endpoints:

- **`/api/getUsers`**: This endpoint is used to get a list of users from the database. By default, it returns 10 users. The number of users returned can be adjusted by providing an integer count in the 'count' argument in the request. The users are returned in JSON format. If there are no users, it will return an empty list.

  **Example Usage**: `/api/getUsers?count=5`

  **Expected Outcome**: A list of 5 users from the database in JSON format. 

- **`/api/findUser`**: This endpoint takes 'firstname' and/or 'lastname' as arguments, and returns a list of users that match either of these input fields. The input first name or last name should contain at least 3 characters to yield a result, else a message "Provide at least 3 characters for firstname or lastname" is returned. If no user matches the query, it will return a 404 error.

  **Example Usage**: `/api/findUser?firstname=John&lastname=Smith`

  **Expected Outcome**: A list of users with either first name 'John' or last name 'Smith' in JSON format. If such users exist, the details are returned, else it will return a 404 error.
  
These URLs are designed to be used in a web browser or called by a client-side application using the HTTP GET method.