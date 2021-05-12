import sys
import argparse
import numpy as np

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
                        "Create a file with the numbers of usable orthologs for each peak")
        parser.add_argument("--predictionsFileName", required=True,\
                        help='First column is peak names, other columns are predictions, peaks and reverse complements should be consecutive')
        parser.add_argument("--outputFileName", required=True, \
                        help='Name of file where the numbers of usable orthologs will be recorded')
        options = parser.parse_args()
        return options

def getNumberUsableOrthologs(options):
	# Create a file with the numbers of usable orthologs for each peak
	predictionsFile = open(options.predictionsFileName)
	outputFile = open(options.outputFileName, 'w+')
	for predictionsLine in predictionsFile:
		# Iterate through the predictions and get the number of orthologs with a prediction for each peak
		predictionsLineElements = predictionsLine.strip().split("\t")
		predictions = np.array([float(ple) for ple in predictionsLineElements[1:len(predictionsLineElements)]])
		usableOrthologIndices = np.where(predictions >= 0)
		numUsableOrthologs = usableOrthologIndices[0].shape[0]
		outputFile.write(predictionsLineElements[0] + "\t" + str(numUsableOrthologs) + "\n")
	predictionsFile.close()
	outputFile.close()

if __name__=="__main__":
        options = parseArgument()
	getNumberUsableOrthologs(options)
