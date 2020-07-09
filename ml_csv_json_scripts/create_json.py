import json
import csv

file = open("updatedcenters.csv")
reader = csv.reader(file, delimiter=',')
data = {}
data['hospitals'] = {}
for row in reader:
    name = row[1]
    id = row[0]
    data['hospitals'][id] = {
        'name': name,
        'occupancy': 0,
        'doctors': '[]'
    }
with open('data6.json', 'w') as outfile:
    json.dump(data, outfile)
