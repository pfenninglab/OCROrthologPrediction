# OCROrthologPrediction
This repository contains models and code for predicting open chromatin status of OCR orthologs.

## Scripts for General Use (in src):
predictNewSequencesNoEvaluation.py: takes machine learning model (json file for model architecture and hdf5 file for model weights) and gzipped narrowPeak or fasta file and makes predictions for the sequences

makePredictNewSequencesNoEvaluationScript.py: creates a script for running predictNewSequencesNoEvaluation.py on a list of gzipped narrowPeak files

sequenceOperationsCore.py: utilities used in predictNewSequencesNoEvaluation.py

## Models (in models):
### Brain models:
#### Trained on mouse sequences, flanking region negatives:
Architecture file: brainEnhancer_flankNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_flankNeg_500bp_conv5.hdf5
#### Trained on mouse sequences, open chromatin in other tissues negatives:
Architecture file: brainEnhancer_nonCerebrumMouseTissueNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_nonCerebrumMouseTissueNeg_500bp_conv5.hdf5
#### Trained on mouse sequences, large G/C- and repeat-matched region negatives:
Architecture file: brainEnhancer_RandomGCRepeatLargeNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_RandomGCRepeatLargeNeg_500bp_conv5.hdf5
#### Trained on mouse sequences, small G/C- and repeat-matched region negatives:
Architecture file: brainEnhancer_RandomGCRepeatSmallNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_RandomGCRepeatSmallNeg_500bp_conv5.hdf5
#### Trained on mouse sequences, dinucleotide-shuffled region negatives:
Architecture file: brainEnhancer_DiShuf10XNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_DiShuf10XNeg_500bp_conv5.hdf5
#### Trained on mouse sequences, non-OCR orthologs of OCR negatives:
Architecture file: brainEnhancer_euarchontaglireEnhLooseOrthNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_euarchontaglireEnhLooseOrthNeg_500bp_conv5.hdf5
#### Trained on sequences from multiple species, non-OCR orthologs of OCR negatives:
Architecture file: brainEnhancer_humanMouseMacaqueRat_euarchontaglireEnhLooseOrthNeg_500bp_conv5_architecture.json

Weights file: brainEnhancer_humanMouseMacaqueRat_euarchontaglireEnhLooseOrthNeg_500bp_conv5.hdf5
### Liver models:
#### Trained on mouse sequences, non-OCR orthologs of OCR negatives:
Architecture file: liverEnhancer_euarchontaglireEnhLooseOrthNeg_500bp_conv5_architecture.json

Weights file: liverEnhancer_euarchontaglireEnhLooseOrthNeg_500bp_conv5.hdf5
#### Trained on sequences from multiple species, non-OCR orthologs of OCR negatives:
Architecture file: liverEnhancer_mouseMacaqueRat_euarchontaglireEnhLooseOrthNeg_500bp_conv5_architecture.json

Weights file: liverEnhancer_mouseMacaqueRat_euarchontaglireEnhLooseOrthNeg_500bp_conv5.hdf5


## Cluster images (in clusters):
Brain cluster images: in clusters/brain

Liver cluster images: in clusters/liver

Color images color bar: clusters/colorbar_wr.svg

List of species in cluster heatmaps from left to right: clusters/BoreoeutheriaTreeNamesNew.txt


## Scripts for Generating Figures in Kaplow _et al_. (in evaluationScripts):
evaluateSingleSpeciesModelsTestSet.sh: evaluates mouse-only models on the test set

evaluateMultiSpeciesModelsTestSet.sh: evaluates multi-species models on the test set

plotModelPerformanceBarGraphs.m: makes graphs with model performance

mapBrainEnhancersAcrossZoonomia.sh: maps brain open chromatin regions across all of the mammals from the Zoonomia Project and predicts their brain open chormatin statuses

mapLiverEnhancersAcrossZoonomiaOld.sh: maps liver open chromatin regions across all of the mammals from the Zoonomia Project and predicts their liver open chormatin statuses

