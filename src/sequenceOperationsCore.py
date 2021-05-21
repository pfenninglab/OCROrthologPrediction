import sys
import os
import numpy as np
import pybedtools as bt
from Bio import SeqIO

def convertFastaFileToSequencesFile(fastaFileName):
        # Convert a fasta file to a sequences file
        numSequences = 0
        sequencesFileName = ".".join(fastaFileName.split(".")[-0:-1]) + "_sequences.txt"
        sequencesFile = open(sequencesFileName, 'w+')
        sequenceIDs = []
        for record in SeqIO.parse(fastaFileName, "fasta"):
                sequencesFile.write(str(record.seq) + "\n")
                numSequences = numSequences + 1
                sequenceIDs.append(record.id.strip())
        sequencesFile.close()
        return sequencesFileName, numSequences, sequenceIDs

def createBedToolForFilteredList(regionList, createBedFilt, chroms, bedFiltFileName=None):
        # Get the BedTool for a filtered set of peaks
        if createBedFilt:
                # Create a bed file for a filtered set of peaks
                regionListFilt = bt.BedTool([region for region in regionList if region[0] in chroms])
                regionListFilt.saveas(bedFiltFileName)
        if bedFiltFileName:
                # Save the region list to a file
                regionListFilt = bt.BedTool(bedFiltFileName)
        bt.helpers.cleanup()
        return regionListFilt

def show_value(s):
        """
        Convert unicode to str under Python 2;
        all other values pass through unchanged
        """
        if sys.version_info.major == 2:
                if isinstance(s, unicode):
                        return str(s)
        return s

def defineInterval(r, halfWindowSize, summitPresent, windowSizeOdd=False):
        # Create an interval that the CNN can take from a region from a bed file
        chrom = show_value(r[0])
        if summitPresent:
                # Convert the region to a summit-centered interval
                start = int(show_value(r[1])) + int(show_value(r[9])) - halfWindowSize
                if windowSizeOdd:
                        # Subtract 1 from the start
                        start = start - 1
                end = int(show_value(r[1])) + int(show_value(r[9])) + halfWindowSize
                return [chrom, start, end]
        else:
                # Use the centers of the peaks instead of summits
                start = int(show_value(r[1])) + int(round((float(show_value(r[2])) - float(show_value(r[1])))/2.0)) - halfWindowSize
                if windowSizeOdd:
                        # Subtract 1 from the start
                        start = start - 1
                end = int(show_value(r[1])) + int(round((float(show_value(r[2])) - float(show_value(r[1])))/2.0)) + halfWindowSize
                return [chrom, start, end]

def createSetForDeepLearning(genomeFileName, regionList, peakFileNamePrefix, halfWindowSize, summitPresent=True, maxPeakLength=None, \
	chromSizesFileName=None, windowSizeOdd=False, chromEdgeDistLimit=0):
        chromSizesDict = None
        if chromSizesFileName != None:
                # Create a dictionary mapping chromosomes to their sizes
                chromSizesFile = open(chromSizesFileName)
                chromSizesDict = {}
                for line in chromSizesFile:
                        # Iterate through the chromosome sizes and make an entry in the dictionary for each
                        lineElements = line.strip().split("\t")
                        chromSizesDict[lineElements[0]] = int(lineElements[1])
        intervalList = []
        regionListFiltList = []
        for r in regionList:
                # Convert the list of regions into intervals
                [chrom, start, end] = defineInterval(r, halfWindowSize, summitPresent, windowSizeOdd)
                if start < 0:
                        # Do not use the current region because it is too close to the start of the chromosome
                        print ("Start < chromEdgeDistLimit for region: " + str(r))
                        continue
                if chromSizesDict != None:
                        # Check if the current region is too close to the end of the chromosome
                        if chrom not in chromSizesDict:
                                # The current chromosome is not in the dictionary, so skip it
                                print ("Chromosome " + chrom + " is not in the list of chromosomes")
                                continue
                        if end > chromSizesDict[chrom]:
                                # Do not use the current region because it is too close to the end of the chromosome
                                print ("End greater than chromosome length - chromEdgeDistLimit for region: " + str(r))
                                continue
                if (maxPeakLength != None) and (int(round(float(show_value(r[2])) - float(show_value(r[1])))) > maxPeakLength):
                        # The current region is too log, so skip it
                        continue
                regionListFiltList.append(r)
                intervalList.append(bt.Interval(chrom, start, end, show_value(r[4])))
        regionListFilt = bt.BedTool(regionListFiltList)
        summitPlusMinus = bt.BedTool(intervalList)
        fastaFileName = None
        if not windowSizeOdd:
                # Do not add 1 to the half window size in the name of the fasta file
                fastaFileName = ".".join([peakFileNamePrefix, "plusMinus" + str(halfWindowSize) + "bp", "fa"])
        else:
                # Add 1 to the half window size in the name of the fasta file
                fastaFileName = ".".join([peakFileNamePrefix, "plusMinus" + str(halfWindowSize + 1) + "bp", "fa"])
        fasta = summitPlusMinus.sequence(fi = genomeFileName, fo = fastaFileName)
        return summitPlusMinus, fastaFileName, regionListFilt

