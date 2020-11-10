import sys
import argparse
import os
import itertools
import numpy as np
import pybedtools as bt
from keras.models import model_from_json # Assumes keras version 1
from sequenceOperationsCore import \
	convertFastaFileToSequencesFile, createPositiveSetFromNarrowPeaks, \
	makeSequenceInputArraysNoLabels, show_value

def parseArgument():
	# Parse the input
	parser = argparse.ArgumentParser(description = \
		"Predict the values for a new set of sequences")
	parser.add_argument("--architectureFileName", required=True, \
		help='Model architecture file in json format')
	parser.add_argument("--weightsFileName", required=True, \
		help='Model weights file in hdf5 format')
	parser.add_argument("--fastaFileName", required=False, \
		help='Sequences file in fasta format, \
			should not also have narrowPeakFileName')
	parser.add_argument("--narrowPeakFileName", required=False, \
		help='Regions in narrowPeak format, \
			should not also have fastaFileName')
	parser.add_argument("--maxPeakLength", type=int, required=False, \
		default=None, help='Maximum number of bases per peak')
	parser.add_argument("--sequenceLength", type=int, required=False, \
		default=500, help='Number of bases in each sequence')
	parser.add_argument("--perBaseTrackFileName", action='append', \
		required=False, \
		help='Per base track file name \
			(like conservation, DNA shape, etc., \
			should be in bigWig format)')
	parser.add_argument("--predictedClassesFileName", default=None, \
		required=False, help='File where predicted classes will be recorded')
	parser.add_argument("--predictedProbaFileName", default=None, \
		required=False, \
		help='File where predicted probabilities will be recorded')
	parser.add_argument("--genomeFileName", required=False, \
		help='File with genome sequence, \
			necessary if input is in narrowPeak format')
	parser.add_argument("--chromSizesFileName", required=False, \
		help='File with list of chromosomes and their corresponding sizes')
	parser.add_argument("--chromEdgeDistLimit", type=int, required=False, default=0, \
                help='Distance from chromosome end for which peak will be considered, \
			need chromSizesFileName to use for 3 prime end of chormosomes')
	parser.add_argument("--chroms", action='append', required=False, \
		help='Chromosomes for which the prediction will happen, \
			can only use if input is in narrowPeak format')
	parser.add_argument("--createOptimalBed", action='store_true', required=False, \
                help='Remove peaks on unknown, alternative, \
			and random chromosomes before making predictions')
	parser.add_argument("--removeFastas", action='store_true', required=False, \
		help='Remove the fasta files that are created before \
			making the numpy arrays if input is in narrowPeak format')
	parser.add_argument("--logLabels", action='store_true', \
		required=False, help='Include if labels (if labels are signals) should be log2ed')
	parser.add_argument("--multiMode", action='store_true', required=False, \
		help='Include if model is multi-modal')
	parser.add_argument("--classification", action='store_true', \
		required=False, help='Include if evaluating classification')
	options = parser.parse_args();
	return options


def predictNewSequencesClassificationNoEval(options, model, X, peakNamesForData):
	print("Evaluating model...")
	predictedClasses = model.predict_classes(X);
	print("Saving predictions (if files have been specified)")
	if options.predictedClassesFileName != None:
		# Record the predicted classes
		predictedClassesFile =\
			open(options.predictedClassesFileName, 'w+')
		for i in range(X.shape[0]):
			# Iterate through the predicted classes for each and record them along with the peak names
			predictedClassesFile.write(peakNamesForData[i] + "\t" + \
				"\t".join([str(int(pc)) for pc in predictedClasses[i,:]]) + \
				"\n")
		predictedClassesFile.close()
	predictedProba = model.predict_proba(X);
	if options.predictedProbaFileName != None:
		# Record the predicted probabilities
		predictedProbaFile = open(options.predictedProbaFileName, 'w+')
                for i in range(X.shape[0]):
                        # Iterate through the predicted classes for each and record them along with the peak names
                        predictedProbaFile.write(peakNamesForData[i] + "\t" + \
				"\t".join([str(round(pp, 6)) for pp in predictedProba[i,:]]) + \
				"\n")
                predictedProbaFile.close()


