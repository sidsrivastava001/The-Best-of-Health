import googlemaps
import csv
from datetime import datetime

gmaps = googlemaps.Client(key='AIzaSyBgbQLyVp3vNDv4rYAXMTVF2VtwBeDaHpA')

#geocode_result = gmaps.geocode('1600 Amphitheatre Parkway, Mountain View, CA')
#print(geocode_result)
#print(googlemaps.__file__)
file = open("updatedcenters.csv")
file2 = open("written_reviews.csv", mode="w")
reader = csv.reader(file, delimiter=',')
reader2 = csv.writer(file2, quoting=csv.QUOTE_ALL)
none = []
for row in reader:
    #print(row[1])
    x = gmaps.places(row[1])
#print(gmaps.places_nearby(location='34.221688,-86.1607098', radius=500, type='hospital'))
    #print(x['results'][0]['place_id'])
    if len(x['results'])>0:
        l = gmaps.place(x['results'][0]['place_id'])['result']
        if 'reviews' in l:
            reviews = l['reviews']
            list = []
            for review in reviews:
                #print(review['text'])
                list.append(review['text'].encode('utf-8'))
            reader2.writerow(list)
        else:
            none.append(row[1])
    else:
        none.append(row[1])
print(none)
file.close()
file2.close()