def createPositiveSetFromNarrowPeaks(optimalPeakFileName, genomeFileName, dataShape, createOptimalBed=False, createOptimalBedFilt=True, \
	maxPeakLength=None, chroms=None, chromSizesFileName=None, chromEdgeDistLimit=0):
        # Create the positive set for the deep learning model
        optimalPeakFileNameElements = optimalPeakFileName.split(".")
        optimalPeakFileNamePrefix = ".".join(optimalPeakFileNameElements[0:-2])
        optimalBedFileName = optimalPeakFileNamePrefix + "_optimal.bed"
        if createOptimalBed:
                        # Create a bed file for the optimal peaks
                        os.system(" ".join(["zcat", optimalPeakFileName, "| grep -v chrUn | grep -v random | grep chr | sort -k1,1 -k2,2n -k3,3n -k10,10n >", \
                                        optimalBedFileName]))
        else:
                        os.system(" ".join(["zcat", optimalPeakFileName, "| sort -k1,1 -k2,2n -k3,3n -k10,10n >", optimalBedFileName]))
        optimalRegionList = bt.BedTool(optimalBedFileName)
        if chroms != None:
                        # Filter for specific chromosomes
                        optimalBedFiltFileName = optimalPeakFileNamePrefix + ".train.bed"
                        optimalRegionListFilt = createBedToolForFilteredList(optimalRegionList, createOptimalBedFilt, chroms, optimalBedFiltFileName)
        else:
                        # Include all of the chromosomes
                        optimalRegionListFilt = optimalRegionList
        halfWindowSize = int(dataShape[2]/2)
        windowSizeOdd = False
        if dataShape[2] % 2 > 0:
                # The window size is odd, so put an extra base on the upstream end
                windowSizeOdd = True
        summitPlusMinus, positiveFastaFileName, optimalRegionListFiltPlus =\
                        createSetForDeepLearning(genomeFileName, optimalRegionListFilt, optimalPeakFileNamePrefix, halfWindowSize, \
                                maxPeakLength=maxPeakLength, chromSizesFileName=chromSizesFileName, windowSizeOdd=windowSizeOdd, \
				chromEdgeDistLimit=chromEdgeDistLimit)
        return optimalPeakFileNamePrefix, optimalRegionList, optimalRegionListFiltPlus, halfWindowSize, summitPlusMinus, positiveFastaFileName

def loadPerBaseTracks(perBaseTrackFileNames):
        # Load the per base tracks
        # Also in sequenceOperationsForZnfs.py
        perBaseTracks = []
        if perBaseTrackFileNames:
                # Load the per base track files
                perBaseTracks = [np.loadtxt(pbtfn) for pbtfn in perBaseTrackFileNames]
        return perBaseTracks

def createPerBaseTracksMat(perBaseTracks, width, sampleCount, divisor):
        # Create a matrix with the per base tracks for the current sample
        # ASSUMES THAT sampleCount IS A MULTIPLE OF divisor
        # Also in sequenceOperationsForZnfs.py
        perBaseTracksIndex = sampleCount / divisor
        perBaseTracksMat = np.empty((0, width))
        for pbt in perBaseTracks:
                # Iterate through the per base
                perBaseTracksMat = np.vstack((perBaseTracksMat, pbt[perBaseTracksIndex, :]))
        return perBaseTracksMat

