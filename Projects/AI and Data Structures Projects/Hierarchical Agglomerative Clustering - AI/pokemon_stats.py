import csv
from math import inf
import numpy as np
import matplotlib.pyplot as plt


def load_data(filepath):
    dataset = []
    with open(filepath) as f:
        reader = csv.DictReader(f)
        i = 0
        for row in reader:
            del row['Generation']
            del row['Legendary']
            if i == 20:
                break
            dataset.append(row)
            i += 1
    return dataset


# X is offense = Attack + Sp. Atk + Speed. Y is defense = Defense + Sp. Def + HP
def calculate_x_y(stats):
    x = int(stats['Attack']) + int(stats['Sp. Atk']) + int(stats['Speed'])
    y = int(stats['Defense']) + int(stats['Sp. Def']) + int(stats['HP'])
    return (x,y)

def hac(dataset):
    for x,y in dataset:
        if type(x) is not int or type(y) is not int:
            dataset.remove((x,y))
    Z = []
    newDataset = dataset
    origLength = len(newDataset)
    # Keep track of which points are in clusters, are how large they are

    clustered_points = [[True, 1,{i}, i] for i in range(len(dataset))]
    distances_array = distances(dataset)
    for x in range(origLength - 1):
        newMin = findMin(distances_array, clustered_points)
        # Add the original points to the cluster and their size
        allPoints = set()
        # Add all values to set
        for j in clustered_points[newMin[1]][2]:
            allPoints.add(j)
        for k in clustered_points[newMin[2]][2]:
            allPoints.add(k)

        newSize = clustered_points[newMin[1]][1] + clustered_points[newMin[2]][1]
        newSet = clustered_points[newMin[1]][2].union(clustered_points[newMin[2]][2])

        for l in newSet:
            clustered_points[l][2] = newSet
            clustered_points[l][1] = newSize

        if clustered_points[newMin[1]][3] < clustered_points[newMin[2]][3]:
            Z.append([clustered_points[newMin[1]][3], clustered_points[newMin[2]][3], newMin[0], newSize])
        else:
            Z.append([clustered_points[newMin[2]][3], clustered_points[newMin[1]][3], newMin[0], newSize])

        for q in newSet:
            clustered_points[q][3] = origLength + x
    return Z

def random_x_y(m):
    list = []
    for x in range(m):
        list.append([np.random.randint(359) + 1, np.random.randint(359) + 1])

    return list
    

# For all pairs of points, determine which ones have the smallest distances

def findMin(distance, clusters):

    min = [inf, 0, 0]
    for point in distance:
        if point[1] in clusters[point[2]][2]:
            continue
        # Case for first point
        if min == point:
            continue
        # Compare distance
        if point[0] < min[0]:
            min = point
        elif point[0] == min[0]:
            # if the first cluster index is the same
            if point[1] == min[1]:
                min = point if point[2] < min[2] else min
            else:
                min = point if point[1] < min[1] else min
    return min


# Helper function for smallest points

def distances(dataset):
    distance = []
    no_dup = [[False for i in range(len(dataset))] for j in range(len(dataset))]
    for indexPoint in range(len(dataset)):
        for otherPointIndex in range(len(dataset)):
            if indexPoint == otherPointIndex:
                continue
            # Skip doing the pair the other way
            if no_dup[otherPointIndex][indexPoint] == True: continue
            p1x, p1y = dataset[indexPoint]
            p2x, p2y = dataset[otherPointIndex]

            # No need to do this pair the other way
            no_dup[indexPoint][otherPointIndex] = True
            distance.append(list((np.sqrt((p2x-p1x)**2 + (p2y-p1y)**2), indexPoint, otherPointIndex)))

    return distance   

def imshow_hac(dataset):
    for x,y in dataset:
        if type(x) is not int or type(y) is not int:
            dataset.remove((x,y))

    newDataset = dataset
    origLength = len(newDataset)
    # Keep track of which points are in clusters, are how large they are

    clustered_points = [[True, 1,{i}, i] for i in range(len(dataset))]
    distances_array = distances(dataset)
    # Which points connect to which points
    live = []
    for x in range(origLength - 1):
        newMin = findMin(distances_array, clustered_points)

        # Add the original points to the cluster and their size
        allPoints = set()

        # Add all values to set
        for j in clustered_points[newMin[1]][2]:
            allPoints.add(j)
        for k in clustered_points[newMin[2]][2]:
            allPoints.add(k)

        newSize = clustered_points[newMin[1]][1] + clustered_points[newMin[2]][1]
        newSet = clustered_points[newMin[1]][2].union(clustered_points[newMin[2]][2])

        for l in newSet:
            clustered_points[l][2] = newSet
            clustered_points[l][1] = newSize
            clustered_points[l][3] = origLength + x
        
        live.append([newMin[1], newMin[2]])
    data = np.array(dataset)
    fin = []
    for z in live:
        temp = (dataset[z[0]], dataset[z[1]])
        fin.append(temp)
    final = np.array(fin)
    plt.scatter(data[:,0], data[:,1])
    for x in range(len(dataset) - 1):
        plt.plot(final[x][:,0], final[x][:,1] )
        plt.pause(0.1)
    plt.show()