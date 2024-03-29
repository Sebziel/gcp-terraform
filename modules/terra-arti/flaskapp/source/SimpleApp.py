from datetime import datetime
from flask import (Flask, render_template, abort, redirect, url_for, request) 
from model import db, techList, save_db, get_counter_value , update_counter
import FlowersUtilities
import logging


app = Flask(__name__)
logging.basicConfig(filename="/home/project/source/record.log", level=logging.DEBUG, format=f'%(asctime)s %(levelname)s : %(message)s')


@app.route("/")
def welcome():
    update_counter()
    app.logger.debug('Serving welcome page')
    current_time = str(datetime.now())
    counter = get_counter_value()
    app.logger.debug("Setting counter from welcome page to: " + str(counter))
    return render_template("welcome.html", current_time = current_time, counter = counter)

@app.route("/card_list")
def card_list():
    update_counter()
    app.logger.debug('Card list Page')
    return render_template("card_list.html", cards=db)


@app.route("/card/<int:index>")
def card_view(index):
    update_counter()
    app.logger.debug('Serving specific card page')
    try:
        card = db[index]
        return render_template("card.html", card=card, index=index, max_index=len(db)-1)
    except IndexError:
        abort(404)

@app.route("/api/card/<int:index>")
def api_card_view(index):
    try:
        return db[index]
    except IndexError:
        abort(404)

@app.route("/add_card", methods=["GET", "POST"])
def add_card():
    update_counter()
    if request.method == "POST":
        card = {"question": request.form['question'],
                "answer": request.form['answer']}
        db.append(card)
        app.logger.info("Saving new card: " + str(card))
        save_db()
        return redirect(url_for('card_view', index=len(db)-1))
    else:
        return render_template("add_card.html")


@app.route("/FirstPage")
def FirstPage():
    update_counter()
    app.logger.debug("Serving 'FirstPage' page")
    return "There's First page it was served at " +str(datetime.now())


@app.route("/ViewCounter")
def ViewCounter():
    app.logger.debug('Serving viewcounter pagge')
    update_counter()
    return str(get_counter_value())

@app.route("/flowerList")
def flower_list_view():
    update_counter()
    app.logger.debug("Serving flowerList page")
    try:
        flowerlist = FlowersUtilities.get_flowers_list()
        allFlowersDict = FlowersUtilities.get_flowers_data()
        app.logger.debug("gathering data from Flowers.json:" + str(allFlowersDict))
        allFlowers = allFlowersDict[0]
        return render_template("flowers.html", flowerlist=flowerlist, allFlowers=allFlowers)
    except IndexError:
        abort(404)



@app.route("/flower/<string:dindex>")
def flower_view(dindex):
    update_counter()
    app.logger.debug("Serving: " + str(dindex) + " flower page")
    try:
        specificFlower = FlowersUtilities.get_flowers_data()
        flowerlist = specificFlower[0] #Wyciaga zerowy obiekt ze wzgledu na strukture danych w Jsonie
        flower = flowerlist[dindex]
        return render_template("flower.html", flower=flower)
    except IndexError:
        abort(404)


@app.route("/techDetails")
def techDetails():
    update_counter()
    app.logger.debug("Serving TechDetails page")
    try:
        return render_template("techDetails.html", techList=techList)
    except IndexError:
        abort(404)

if __name__ == '__main__':
    app.run(host='0.0.0.0')