from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import csv

file = open("written_reviews.csv")
file2 = open("sentiment.csv", mode="w")
reader = csv.reader(file, delimiter=',')
reader2 = csv.writer(file2, quoting=csv.QUOTE_NONNUMERIC)

analyzer = SentimentIntensityAnalyzer()

scores = []

for row in reader:
    for i in range(len(row)):
        if(len(row[i])>0):
            #print(row[i])
            score = analyzer.polarity_scores(row[i])
            scores.append(score['compound'])
reader2.writerow(scores)
