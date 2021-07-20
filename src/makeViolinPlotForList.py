import sys
import argparse
import numpy as np
import seaborn as sns
import matplotlib
import matplotlib.pyplot as plt

def parseArgument():
        # Parse the input
        parser=argparse.ArgumentParser(description=\
                        "Make violin plot for a list of files")
        parser.add_argument("--inputFileName", action = "append", required=True,\
                        help='File that will go into violin plot')
        parser.add_argument("--colNum", type = int, action = "append", required=True,\
                        help='Number of column with data that will go into violin plot, should be 0-indexed')
        parser.add_argument("--outputFileName", required=True,\
                        help='File where violin plot will be saved, should end with .svg')
        options = parser.parse_args()
        return options

def makeViolinPlotForList(options):
	# Make violin plot for a list of files
	assert(len(options.inputFileName) == len(options.colNum))
	dataList = []
	for inf, cn in zip(options.inputFileName, options.colNum):
		# Iterate through the input files and load each
		currentData = np.loadtxt(inf, usecols = [cn])
		dataList.append(currentData)
	plot = sns.violinplot(data=dataList)
	fig = plot.get_figure()
	fig.savefig(options.outputFileName)

if __name__=="__main__":
        options = parseArgument()
        makeViolinPlotForList(options)
