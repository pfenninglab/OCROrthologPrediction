#!/usr/bin/env python3
#extractClusters.py [Matrix of activity predictions] [List of clusters]

import sys

inFile = open(sys.argv[2], "r") #List of clusters
dataFile = open(sys.argv[1], "r") #List of peaks



peakDict = {}
for line in dataFile:
    tokens = line.strip().split("\t")
    peakDict[tokens[0]] = ",".join(tokens[1:]) + "\n"
dataFile.close()

clusterDict = {}
for line in inFile:
    tokens = line.strip().split("\t")
    clusterDict[tokens[0]] = []
    for peak in tokens[1:]:
        clusterDict[tokens[0]].append(peakDict[peak])
inFile.close()

n = len(clusterDict.keys())

for j in range(1, n+1):
    name = "cluster" + str(j)
    outFile = open(name + ".csv", "w")
    for s in clusterDict[name]:
        outFile.write(s)
    outFile.close()

