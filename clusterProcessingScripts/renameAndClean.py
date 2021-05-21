#!/usr/bin/env python3
#renameAndClean.py [input file] [output file] [exclusions directory]

import sys, os


sps = ["Mouse", "Human", "Macaque", "Rat"] #For brain
#sps = sps = ["Mouse", "Rat", "Macaque"] #For Liver
exclDict = {}
files = []
for sp in sps:
    exclDict[sp] = set()
if len(sys.argv) > 3:
    files = os.listdir(sys.argv[3])
    for f in files:
        sp = f.split("_")[0]
        assert sp in exclDict
        exFile = open(sys.argv[3] + "/" + f, "r")
        for line in exFile:
            exclDict[sp].add(line.strip())
        exFile.close()     

print("Found", [len(exclDict[sp]) for sp in sps], "peaks to filter", file=sys.stderr)

inFile = open(sys.argv[1], "r")
outFile = open(sys.argv[2], "w")

i = 1
j = 1

specCounts = [14295, 8795, 16640, 22725] $For Brain
#specCounts = [22042,21531,32676] #For Liver

specBounds = [sum(specCounts[:i+1]) for i in range(len(specCounts))]
suffix = ".txt"
if len(files) == (len(sps) * (len(sps)-1)) / 2:
    suffix = "NR.txt"
elif len(files) > 0:
    suffix = "Filtered.txt"
ltName = "LookupTable" + suffix
ltFiles = {}
for sp in sps:
    ltFiles[sp] = open(sp+ltName, "w")
for line in inFile:
    name = line.split()[0]
    sp = ""
    for k in range(len(specBounds)):
        if i <= specBounds[k]:
            sp = sps[k]
            break
    if sp == "":
        print("Cannot identify", name, file=sys.stderr)
        quit()
    if not(name in exclDict[sp]):
        newName = name + "_" + sp[:2].lower()
        ltFiles[sp].write(name + "\t" + newName + "\n")
        outFile.write(line.replace(name, newName, 1))
        j += 1
    i += 1

inFile.close()
outFile.close()
[ltFiles[sp].close() for sp in sps]
