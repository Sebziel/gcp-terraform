from sqlalchemy import create_engine, Column, String, Integer, CHAR
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from .FakeData import generate_multiple_fake_users
import time

Base = declarative_base()

class Person(Base):
    __tablename__ = "users"

    uuid = Column("uuid", CHAR(36), primary_key=True)
    firstname = Column("firstname", String(255))
    lastname = Column("lastname", String(255))
    email = Column("email", String(255))
    phone_number = Column("phone_number", Integer)

    def __init__(self, uuid, first, last, email, phone_number):
        self.uuid = uuid
        self.firstname = first
        self.lastname = last
        self.email = email
        self.phone_number = phone_number

    def __repr__(self):
        return f"UUID: {self.uuid}, firstname: {self.firstname}, lastname: {self.lastname}, gender: {self.email}, phone no: {self.phone_number}"

engine=create_engine("mysql+pymysql://admin:nimda@localhost/mydatabase") #echo=True
Base.metadata.create_all(bind=engine) #creates Person table
Session = sessionmaker(bind=engine)
session = Session()

def create_persons(person_count, verbose):
    user_data_list = generate_multiple_fake_users(person_count, verbose)
    user_list = []
    started_at = time.monotonic()
    for user_data in user_data_list:
        user_data['id'] = Person(user_data['id'], user_data['first_name'], user_data['last_name'], user_data['email'], user_data['phone_number'])
        user_list.append(user_data['id'])
        #For debbuging purpose, not required in overall verbose as it's creating a lot of cli noise
        #if verbose == True:
        #    print(f"created user: {user_data['id']}")
    total_time = time.monotonic() - started_at
    print (f'finished creating users in: {total_time}, proceeding to commiting users to Db')
    return user_list

#If running directly from DbConnection.py file
#user_list = create_persons(10)


def add_users_to_db(user_list, verbose):
    started_at = time.monotonic()

    total_users = len(user_list)
    milestones = [total_users * percent // 100 for percent in (25, 50, 75)]

    for i, user in enumerate(user_list, start=1):
        session.add(user)

        if verbose and i in milestones:
            percentage_completed = milestones.index(i) * 25 + 25
            print(f'{percentage_completed}% processed ({i}/{total_users})')

    session.commit()
    total_time = time.monotonic() - started_at
    print (f'finished commiting users in: {total_time}')

#If running directly from DbConnection.py file
#add_users_to_db(user_list)