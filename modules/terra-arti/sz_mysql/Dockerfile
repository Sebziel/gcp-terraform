# Use the official MySQL image as our base image
FROM docker.io/mysql:8.0

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=nimda
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=nimda
# Below might be used as an alternative for generating some data, by default the 2200005UsersBackup.sql is used.
# COPY baseusers.sql /docker-entrypoint-initdb.d
# COPY orders.sql /docker-entrypoint-initdb.d
COPY database.sql.tar.gz /
RUN tar -xzf database.sql.tar.gz -C /docker-entrypoint-initdb.d
RUN rm /database.sql.tar.gz
# EXPOSE port 3306 for other containers to connect
EXPOSE 3306

# Start the MySQL server on container launch
CMD ["mysqld"]