#!/usr/bin/env python3
#reorderSpecies [original order] [new order (supperset)] [peaks] [file to write new order] [reordered enhancer data (write)]

import sys

curFile = open(sys.argv[1], "r")
curOrder = [x.strip() for x in curFile.readlines()]
curFile.close()
newFile = open(sys.argv[2], "r")
newOrder = [x.strip().split("\t")[0].replace("_", " ") for x in newFile.readlines()]
newFile.close()
peakFile = open(sys.argv[3], "r")
outFile = open(sys.argv[5], "w")
orderFile = open(sys.argv[4], "w")
orderOut = False
for line in peakFile:
    tokens = line.split()
    diff = len(tokens) - len(curOrder)
    if diff > 0:
        outFile.write("\t".join(tokens[:diff]) + "\t")
        tokens = tokens[diff:]
    specDict = {}
    for i in range(len(tokens)):
        specDict[curOrder[i]] = tokens[i]
    for s in newOrder:
        if s in curOrder:
            if not orderOut:
                orderFile.write(s + "\n")
            outFile.write(specDict[s] + "\t")
    outFile.write("\n")
    orderOut = True
peakFile.close()
outFile.close()
for s in curOrder:
    if not (s in newOrder):
        print(s, file=sys.stderr)
orderFile.close()
