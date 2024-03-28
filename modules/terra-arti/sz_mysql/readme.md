Running localy: 
'''docker build . -t mysql'''
'''docker run -d -p 3306:3306 --name mysql mysql'''


Connecting locally (requires mysql clinet):

'''mysql -h 127.0.0.1 -u admin -p'''