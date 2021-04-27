# OCROrthologPrediction
This repository contains models and code for predicting open chromatin status of OCR orthologs.

## Scripts (in src):
predictNewSequencesNoEvaluation.py: takes machine learning model (json file for model architecture and hdf5 file for model weights) and gzipped narrowPeak or fasta file and makes predictions for the sequences

makePredictNewSequencesNoEvaluationScript.py: creates a script for running predictNewSequencesNoEvaluation.py on a list of gzipped narrowPeak files

sequenceOperationsCore.py: utilities used in predictNewSequencesNoEvaluation.py

## Dependencies:
python (version 2.7.17)

numpy (version 1.16.6)

pybedtools (version 0.8.1)

keras (version 1.2.2)

biopython (version 1.74)

Theano (version 1.0.4)

pygpu (version 0.7.6)

cudnn (version 7.3.1)

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

