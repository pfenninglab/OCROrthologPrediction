import sys
import argparse

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
                        "Create a file with the average predictions for each peak and its reverse complement")
        parser.add_argument("--predictionsFileName", required=True,\
                        help='Prediction, first column is peak names, 2nd column is predictions, peaks and reverse complements should be consecutive')
        parser.add_argument("--predictionCol", required=False, type=int, default=1, \
                        help='Column with prediction')
        parser.add_argument("--noPeakNames", required=False, action="store_true", \
                        help='There is no column with peak names')
        parser.add_argument("--outputFileName", required=True, \
                        help='Name of file where the average predictions will be recorded')
        options = parser.parse_args()
        return options

def averagePeakPredictions(options):
	# Average predictions between peaks and their reverse complements
	predictionsFile = open(options.predictionsFileName)
	outputFile = open(options.outputFileName, 'w+')
	predictionsLine = predictionsFile.readline()
	while predictionsLine != "":
		# Iterate through the predictions and get their averages between the peak seqeunces and their reverse complements
		predictionsLineElements = predictionsLine.strip().split("\t")
		predictionsRCLineElements = predictionsFile.readline().strip().split("\t")
		if not options.noPeakNames:
			assert(predictionsLineElements[0] == predictionsRCLineElements[0])
		predictionAverage =\
			(float(predictionsLineElements[options.predictionCol]) + float(predictionsRCLineElements[options.predictionCol]))/2.0
		if not options.noPeakNames:
			# Record the peak name
			outputFile.write(predictionsLineElements[0] + "\t")
		outputFile.write(str(predictionAverage) + "\n")
		predictionsLine = predictionsFile.readline()
	predictionsFile.close()
	outputFile.close()

if __name__=="__main__":
        options = parseArgument()
        averagePeakPredictions(options)
