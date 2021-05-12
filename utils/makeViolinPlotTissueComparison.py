import sys
import argparse
import numpy as np
import seaborn as sns
import matplotlib
import matplotlib.pyplot as plt

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
                        "Make violin plots for tissue prediction comparisons")
        parser.add_argument("--tissueOnlyPredFileName", required=True,\
                        help='Prediction probabilities for peaks in only tissue of interest')
        parser.add_argument("--tissueSharedPredFileName", required=True,\
                        help='Prediction probabilities for peaks shared between tissue of interest and other tissue')
        parser.add_argument("--tissueOtherPredFileName", required=True,\
                        help='Prediction probabilities for peaks in only other tissue')
        parser.add_argument("--negSetPredFileName", required=True,\
                        help='Prediction probabilities for negative set')
        parser.add_argument("--outputFileName", required=True,\
                        help='File where violin plot will be saved, should end with .svg')
        options = parser.parse_args()
        return options

def makeViolinPlotTissueComparison(options):
	# Make violin plots for tissue prediction comparisons
	tissueOnlyPred = np.loadtxt(options.tissueOnlyPredFileName, usecols=[1])
	tissueSharedPred = np.loadtxt(options.tissueSharedPredFileName, usecols=[1])
	tissueOtherPred = np.loadtxt(options.tissueOtherPredFileName, usecols=[1])
	negSetPred = np.loadtxt(options.negSetPredFileName, usecols=[1])
	plot = sns.violinplot(data=[tissueOnlyPred, tissueSharedPred, tissueOtherPred, negSetPred])
	fig = plot.get_figure()
	fig.savefig(options.outputFileName)

if __name__=="__main__":
        options = parseArgument()
	makeViolinPlotTissueComparison(options)
