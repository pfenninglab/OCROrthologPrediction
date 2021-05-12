import sys
import argparse
import os

def parseArgument():
	# Parse the input
	parser = argparse.ArgumentParser(description="Make a script that will run Lola on a list of files for a specific database")
	parser.add_argument("--queryRegionListFileName", required=True, help="List of narrowPeak files for Lola")
	parser.add_argument("--bedFileNamePrefix", required=False, \
		default="/srv/scratch/shared/surya/imk1/TFBindingPredictionProject/C2H2ZFBedFiles/collection/regions", \
		help="Prefix of bed file names")
	parser.add_argument("--universeDataFileName", required=False,\
		default="/srv/scratch/shared/surya/imk1/TFBindingPredictionProject/EncodeOtherZnfData/Encode3Datahg38/allZnfReliablePeakFilt.bed",\
		help="Universal set for Lola")
	parser.add_argument("--dbLocation", required=True, help="Database location for Lola")
	parser.add_argument("--outputFileNamePath", required=False, help="Path to the output file")
	parser.add_argument("--outputFileNameSuffix", required=False, default="LolaResults.tsv", help="Suffix of output file name")
	parser.add_argument("--scriptFileName", required=True, help="Name of file where script will be written")
	parser.add_argument("--bedMade", action='store_true', required=False, \
		help="The narrowPeak files have already been converted into bed files")
	parser.add_argument("--queriesAreBeds", action='store_true', required=False, \
		help="The query file names are the bed files")
	parser.add_argument("--redefineUserSets", action='store_true', required=False, \
		help="Use the redefineUserSets option in Lola")
	parser.add_argument("--path", required=True, help="Path to runLOLA.r, should not end with /")
	options = parser.parse_args()
	return options

def makeLolaScript(options):
	# Make a script that will run Lola on a list of files for a specific database
	queryRegionListFile = open(options.queryRegionListFileName)
	scriptFile = open(options.scriptFileName, 'w+')
	for line in queryRegionListFile:
		# Iterate through the query regions and make a line in the script to run Lola for each
		bedFileName = line.strip()
		lineElements = line.strip().split(".")
		queryRegionFileNamePrefix = ".".join(lineElements[:-1])
		if not options.queriesAreBeds:
			# Create the bed file name and, if necessary, the bed file
			TFName = lineElements[0].split("/")[-1].split("_")[0]
			bedFileName = options.bedFileNamePrefix + "/" + TFName + ".bed"
			if not options.bedMade:
				# Make the bed file from the narrowPeak file
				os.system(" ".join(["zcat", line.strip(), \
					"| grep -v chrUn | grep -v random | grep -v alt | grep -v chrM | grep -v chrY | sort -u -k1,1 -k2,2n -k3,3n -k10,10n | cut -f1,2,3 >", \
					bedFileName]))
		outputFileName = queryRegionFileNamePrefix + "." + options.outputFileNameSuffix
		if options.outputFileNamePath:
			# Use the specified output file name path instead of the path from the query
			queryRegionFileNamePrefixElements = queryRegionFileNamePrefix.split("/")
			outputFileName =\
				options.outputFileNamePath + "/" + queryRegionFileNamePrefixElements[-1] + "." + options.outputFileNameSuffix
		scriptFile.write(" ".join(["Rscript", options.path + "/" + "runLOLA.r", bedFileName, options.universeDataFileName, \
			options.dbLocation, outputFileName]))
		if options.redefineUserSets:
			# Set redefineUserSets to TRUE
			scriptFile.write(" TRUE" + "\n")
		else:
			# Set redefineUserSets to FALSE
			scriptFile.write(" FALSE" + "\n")
	queryRegionListFile.close()
	scriptFile.close()

if __name__ == "__main__":
	options = parseArgument()
	makeLolaScript(options)
