from flask import (Flask, render_template, abort, redirect, url_for, request, jsonify) 
from app import getUsers
app = Flask(__name__)

@app.route("/")
def welcome():
    return "zwracam root route'a"

@app.route("/api/test")
def api_test():
    userlist = getUsers(10)
    return jsonify([user.to_dict() for user in userlist])

if __name__ == '__main__':
    app.run(host='0.0.0.0')