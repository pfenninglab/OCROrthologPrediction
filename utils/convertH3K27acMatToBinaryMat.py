import sys
import argparse
import numpy as np

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
        	"Convert a file with H3K27ac region ortholog names into a mostly binary matrix, averaging results for repeated peaks")
        parser.add_argument("--H3K27acRegionFileName", required=True,\
                help='H3K27ac orthologs, column headerCol is overlapping OCR peak names, other columns are active orthologs or 0s')
	parser.add_argument("--headerCol", type=int, required=False, default=1,\
                help='Column with peak name, 1-indexed')
        parser.add_argument("--outputFileName", required=True, \
                help='Name of file where the average ortholog activities will be recorded')
        options = parser.parse_args()
        return options

def parseH3K72acLine(headerCol, H3K27acLine):
	# Parse the line from the H3K27ac file
	lineElements = H3K27acLine.split("\t")
	peakOrthologActivities = np.zeros((len(lineElements) - headerCol, 1))
	for i in range(headerCol, len(lineElements)):
		# Iterate through the ortholog values, replace the strings with 1's, and add each to the peak entry
		if "H3K27Ac" in lineElements[i]:
			# The ortholog of the H3K27ac region in the current species is active
			peakOrthologActivities[i-headerCol] = 1
		else:
			# The ortholog of the H3K27ac region in the current species is inactive or does not exist
			peakOrthologActivities[i-headerCol] = int(lineElements[i])
	return lineElements[0:headerCol], peakOrthologActivities

def recordAveragePeakActivities(outputFile, peakHeader, peakOrthologActivities):
	# Record the average ortholog activities across H3K27ac regions that overlap a peak
	outputFile.write("\t".join(ph for ph in peakHeader))
        for i in range(peakOrthologActivities.shape[0]):
        	# Iterate through the species and get the average activity for each ortholog
                peakOrthologActitivitesi = peakOrthologActivities[i,peakOrthologActivities[i,:] >= 0]
                if peakOrthologActitivitesi.shape[0] == 0:
                	# There are no orthologs in the current species
                        outputFile.write("\t" + "-1")
                else:
                        # Compute the average activity across all of the H3K27ac regions overlapping the peak
                        outputFile.write("\t" + str(np.mean(peakOrthologActitivitesi)))
	outputFile.write("\n")
	return outputFile

def convertH3K27acMatToBinaryMat(options):
	# Convert a file with H3K27ac region ortholog names into a mostly binary matrix, averaging results for repeated peaks
	H3K27acRegionFile = open(options.H3K27acRegionFileName)
	line = H3K27acRegionFile.readline().strip()
	peakHeader, peakOrthologActivities = parseH3K72acLine(options.headerCol, line)
	peakName = peakHeader[-1]
	outputFile = open(options.outputFileName, 'w+')
	for line in H3K27acRegionFile:
		# Iterate through the OCRs overlapping H3K27ac regions and get the average results for each
		currentPeakHeader, currentPeakOrthologActivities = parseH3K72acLine(options.headerCol, line)
		if peakName == currentPeakHeader[-1]:
			# Add the current peak ortholog activities to the ortholog activities for peak peakName
			peakOrthologActivities = np.hstack((peakOrthologActivities, currentPeakOrthologActivities))
		else:
			# Compute the average peak ortholog activities for the previous peak
			outputFile = recordAveragePeakActivities(outputFile, peakHeader, peakOrthologActivities)
			peakHeader = currentPeakHeader
			peakName = currentPeakHeader[-1]
			peakOrthologActivities = currentPeakOrthologActivities
	outputFile = recordAveragePeakActivities(outputFile, peakHeader, peakOrthologActivities)
	outputFile.close()

if __name__=="__main__":
        options = parseArgument()
        convertH3K27acMatToBinaryMat(options)