def oneHotEncode(sequence):
        encodedSequence = np.zeros((4, len(sequence)), dtype=np.int8)
        sequenceDict = {}
        sequenceDict["A"] = np.array([1, 0, 0, 0])
        sequenceDict["a"] = np.array([1, 0, 0, 0])
        sequenceDict["C"] = np.array([0, 1, 0, 0])
        sequenceDict["c"] = np.array([0, 1, 0, 0])
        sequenceDict["G"] = np.array([0, 0, 1, 0])
        sequenceDict["g"] = np.array([0, 0, 1, 0])
        sequenceDict["T"] = np.array([0, 0, 0, 1])
        sequenceDict["t"] = np.array([0, 0, 0, 1])
        sequenceDict["N"] = np.array([0, 0, 0, 0])
        sequenceDict["n"] = np.array([0, 0, 0, 0])
        # These are all 0's even though they should ideally have 2 indices with 0.5's because storing ints requires less space than storing floats
        sequenceDict["R"] = np.array([0, 0, 0, 0])
        sequenceDict["r"] = np.array([0, 0, 0, 0])
        sequenceDict["Y"] = np.array([0, 0, 0, 0])
        sequenceDict["y"] = np.array([0, 0, 0, 0])
        sequenceDict["M"] = np.array([0, 0, 0, 0])
        sequenceDict["m"] = np.array([0, 0, 0, 0])
        sequenceDict["K"] = np.array([0, 0, 0, 0])
        sequenceDict["k"] = np.array([0, 0, 0, 0])
        sequenceDict["W"] = np.array([0, 0, 0, 0])
        sequenceDict["w"] = np.array([0, 0, 0, 0])
        sequenceDict["S"] = np.array([0, 0, 0, 0])
        sequenceDict["s"] = np.array([0, 0, 0, 0])
        for i in range(len(sequence)):
                # Iterate through the bases in the sequence and record each
                encodedSequence[:,i] = sequenceDict[sequence[i]]
        numNs = len(sequence) - np.sum(encodedSequence)
        return encodedSequence, numNs

def reverse_complement(encoded_sequences):
        # Because the encoding is A, C, G, T in that order, can just reverse each sequence along both axes.
        return encoded_sequences[..., ::-1, ::-1]

def makeMultiModedData(allData, dataShape, numPerBaseTracks):
        # Convert data into the format for multi-moding
        # ASSUMES per-base tracks are 1 high
        assert(numPerBaseTracks > 0)
        allDataList = []
        allDataList.append(allData[:,:,0:dataShape[1],:])
        for i in range(numPerBaseTracks):
                # Iterate through the per-base tracks and add the data for that track to the list
                allDataList.append(allData[:,:,dataShape[1] + i - 1:dataShape[1] + i,:])
        return allDataList

def makeSequenceInputArraysNoLabels(sequenceFileName, dataShape, numSequences, perBaseTrackFileNames=[], multiMode=False, maxFracNs = 1.0):
        # Convert each sequence into a numpy array, but do not load any labels/signals files
        # ASSUMES THAT THE SEQUENCES ARE LISTS AND NOT IN FASTA FORMAT
        sequenceFile = open(sequenceFileName)
        perBaseTracks = loadPerBaseTracks(perBaseTrackFileNames)
        channel1 = dataShape[0];
        channel2 = dataShape[1] + len(perBaseTracks);
        channel3 = dataShape[2];
        allData = np.zeros((numSequences*2, channel1, channel2, channel3), dtype=np.int8);
        if perBaseTracks:
                # There are additional per-base tracks that might not be ints
                allData = np.zeros((numSequences*2, channel1, channel2, channel3), dtype=np.float16);
        sampleCount = 0
        skippedIndices = []
        totalNs = 0
        for sequence in sequenceFile:
                # Iterate through the fasta sequences and create the alphabets for the sequence and the reverse complement of each
                perBaseTracksMat = createPerBaseTracksMat(perBaseTracks, channel3, sampleCount, 2)
                sequenceArray, numNs = oneHotEncode(sequence.strip())
                sequenceFracNs = float(numNs)/float(dataShape[2])
                if sequenceFracNs > maxFracNs:
                        # The percentage of N's in the current sequence is too high
                        print("This sequence has too high of a percentage of N's: " + sequence + " " + str(sequenceFracNs))
                        numSequences = numSequences - 1
                        skippedIndices.append(sampleCount/2)
                        continue
                if sequenceArray.shape[1] != dataShape[2]:
                        # The current sequences is the wrong length, so skip it
                        print("This sequence is the wrong length: " + sequence)
                        skippedIndices.append(sampleCount/2)
                        numSequences = numSequences - 1
                        continue
                totalNs = totalNs + numNs
                sequenceArrayReshape = np.reshape(np.vstack((sequenceArray, perBaseTracksMat)), (channel1, channel2, channel3))
                allData[sampleCount,:,:,:] = sequenceArrayReshape
                sampleCount = sampleCount + 1
                # Repeat for the reverse complement
                sequenceArrayRC = reverse_complement(sequenceArray)
                sequenceArrayReshapeRC = np.reshape(np.vstack((sequenceArrayRC, perBaseTracksMat)), (channel1, channel2, channel3))
                allData[sampleCount,:,:,:] = sequenceArrayReshapeRC
                sampleCount = sampleCount + 1
        assert (sampleCount == numSequences*2)
        fracNs = float(totalNs)/float(dataShape[2] * numSequences)
        print("The fraction of Ns is: " + str(fracNs))
        sequenceFile.close()
        if multiMode:
                # Re-format the data for multi-moding
                return makeMultiModedData(allData, dataShape, len(perBaseTrackFileNames))
        return allData, skippedIndices
