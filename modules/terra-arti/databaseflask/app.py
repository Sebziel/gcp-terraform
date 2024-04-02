from sqlalchemy import create_engine, Column, Integer, String, or_
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

def getUsers(count):
    Session = sessionmaker(bind=engine)
    session = Session()
    userlist = session.query(User).limit(count).all()
    session.close()
    return userlist

def findUser(queryfirstname, querylastname):
    Session = sessionmaker(bind=engine)
    session = Session()
    user = session.query(User).filter(or_(User.firstname.like(f"%{queryfirstname}%"), User.lastname.like(f"%{querylastname}%")))
    session.close()
    return user