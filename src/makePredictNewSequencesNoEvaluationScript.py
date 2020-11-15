import sys
import argparse
from itertools import izip

def parseArgument():
	# Parse the input
	parser = argparse.ArgumentParser(description =\
		"Make a script that will predict the values for \
			a new list of narrowPeak files")
	parser.add_argument("--architectureFileName", required=False, \
		help='Model architecture file in json format')
	parser.add_argument("--weightsFileName", required=False, \
		help='Model weights file in hdf5 format')
	parser.add_argument("--narrowPeakFileNameListFileName", \
		required=True, \
		help='File with list of narrowPeak file names')
	parser.add_argument("--maxPeakLength", type=int, required=False, \
		default=None, help='Maximum number of bases per peak')
	parser.add_argument("--sequenceLength", type=int, required=False, \
		default=500, help='Number of bases in each sequence')
	parser.add_argument("--predictedClassesFileNameSuffix", \
		default="predictedClasses.txt", required=False, \
		help='Suffix of file names where predicted classes will be recorded, \
			should not start with _')
        parser.add_argument("--predictedProbaFileNameSuffix", \
		default="predictedProba.txt", required=False, \
		help='Suffix of file names where \
			predicted probabilities will be recorded, \
			should not start with _, \
			will not be used for regression models')
        parser.add_argument("--genomeFileNameListFileName", required=True, \
		help='File with genome sequence file list, \
			where the genome in each line corresponds to \
			the narrowPeak file in the same line')
	parser.add_argument("--chromSizesFileNameListFileName", required=True, \
                help='File with chromosome sizes file list, \
			where the chromosome sizes file \
			in each line corresponds to \
			the narrowPeak file in the same line')
	parser.add_argument("--createOptimalBed", action='store_true', \
		required=False, \
                help='Remove peaks on unknown, alternative, \
			and random chromosomes before making predictions')
        parser.add_argument("--logLabels", action='store_true', \
		required=False, \
		help='Include if labels (if labels are signals) \
			should be log2ed')
	parser.add_argument("--classification", action='store_true', \
		required=False, help='Include if evaluating classification')
	parser.add_argument("--path", required=True, \
		help='Path to predictNewSequencesNoEvaluation.py')
	parser.add_argument("--scriptFileName", required=True, \
		help='Name of file where script will be recorded')
	options = parser.parse_args();
	return options


def makePredictNewSequencesNoEvaluationScript(options):
	# Make a script that will predict the values for a new set of sequences and evalute the predictions
	narrowPeakFileNameListFile = open(options.narrowPeakFileNameListFileName)
	genomeFileNameListFile = open(options.genomeFileNameListFileName)
	chromSizesFileNameListFile = open(options.chromSizesFileNameListFileName)
	scriptFile = open(options.scriptFileName, 'w+')

	for narrowPeakFileNameStr, genomeFileNameStr, chromSizesFileNameStr in \
		izip(narrowPeakFileNameListFile, genomeFileNameListFile, \
			chromSizesFileNameListFile):
		# Iterate through the lines of the narrowPeak file list and the corresponding genomes and make a line in the script for each
		narrowPeakFileName = narrowPeakFileNameStr.strip()
		narrowPeakFileNameElements = narrowPeakFileName.split(".")
		narrowPeakFileNamePrefix =\
			".".join(narrowPeakFileNameElements[0:-2])
		predictedClassesFileName =\
			narrowPeakFileNamePrefix + "_" + \
				options.predictedClassesFileNameSuffix
		predictedProbaFileName =\
			narrowPeakFileNamePrefix + "_" + \
				options.predictedProbaFileNameSuffix

		scriptFile.write(" ".join(["python", options.path + \
			"/predictNewSequencesNoEvaluation.py --architectureFileName", \
			options.architectureFileName, "--weightsFileName", \
			options.weightsFileName, "--narrowPeakFileName", \
			narrowPeakFileName, "--sequenceLength", \
			str(options.sequenceLength), "--predictedClassesFileName", \
			predictedClassesFileName, "--predictedProbaFileName", \
			predictedProbaFileName, "--genomeFileName", \
			genomeFileNameStr.strip(), "--chromSizesFileName", \
			chromSizesFileNameStr.strip()]))

		if options.createOptimalBed:
			# Add the createOptimalBed option
			scriptFile.write(" --createOptimalBed")
		if options.logLabels:
                        # Add the createOptimalBed option
                        scriptFile.write(" --logLabels")
		if options.classification:
			# Add the classification option
			scriptFile.write(" --classification")
		scriptFile.write("\n")

	narrowPeakFileNameListFile.close()
	genomeFileNameListFile.close()
	scriptFile.close()


if __name__=="__main__":
	import sys
	options = parseArgument()
	makePredictNewSequencesNoEvaluationScript(options)
