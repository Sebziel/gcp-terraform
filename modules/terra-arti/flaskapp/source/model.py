import json

def load_db():
    with open("JsonData/dbmock.json") as f:
        return json.load(f)

def save_db():
    with open("JsonData/dbmock.json", "w") as f:
        return json.dump(db, f)

db = load_db()

def load_tech_details():
    with open("JsonData/techDetails.json") as f:
        return json.load(f)

techList = load_tech_details()

def get_counter_data():
    with open("JsonData/counter.json", "r") as counterJson:
        data = json.load(counterJson)
    return data

def get_counter_value():
    counterValue = get_counter_data()
    return counterValue["counter"]

def update_counter():
    value = get_counter_data()
    value["counter"] += 1
    with open("JsonData/counter.json", "w") as jsonfile:
        json.dump(value, jsonfile)
    return