def predictNewSequencesRegressionNoEval(model, X, peakNamesForData):
	print("Evaluating model...")
	predictions = model.predict(X);
	print("Saving predictions (if files have been specified)")
        if options.predictedClassesFileName != None:
                # Record the predictions
                predictedClassesFile =\
			open(options.predictedClassesFileName, 'w+')
                for i in range(X.shape[0]):
                        # Iterate through the predicted classes for each and record them along with the peak names
                        predictedClassesFile.write(peakNamesForData[i] + "\t" + \
				"\t".join([str(p) for p in predictions[i,:]]) + \
				"\n")
                predictedClassesFile.close()

		
def predictNewSequencesNoEvaluation(options):
	# Predict the values for a new set of sequences
	model = model_from_json(open(options.architectureFileName).read())
	print("Loading model")
	model.load_weights(options.weightsFileName)
	print("Model has been loaded.")
	X = np.array(1)
	peakNamesForData = []

	if options.fastaFileName != None:
		# The sequences were given in fasta format, so convert their format
		assert options.narrowPeakFileName == None, \
			"should not have a narrowPeakFileName input because \
				also have a fastaFileName input"
		sequencesFileName, numSequences, sequenceIDs =\
			convertFastaFileToSequencesFile(options.fastaFileName)
		peakNamesForData =\
			list(itertools.chain.from_iterable(itertools.repeat(sID, 2) \
				for sID in sequenceIDs))
		X, skippedIndices =\
                	makeSequenceInputArraysNoLabels(sequencesFileName, \
				(1,4,options.sequenceLength), numSequences, \
                        	perBaseTrackFileNames=options.perBaseTrackFileName, \
				multiMode=options.multiMode)

	elif options.narrowPeakFileName != None:
		# Only the peaks have been provided, so get the sequences from the peak summits +/-
		_, _, optimalRegionListFiltPlus, _, _, positiveFastaFileName =\
			createPositiveSetFromNarrowPeaks(options.narrowPeakFileName, \
				options.genomeFileName, \
				dataShape=(1,4,options.sequenceLength), \
				createOptimalBed=options.createOptimalBed, \
				createOptimalBedFilt=True, \
				maxPeakLength=options.maxPeakLength, \
				chroms=options.chroms, \
				chromSizesFileName=options.chromSizesFileName, \
				chromEdgeDistLimit=options.chromEdgeDistLimit)
		sequencesFileName, numSequences, sequenceIDs =\
			convertFastaFileToSequencesFile(positiveFastaFileName)
		print ("The number of sequences is:  " + str(numSequences))
		X, skippedIndices =\
                	makeSequenceInputArraysNoLabels(sequencesFileName, \
				(1,4,options.sequenceLength), numSequences, \
                        	perBaseTrackFileNames=options.perBaseTrackFileName, \
				multiMode=options.multiMode)
        	index = 0
        	for region in optimalRegionListFiltPlus:
                	# Iterate through the peaks and make a list of the peak names corresponding to the numpy arrays
                	if index not in skippedIndices:
                        	# The current peak was included in the dataset
                        	peakNamesForData.append(show_value(region[3]))
                        	peakNamesForData.append(show_value(region[3]))
                	index = index + 1

	if options.classification:
		# Evaluate the classification model
		predictNewSequencesClassificationNoEval(options, model, X, \
			peakNamesForData)
	else:
		# Evaluate the regression model
		predictNewSequencesRegressionNoEval(model, X, \
			peakNamesForData)


if __name__=="__main__":
	options = parseArgument()
	predictNewSequencesNoEvaluation(options)
	bt.helpers.cleanup()
