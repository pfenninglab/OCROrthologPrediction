import sys
import argparse
import gzip

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
                        "Filter peaks for a list of peak names")
	parser.add_argument("--unfilteredPeakFileName", required=True,\
                        help='File with unfiltered list of peaks (can be gzipped), must have a column with peak names')
	parser.add_argument("--unfilteredPeakNameCol", type=int, required=False, default=3,\
                        help='Column in the unfiltered peak name file that has the peak names')
	parser.add_argument("--peakListFileName", required=True,\
                        help='File with the list of peak names (can be gzipped)')
	parser.add_argument("--peakNameCol", type=int, required=False, default=0,\
                        help='Column in the peak name file that has the peak names')
	parser.add_argument("--allCaps", action="store_true", required=False,\
                        help='Convert all peak names to capital letters')
	parser.add_argument("--removePeaks", action="store_true", required=False,\
                        help='Remove peaks in the list instead of keeping them')
	parser.add_argument("--splitWhiteSpace", action="store_true", required=False,\
                        help='Split using white space instead of tab')
	parser.add_argument("--splitCharacterUnfiltered", required=False,\
                        help='Character for splitting the unfiltered peaks')
        parser.add_argument("--outputFileName", required=True,\
                        help='File where the selected peaks will be written')
	options = parser.parse_args()
        return options

def filterPeakNames(options):
	# Filter a file of peaks based on the peak names
	peakListFile =\
		gzip.open(options.peakListFileName) if options.peakListFileName.endswith("gz") else \
			open(options.peakListFileName) # Check if the file is gzipped when determining how to open it
	peakList = []
	for line in peakListFile:
		# Iterate through the peak names and make a list of them
		lineElements = None
		if options.splitWhiteSpace:
			# Split at white space
			lineElements = line.strip().split()
		else:
			# Split at tabs
			lineElements = line.strip().split("\t")
		peakList.append(lineElements[options.peakNameCol].upper() if options.allCaps else \
			lineElements[options.peakNameCol])
	print("The number of peaks is: " + str(len(peakList)))
	print("The first peak is: " + peakList[0])
	peakListFile.close()
	unfilteredPeakFile =\
		gzip.open(options.unfilteredPeakFileName) if options.unfilteredPeakFileName.endswith("gz") else \
			open(options.unfilteredPeakFileName) # Check if the file is gzipped when determining how to open it
	outputFile = open(options.outputFileName, 'w+')
	for line in unfilteredPeakFile:
		# Iterate through the lines of the unfiltered peak file and record those with peak names in the list
		lineElements = None
                if options.splitWhiteSpace:
                        # Split at white space
                        lineElements = line.strip().split()
                elif options.splitCharacterUnfiltered != None:
			# Split at the specified character
			lineElements = line.strip().split(options.splitCharacterUnfiltered)
		else:
                        # Split at tabs
                        lineElements = line.strip().split("\t")
		peakName = lineElements[options.unfilteredPeakNameCol]
		if options.allCaps:
			# Convert the peak name to upper-case letters
			peakName = peakName.upper()
		if ((peakName in peakList) and (not options.removePeaks)) or \
			((peakName not in peakList) and options.removePeaks):
			# Keep the current line
			outputFile.write(line)
	unfilteredPeakFile.close()
	outputFile.close()

if __name__=="__main__":
        options = parseArgument()
        filterPeakNames(options)
