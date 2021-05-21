#!/usr/bin/env python3

# getHumanClusterCoords.py [enhancer atcitivy predictions] 
# [species/column order file] [ortholog list file] [cluster file] [output dir]

import sys

speciesFile = open(sys.argv[2], "r")
speciesIndex = [x.strip() for x in speciesFile.readlines()].index("Homo sapiens") + 1
speciesFile.close()
enhancerDict = {}
enhancerFile = open(sys.argv[1], "r")
for line in enhancerFile:
    tokens = line.strip().split("\t")
    enhancerDict[tokens[0]] = float(tokens[speciesIndex])
enhancerFile.close()

orthoDict = {}
orthoFile = open(sys.argv[3], "r")
for line in orthoFile:
    tokens = line.strip().split()
    orthoDict[tokens[3]] = line.strip()
orthoFile.close()

bgFile = open(sys.argv[5] + "/" + "allHumanClusters.bed", "w")
clusterFile = open(sys.argv[4], "r")

for line in clusterFile:
    tokens = line.strip().split()
    if len(tokens) < 302: #threshold = 300
        continue
    name = tokens[0]
    humanScores = [enhancerDict[x] for x in tokens[1:]]
    ortholog = [True for x in humanScores if x >= 0]
    overThreshold = [True for x in humanScores if x > 0.5]
    print(len(humanScores), len(ortholog), len(overThreshold))
    if len(overThreshold) >= 0.5 * len(humanScores): #Requires >= 50% over 0.5
        fgFile = open(sys.argv[5] + "/" + name + ".bed", "w")
        for enhancer in tokens[1:]:
            if enhancer in orthoDict:
                enhancerString = orthoDict[enhancer]
                if enhancerString[:3] != "chr":
                    continue
                fgFile.write(orthoDict[enhancer] + "\n")
                bgFile.write(orthoDict[enhancer] + "\n")
        fgFile.close()
bgFile.close()
clusterFile.close()

