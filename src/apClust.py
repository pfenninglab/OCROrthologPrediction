#!/usr/bin/env python3
#apClust.py [options]

import numpy, sys
from argparse import ArgumentParser


parser = ArgumentParser(description="Performs affinity propagation clustering")

parser.add_argument("-m", required=True, help="distance matrix (required)")
parser.add_argument("-c", help="list of clusters")
parser.add_argument("-l", help="list of peaks, if no cluster file specified")
parser.add_argument("-n", help="cluster only the first N things", type=int)
parser.add_argument("-p", default=-0.3, help="preference value to use", type=float)
parser.add_argument("-o", help="output file (default STDOUT)")
args = parser.parse_args()

dm = numpy.loadtxt(open(args.m, "rb"), delimiter=",", skiprows=0)
if args.n:
    n = int(args.n)
    dm = dm[:n, :n]

vec_negate = numpy.vectorize(lambda i: -i)
dm2 = vec_negate(dm)

p=args.p

from sklearn.cluster import AffinityPropagation

af = AffinityPropagation(preference=p, affinity='precomputed', max_iter=200)
clustering = af.fit(dm2)
ncls = numpy.amax(clustering.labels_)+1
labels = clustering.labels_.astype(int)
print(clustering.n_iter_, "iterations taken", file=sys.stderr)
print(ncls, "clusters produced", file=sys.stderr)

new_clusters = [[] for i in range(ncls)]

if args.c: #Try processing a list of existing (small) clusters
    inFile = open(args.c, "r")
    old_clusters = [x.strip().split("\t")[1:] for x in inFile.readlines()]
    inFile.close()
    assert len(old_clusters) == len(labels)
    for i in range(len(labels)):
        new_clusters[labels[i]].extend(old_clusters[i])
elif args.l: #Orthwise base on a list of peaks
    inFile = open(args.l, "r")
    old_peaks = [x.srip().split()[0] for x in inFile.readlines()]
    inFile.close()
    assert len(old_peaks) == len(labels)
    for i in range(len(labels)):
        new_clusters[labels[i]].append(old_peaks[i])
else: #If nothing is given, assume peaks 1...n
    for i in range(len(labels)):
        new_clusters[labels[i]].append("peak" + str(i+1))

outFile=sys.stdout
if args.o:
    outFile = open(args.o, "w")
for i in range(ncls):
    outFile.write("cluster" + str(i+1) + "\t" + "\t".join(new_clusters[i]) + "\n")

