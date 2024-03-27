# PythonDB

### Description:

*Project creates a provided amount of users to a table in existing mysql instance.*
*Requires running mysql instance at localhost:3306 which can be created with Dockerfile by running below commands*

## Usage

Click module was used to make the application use a generic cli-like syntax.

>pythondb --help

## Intallation

Application is packed with setup python module. Make sure to have pip installed

>sudo apt python3-pip install

cd into project folder:

>cd ./PythonDB
>pip install .
> pythondb --help

```
pythondb --help
Usage: pythondb [OPTIONS]

Options:
  -u, --users INTEGER    Number of users to create
  -v, --verbose BOOLEAN  Printing additional things
  --help                 Show this message and exit.
```

## Environment Setup:

Building container image:

> podman build -t my_sql_container .

Running container:

> podman run -d --name my_mysql_container -p 3306:3306 --pull=never localhost/my_sql_container

#### Helpfull commands for running on a fresh VM:

##### Installing podman

>sudo apt update
>sudo apt install -y software-properties-common uidmap
>. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"

>wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O Release.key
sudo apt-key add - < Release.key

>sudo apt update
>sudo apt install -y podman

##### Installing my-sql client and connecting to DB to verify the application outcome:

>sudo apt install mysql-client #sql client installation
>mysql -h 127.0.0.1 -P 3306 -u admin -p

*In Mysql terminal*
>USE mydatabase;
>select * from users;

*Or with a on-liner:*
>mysql -u admin -p -h 127.0.0.1 -D mydatabase -e 'Select * from users;'


## Full usage expectation/ Runthrough example:

```
user@7f130cface1c:~/PythonDB$ mysql -u admin -p -h 127.0.0.1 -D mydatabase -e 'Select count(*) from users;'
Enter password: 
+----------+
| count(*) |
+----------+
|     2190 |
+----------+

user@7f130cface1c:~/PythonDB$ pythondb -u 100 -v True
Starting to create 100 users
Generating random user data
Finished generating random data in 2.966449139999895
finished creating users in: 0.0042629359995771665, proceeding to commiting users to Db
25% processed (25/100)
50% processed (50/100)
75% processed (75/100)
finished commiting users in: 0.0263088580004478

user@7f130cface1c:~/PythonDB$ mysql -u admin -p -h 127.0.0.1 -D mydatabase -e 'Select count(*) from users;'
Enter password: 
+----------+
| count(*) |
+----------+
|     2290 |
+----------+

user@7f130cface1c:~/PythonDB$ mysql -u admin -p -h 127.0.0.1 -D mydatabase -e 'Select * from users LIMIT 10;'
Enter password: 
+--------------------------------------+-------------+-----------+--------------------------+--------------+
| uuid                                 | firstname   | lastname  | email                    | phone_number |
+--------------------------------------+-------------+-----------+--------------------------+--------------+
| 000d9f14-aaba-4b30-a6d3-e7ee3490fd74 | Jonathan    | Long      | sgriffin@example.com     |    281355991 |
| 00219724-74a0-4c4c-837e-d0309bc2d1af | Christopher | Rogers    | iwalker@example.net      |    958846349 |
| 0046dfe9-4025-42f7-b4bc-3cc09daaac1b | Greg        | Hall      | garzabrian@example.com   |    166292997 |
| 004b439d-fff8-4e2f-b366-5aebe059c8a0 | Kevin       | Warren    | ystephens@example.org    |    937406222 |
| 0050fd68-65c7-41b0-94d4-fa67c8d34298 | Justin      | Lynch     | avilaalbert@example.org  |    483537212 |
| 007b415e-4e59-456c-8146-13cd4ffe9339 | Melissa     | Chen      | phyllissilva@example.org |    968415353 |
| 0087974d-618e-4cc2-b08e-33312d35d70e | John        | Alexander | qcox@example.net         |    428005238 |
| 008a651b-8c53-4b02-a755-3c55379a2f3f | Lori        | Murray    | yherrera@example.org     |    759232617 |
| 008fc57b-67ca-4243-988b-09f81938c584 | Isabella    | Bailey    | smithtara@example.com    |    223425739 |
| 00dc8b4f-c891-4ec0-9029-25e4f17b8dcb | Miguel      | Sullivan  | dcruz@example.com        |    937590228 |
+--------------------------------------+-------------+-----------+--------------------------+--------------+
```