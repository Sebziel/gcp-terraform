import json

global available_localizations
available_localizations = {"1": "Sypialnia", "2":"biuro"}

#Zaciaga dane z Json'a
def get_flowers_data():
    with open("JsonData/Flowers.json", "r") as FlowersJson:
        allFlowers = json.load(FlowersJson)
    return allFlowers

#DO WYRZUCENIA, WYCIAGANIE LISTY WAROSCI DLA NAZW
#lista1 = get_flowers_data()
#stobj = lista1[0]
#
#for object1 in stobj:
#    print (stobj[object1])

#Zwraca liste wszystkich kwiatkow 
def get_flowers_list():
    kwiatki = get_flowers_data()
    for kwiatek in kwiatki:
        return list(kwiatek.keys())


#Zwraca liste wszystkich location
def get_flower_location_list():
    kwiatki = get_flowers_data()
    for kwiatek in kwiatki:
        details = kwiatek.values()
    lista_lokacji = []
    for detail in details:
        miejsce = detail["location"]
        lista_lokacji.append(miejsce)
    return lista_lokacji

#Wyswietla listke nazw kwiatkow w zaleznosci od lokalizacji
def get_flowers_list_per_location(localization):
    kwiatki = get_flowers_data()
    for kwiatek in kwiatki:
        lista_wartosci = kwiatek.values()
    for detail in lista_wartosci:
        if detail["location"] == localization:
            print(detail["Nazwa"])

#wyciaga od usera informacje, jaka lokalizacje ma wyswietlic funkcja get_flowers_list_per_location
def get_location_from_user():
    print("Dostepne lokalizacje: ")
    for option_number, option in available_localizations.items():
        print(option_number, " - " ,option)
    user_input = input("Podaj numer lokalizacji kwiatka : ")
    if user_input in available_localizations:
        return available_localizations[user_input]
    else:
        return "Bledna lokalizacja, nalezy podac numer lokalizacji"


#localization = get_location_from_user()
#get_flowers_list_per_location(localization)