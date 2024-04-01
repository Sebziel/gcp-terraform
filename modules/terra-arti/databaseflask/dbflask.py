from flask import (Flask, render_template, abort, redirect, url_for, request, jsonify) 
from app import getUsers, findUser
app = Flask(__name__)

@app.route("/api/getUsers")
def api_getUsers():
    count = request.args.get('count', default = 10, type = int)
    userlist = getUsers(count)
    return jsonify([user.to_dict() for user in userlist])

@app.route("/api/findUser")
def api_findUser():
    firstname = request.args.get('firstname', default = '*', type = str)
    lastname = request.args.get('lastname', default = '*', type = str)
    if len(firstname) > 3 or len(lastname) > 3:        
        try:
            userlist = findUser(firstname, lastname)
            return jsonify([user.to_dict() for user in userlist])
        except:
            abort(404)
    else:
        return "Provide at least 3 characters for firstname or lastname"

if __name__ == '__main__':
    app.run(host='0.0.0.0')