plotPredictionsVsEvolutionaryDist.m: makes plots comparing predicted activity to evolutionary distance from mouse

plotPredictionsVsGenomeQuality.m: makes plots comparing predicted activity to genome quality

comparePeakConservationToPredictedActivityConservation.sh: compares predicted open chromatin conservation to conservation scores from PhastCons and PhyloP

comparePredictionsToConservation.m: makes plot comparing predicted open chromatin conservation to conservation scores

evaluateCrossSpeciesLiverExpr.sh: identifies genes with rodent-specific expression and near open chromatin regions with predicted rodent-specific open chromatin

limmaCladeSpecificLiverExpr.r: uses limma to identify genes with rodent-specific liver expression

evaluateClusterOverlapWithEnhancersPlus.sh: evaluates cluster overlap with different enhancer sets

Note that some p-values in comments have not been properly corrected for multiple hypotheses; those p-values were corrected elsewhere before they were reported.


## Methods Used in Scripts in evaluationScripts (in utils):
filterPeakName.py: filters a bed file to include (or exclude) only peaks in a list of peak names

makeFilterPeakNameScript.py: makes a script that will run filterPeakName.py on a list of pairs of files

predictNewSequences.py: makes predictions using a machine learning model for regions defined in a narrowPeak or fasta file and evaluate the predictions

sequenceOperations.py: manipulates regions and sequences to prepare them for deep learning models

MLOperations.py: evaluates machine learning models according to different metrics

makeViolinPlotTissueComparison.py: makes violoin plots for evaluating model peformance on tissue-specific open chromatin regions and shared open chromatin regions

gatherPeakPredictionsAcrossSpecies.py: uses a list of predictions of open chromatin regions in different species to make a region by species matrix of predictions

convertChromNames.py: converts chromosome names in a bed file from one naming convention to another

makeConvertChromNamesScript.py: makes a script for running convertChromNames.py on a list of bed file, chromosome name dictionary pairs

convertH3K27acMatToBinaryMat.py: converts a table with H3K27ac ChIP-seq conservation from Villar _et al_. 2015 into a binary matrix

runLOLA.r: runs lola for a pair of bed files

makeLolaScript.py: makes script that runs LOLA for pairs of bed files and a background bed file

processLolaResults.py: compiles results from multiple runs of LOLA into a table

getNumberUsableOrthologs.py: gets the number of usable orthologs for open chromatin regions


## Dependencies:
python (version 2.7.17)

numpy (version 1.16.6)

pybedtools (version 0.8.1)

keras (version 1.2.2)

biopython (version 1.74)

Theano (version 1.0.4)

pygpu (version 0.7.6)

cudnn (version 7.3.1)

MEME suite (version 4.12.0) (used for only utils and evaluationScripts)

bedtools (version 2.27.1) (used for only utils and evaluationScripts)

HALPER (https://github.com/pfenninglab/halLiftover-postprocessing) (used for only utils and evaluationScripts)

scipy (version 1.2.1) (used for only utils and evaluationScripts)

sklearn (version 0.20.3) (used for only utils and evaluationScripts)

matplotlib (version 2.2.3) (used for only utils and evaluationScripts)

prg (https://github.com/meeliskull/prg/blob/master/R_package/prg/R/prg.R) (used for only utils and evaluationScripts)

rpy2 (version 2.8.6) (used for only utils and evaluationScripts)

seaborn (version 0.9.0) (used for only utils and evaluationScripts)

Hierarchical Alignment (HAL) Format API (version 2.1) (used for only utils and evaluationScripts)

MATLAB (verson R2017a) (used for only utils and evaluationScripts)

bigWigAverageOverBed (http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/) (used for only utils and evaluationScripts)

R (version 3.6.0) (used for only utils and evaluationScripts)

limma (version 3.42.2) (used for only utils and evaluationScripts)

LOLA (version 1.16.0) (used for only utils and evaluationScripts)

liftOver (http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/) (used for only utils and evaluationScripts)


## Contact
Irene Kaplow (ikaplow@cs.cmu.edu)
