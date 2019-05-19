import csv
import time

# Getting starting time
start_time = time.time()

id_score_dict = dict()
player_id_dict = dict()

# Getting predicted scores of players
with open('seventeen.csv', 'r', newline='') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for l in csvreader:
        id_score_dict[l[0]] = l[1]

# Getting players ids and names
with open('seventeen_full.csv', 'r', newline='') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for l in csvreader:
        player_id_dict[l[0]] = l[1]

# Creating a list with all the predicted scores
h = True
list_scores = list()
for k, v in id_score_dict.items():
    # Ignoring the header
    if h:
        h = False
        continue

    # Adding score value to the list
    list_scores.append(float(v))

# Sorting list by biggest value first
list_scores.sort(reverse=True)

# Setting up file for rank saving
final_file = open("seventeen_predicted_ranking.csv", "w", newline="")
head = ['Player', 'Predicted number of points', 'Predicted rank']
writer = csv.DictWriter(final_file, fieldnames=head, delimiter=",")
writer.writeheader()

# Saving data in csv file
header = True
for k, v in sorted(id_score_dict.items()):
    # Ignoring the header
    if header:
        header = False
        continue

    # writing rows in the csv file
    # For the predicted rank, getting the index of the value of points in the sorted list
    writer.writerow({head[0]: player_id_dict[str(int(k)-1)], head[1]: v, head[2]: list_scores.index(float(v))+1})

# Getting end time
end_time = time.time()

# Printing time needed to run the script
print(end_time-start_time)
