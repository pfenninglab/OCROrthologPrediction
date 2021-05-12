import sys
import argparse
import numpy as np

def parseArgument():
	# Parse the input
	parser = argparse.ArgumentParser(description="Process results from LOLA")
	parser.add_argument("--lolaResultsFileNameListFileName", required=True, help="List of file names with LOLA results")
	parser.add_argument("--lolaHeadersFileName", required=True, help="Headers for database region lists used in LOLA")
	parser.add_argument("--lolaHeadersExcludeFileName", required=False, default=None, \
		help="Headers for database region lists used in LOLA that should not be included, should be subset of lolaHeadersFileName")
	parser.add_argument("--rowHeaderIndex", type=int, required=False, default=0, \
                help="Part of the file name after the / (split by .) that will be in the row header")
	parser.add_argument("--rowHeaderElementIndex", type=int, required=False, default=0, \
                help="Part of the file name after the rowHeaderIndexth . (split by _) that will be in the row header")
	parser.add_argument("--fileNamePartsInHeader", action='append', type=int, required=False, default=[1], \
		help="Parts of the file name that are in the lola headers, where parts are separated by .'s")
	parser.add_argument("--outputFileName", required=True, help="Name where p-values from LOLA will be recorded")
	parser.add_argument("--singleFile", action='store_true', required=False, \
                help="lolaResultsFileNameListFileName is the name of a file with LOLA results and not a file with a list of LOLA results file names")
	parser.add_argument("--outputLog", action='store_true', required=False, \
		help="Output the -log10 of the p-values and no headers")
	options = parser.parse_args()
	return options

def processLolaResults(options):
	# Process results from LOLA
	outputFile = open(options.outputFileName, 'w+')
	if not options.outputLog:
		# Include the headers
		outputFile.write("Region Origin")
	lolaHeadersFile = open(options.lolaHeadersFileName)
	lolaHeaders = [line.strip() for line in lolaHeadersFile]
	lolaHeadersFile.close()
	lolaHeadersExclude = []
	if options.lolaHeadersExcludeFileName != None:
		# There are headers that should be excluded
		lolaHeadersExcludeFile = open(options.lolaHeadersExcludeFileName)
		lolaHeadersExclude = [line.strip() for line in lolaHeadersExcludeFile]
		lolaHeadersExcludeFile.close()
	if not options.outputLog:
		# Include the headers
		for lh in lolaHeaders:
			# Iterate through the headers and record each
			if lh not in lolaHeadersExclude:
				# The current header should be included
				outputFile.write("\t" + lh)
		outputFile.write("\n")
	lolaResultsFileNameList = []
	if options.singleFile:
		# The inputted file name is a file with LOLA results
		lolaResultsFileNameList = [options.lolaResultsFileNameListFileName]
	else:
		# The inputted file name is a list of files with LOLA results
		lolaResultsFileNameListFile = open(options.lolaResultsFileNameListFileName)
		lolaResultsFileNameList = [line.strip() for line in lolaResultsFileNameListFile]
		lolaResultsFileNameListFile.close()
	numTests = (len(lolaHeaders) - len(lolaHeadersExclude)) * len(lolaResultsFileNameList)
	for lolaResultsFileName in lolaResultsFileNameList:
		# Iterate through the results files and record the p-value for each TF in each category
		if not options.outputLog:
			# Include the headers
			TF = lolaResultsFileName.split("/")[-1].split(".")[options.rowHeaderIndex].split("_")[options.rowHeaderElementIndex]
			outputFile.write(TF + "\t")
		lolaResultsFile = open(lolaResultsFileName)
		for line in lolaResultsFile:
			# Iterate through the categories and record the Bonferroni-corrected p-value for each
			lineElements = line.strip().split("\t")
			currentHeaderElements = lineElements[20].split(".")
			currentHeaderElementsFilt = [currentHeaderElements[fnp] for fnp in options.fileNamePartsInHeader]
			currentHeader = ".".join(currentHeaderElementsFilt)
			if currentHeader in lolaHeadersExclude:
				# Skip the current category
				continue
			if not options.outputLog:
				# Output the p-value
				pVal = (10 ** (0 - float(lineElements[3]))) * numTests
				pValStr = str(pVal)
				if pVal > 1:
					# Change the p-value string to be > 1
					pValStr = "> 1"			
				outputFile.write(pValStr + "\t")
			else:
				# Output the -log10 of the p-value
				pVal = float(lineElements[3]) - np.log10(numTests)
				if pVal < 0:
					# The p-value is > 1, so set its -log10 to 0
					pVal = 0.0
				if pVal > 250:
					# The p-value is really small, so set its -log10 to 250
					pVal = 250.0
				outputFile.write(str(pVal) + "\t")
		outputFile.write("\n")
	outputFile.close()
	
if __name__ == "__main__":
	options = parseArgument()
	processLolaResults(options)
