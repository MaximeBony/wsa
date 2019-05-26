import csv
import time

# Getting starting time
start_time = time.time()

# List to save all player names in 2017
seventeen_players = list()

# Getting 2017 player names
with open('seventeen_predicted_ranking.csv', 'r', newline='') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
    header = True
    for l in csvreader:
        if header:
            header = False
            continue

        seventeen_players.append(l[0])

# Dict to save data for every year of every player of the dataset
all_players = dict()

# Getting players' data
with open('pgatour_cleaned.csv', 'r', newline='') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
    header = True
    for l in csvreader:
        if header:
            header = False
            continue

        if l[1] not in all_players.keys():
            all_players[l[1]] = dict()

        all_players[l[1]][l[13]] = l[2:]

# Creating a dict containing only values for players of 2017
final_dict = {k:v for (k,v) in all_players.items() if k in seventeen_players}

# Creating file for final save
final_file = open("seventeen_players_data.csv", "w", newline="")
head = ['x', 'Name', 'ROUNDS', 'SCORING', 'DRIVE_DISTANCE', 'FWY_%', 'GIR_%', 'SG_P', 'SG_TTG', 'SG_T', 'POINTS',
        'TOP 10', '1ST', 'Year', 'MONEY', 'COUNTRY']
writer = csv.DictWriter(final_file, fieldnames=head, delimiter=",")
writer.writeheader()

# Id variable for CSV file
i = 0

# Writing every data in CSV file
for k, v in final_dict.items():
    for year, data in v.items():
        writer.writerow({head[0]: i, head[1]: k, head[2]: data[0], head[3]: data[1], head[4]: data[2], head[5]: data[3],
                         head[6]: data[4], head[7]: data[5], head[8]: data[6], head[9]: data[7], head[10]: data[8],
                         head[11]: data[9], head[12]: data[10], head[13]: data[11], head[14]: data[12],
                         head[15]: data[13]})

        i += 1




# Getting end time
end_time = time.time()

# Printing time needed to run the script
print(end_time-start_time)
