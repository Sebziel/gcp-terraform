from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, declarative_base
import os

username = os.getenv('USERNAME')
databaseip = os.getenv('DBIP')
db_password = os.getenv('PASSWORD')

# Create a SQLAlchemy engine to connect to the MySQL database
engine = create_engine(f'mysql+pymysql://{username}:{db_password}@{databaseip}/mydatabase')

# Define a base class for declarative class definitions
Base = declarative_base()

# Define a SQLAlchemy model representing a table in the database
class User(Base):
    __tablename__ = 'users'

    uuid = Column(String, primary_key=True)
    firstname = Column(String)
    lastname = Column(String)
    email = Column(String)
    phone_number = Column(Integer)

    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

# Create tables in the database if they do not exist
#Base.metadata.create_all(engine)

# Create a session maker to interact with the database
#Session = sessionmaker(bind=engine)
#session = Session()

# Query the database to retrieve data

def getUsers(count):
    Session = sessionmaker(bind=engine)
    session = Session()
    userlist = session.query(User).limit(count).all()
    session.close()
    return userlist

# Print retrieved data
# for user in users:
#    print(f"User ID: {user.uuid}, Name: {user.firstname}, Lastname: {user.lastname}, Email: {user.email}, Phone number: {user.phone_number}")

# Close the session
#session.close()
