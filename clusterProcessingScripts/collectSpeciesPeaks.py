#/usr/bin/env python3
#collectSpeciesPeaks.py [desired species] [list of other species,comma-seperated]

import sys, os

def getLookup(name):
    file = open(name, "r")
    table = {}
    for line in file:
        tokens = line.strip().split()
        table[tokens[0]] = tokens[1]
    file.close()
    return table

sp = sys.argv[1]
others = sys.argv[2].split(",")


outFile = open(sp + "OfRenamedAllNRSummit.bed", "w")

#Species
lookup = getLookup(sp + "LookupTableNR.txt")
inFile = open(sp + "Peaks.bed", "r")
for line in inFile:
    tokens = line.split()
    coords = "\t".join(tokens[:3])
    if tokens[3] in lookup:
        peak = lookup[tokens[3]]
        outFile.write(coords + "\t" + peak + "\n")
inFile.close()

#Others
for other in others:
    lookup = getLookup(other + "LookupTableNR.txt")
    inFile = open(sp + "Of" + other + ".bed", "r")
    for line in inFile:
        tokens = line.split()
        coords = "\t".join(tokens[:3])
        if tokens[3] in lookup:
            peak = lookup[tokens[3]]
            outFile.write(coords + "\t" + peak + "\n")
    inFile.close()

outFile.close()
