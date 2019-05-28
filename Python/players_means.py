import csv
import time

# Getting starting time
start_time = time.time()

# Dict to save every player values
player_values = dict()

# Getting 2017 player scores for every year
with open('seventeen_players_data.csv', 'r', newline='') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
    header = True
    for l in csvreader:
        if header:
            header = False
            continue

        if l[1] not in player_values.keys():
            player_values[l[1]] = dict.fromkeys(['Rounds', 'Scoring', 'GIR', 'Top 10', '1ST'])
            player_values[l[1]]['Rounds'] = list()
            player_values[l[1]]['Scoring'] = list()
            player_values[l[1]]['GIR'] = list()
            player_values[l[1]]['Top 10'] = list()
            player_values[l[1]]['1ST'] = list()

        player_values[l[1]]['Rounds'].append(float(l[2]))
        player_values[l[1]]['Scoring'].append(float(l[3]))
        player_values[l[1]]['GIR'].append(float(l[6]))
        player_values[l[1]]['Top 10'].append(float(l[11]))
        player_values[l[1]]['1ST'].append(float(l[12]))

# Dict for player means
player_means = dict()

# Computing means for every player
for k,v in player_values.items():
    player_means[k] = dict.fromkeys(['Rounds', 'Scoring', 'GIR', 'Top 10', '1ST'])

    player_means[k]['Rounds'] = sum(v['Rounds'])/len(v['Rounds'])
    player_means[k]['Scoring'] = sum(v['Scoring'])/len(v['Scoring'])
    player_means[k]['GIR'] = sum(v['GIR'])/len(v['GIR'])
    player_means[k]['Top 10'] = sum(v['Top 10'])/len(v['Top 10'])
    player_means[k]['1ST'] = sum(v['1ST'])/len(v['1ST'])


# Creating file for final save
final_file = open("seventeen_players_means.csv", "w", newline="")
head = ['x', 'Name', 'ROUNDS', 'SCORING', 'GIR_%', 'TOP 10', '1ST']
writer = csv.DictWriter(final_file, fieldnames=head, delimiter=",")
writer.writeheader()

# Id variable for CSV file
i = 0

# Writing every data in CSV file
for k, v in player_means.items():
    writer.writerow({head[0]: i, head[1]: k, head[2]: v['Rounds'], head[3]: v['Scoring'], head[4]: v['GIR'],
                     head[5]: v['Top 10'], head[6]: v['1ST']})

    i += 1








# Getting end time
end_time = time.time()

# Printing time needed to run the script
print(end_time-start_time)
