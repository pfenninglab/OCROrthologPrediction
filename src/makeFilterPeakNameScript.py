import sys
import argparse

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
                        "Select filter peaks for a list of peak names")
        parser.add_argument("--unfilteredPeakFileNameListFileName", required=True,\
                        help='list of bed/gzipped bed files with unfiltered lists of peaks')
        parser.add_argument("--unfilteredPeakNameCol", type=int, required=False, default=3,\
                        help='Column in the unfiltered peak name file that has the peak names')
        parser.add_argument("--peakListFileName", required=True,\
                        help='File with the list of peak names')
        parser.add_argument("--peakNameCol", type=int, required=False, default=0,\
                        help='Column in the peak name file that has the peak names')
        parser.add_argument("--numFileNameElementsToRemove", type=int, required=False, default=1,\
                        help='Number of parts of the input file name, separted by ., to remove when creating the output file name')
        parser.add_argument("--outputFileNameSuffix", required=True,\
                        help='Suffix of bed file names where the selected peaks will be written, should not start with .')
        parser.add_argument("--scriptFileName", required=True,\
                        help='File where script will be recorded')
        parser.add_argument("--codePath", required=False, default="/home/ikaplow/RegulatoryElementEvolutionProject/src/RegElEvoCode",\
                        help='Path to filterPeakName.py')
        options = parser.parse_args()
        return options

def makeFilterPeakNameScript(options):
	unfilteredPeakFileNameListFile = open(options.unfilteredPeakFileNameListFileName)
	scriptFile = open(options.scriptFileName, 'w+')
	for line in unfilteredPeakFileNameListFile:
		# Iterate through the unfiltered peak files and make a line in the script for each
		unfilteredPeakFileName = line.strip()
		unfilteredPeakFileNameElements = unfilteredPeakFileName.split(".")
		outputFileName = ".".join(unfilteredPeakFileNameElements[0:0-options.numFileNameElementsToRemove]) + "." + options.outputFileNameSuffix
		scriptFile.write(" ".join(["python", options.codePath + "/filterPeakName.py", "--unfilteredPeakFileName", unfilteredPeakFileName, \
			"--unfilteredPeakNameCol", str(options.unfilteredPeakNameCol), "--peakListFileName", options.peakListFileName, "--peakNameCol", \
			str(options.peakNameCol), "--outputFileName", outputFileName]) + "\n")
	unfilteredPeakFileNameListFile.close()
	scriptFile.close()

if __name__=="__main__":
        options = parseArgument()
        makeFilterPeakNameScript(options)
