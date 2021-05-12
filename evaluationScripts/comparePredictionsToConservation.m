% MODIFY PHASTCONS AND PHYLOP TO BE .data(:,1) FOR MEAN CONSERVATION

% Brain macaque enhancer orthologs
mouseTestBrainConservationInMacaque = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_inMacaqueBrain.bed');
mouseTestBrainConservationNonMacaque = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_nonMacaqueBrain.bed');
ranksum(mouseTestBrainConservationInMacaque.data(:,1), mouseTestBrainConservationNonMacaque.data(:,1))
median(mouseTestBrainConservationInMacaque.data(:,1)) - median(mouseTestBrainConservationNonMacaque.data(:,1))
ranksum(mouseTestBrainConservationInMacaque.data(:,3), mouseTestBrainConservationNonMacaque.data(:,3))
median(mouseTestBrainConservationInMacaque.data(:,3)) - median(mouseTestBrainConservationNonMacaque.data(:,3))
mouseTestBrainConservationPhyloPInMacaque = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_inMacaqueBrain.bed');
mouseTestBrainConservationPhyloPNonMacaque = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_nonMacaqueBrain.bed');
ranksum(mouseTestBrainConservationPhyloPInMacaque.data(:,1), mouseTestBrainConservationPhyloPNonMacaque.data(:,1))
median(mouseTestBrainConservationPhyloPInMacaque.data(:,1)) - median(mouseTestBrainConservationPhyloPNonMacaque.data(:,1))
ranksum(mouseTestBrainConservationPhyloPInMacaque.data(:,3), mouseTestBrainConservationPhyloPNonMacaque.data(:,3))
median(mouseTestBrainConservationPhyloPInMacaque.data(:,3)) - median(mouseTestBrainConservationPhyloPNonMacaque.data(:,3))
mouseTestBrainPredInMacaque = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_withPeakNames_rheMac8Huge_summitExtendedMin50Max2Protect5_inMacaqueBrain_test_conv5MuchMuchMoreFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
mouseTestBrainPredNonMacaque = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_withPeakNames_rheMac8Huge_summitExtendedMin50Max2Protect5_nonMacaqueBrain_test_conv5MuchMuchMoreFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
ranksum(mouseTestBrainPredInMacaque, mouseTestBrainPredNonMacaque)
median(mouseTestBrainPredInMacaque) - median(mouseTestBrainPredNonMacaque)
mouseTestBrainConservation = cat(1, mouseTestBrainConservationInMacaque.data(:,1), mouseTestBrainConservationNonMacaque.data(:,1));
[~, mouseTestBrainConservationIndices] = sort(mouseTestBrainConservation, 'descend');
[~, mouseTestBrainConservationRanking] = sort(mouseTestBrainConservationIndices);
mouseTestBrainConservationPhyloP = cat(1, mouseTestBrainConservationPhyloPInMacaque.data(:,1), mouseTestBrainConservationPhyloPNonMacaque.data(:,1));
[~, mouseTestBrainConservationPhyloPIndices] = sort(mouseTestBrainConservationPhyloP, 'descend');
[~, mouseTestBrainConservationPhyloPRanking] = sort(mouseTestBrainConservationPhyloPIndices);
mouseTestBrainPred = ones(size(mouseTestBrainPredInMacaque,1)/2+size(mouseTestBrainPredNonMacaque,1)/2, 1);
index = 0;
while index < size(mouseTestBrainPredInMacaque,1)/2
mouseTestBrainPred(index+1) = (mouseTestBrainPredInMacaque((2*index)+1) + mouseTestBrainPredInMacaque((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestBrainPred,1)
mouseTestBrainPred(index+1) = (mouseTestBrainPredNonMacaque((2*(index-(size(mouseTestBrainPredInMacaque,1)/2)))+1) + mouseTestBrainPredNonMacaque((2*(index-(size(mouseTestBrainPredInMacaque,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestBrainPredIndices] = sort(mouseTestBrainPred, 'descend');
[~, mouseTestBrainPredRanking] = sort(mouseTestBrainPredIndices);
median(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2)) - median(mouseTestBrainConservationRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
2*ranksum(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2), mouseTestBrainConservationRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
median(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1))) - median(mouseTestBrainConservationRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
2*ranksum(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)), mouseTestBrainConservationRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
median(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2)) - median(mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
2*ranksum(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2), mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
median(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1))) - median(mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
2*ranksum(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)), mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
2*signrank(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2), mouseTestBrainConservationRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
2*signrank(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)), mouseTestBrainConservationRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
2*signrank(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2), mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
2*signrank(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)), mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
mouseTestBrainConservationMax = cat(1, mouseTestBrainConservationInMacaque.data(:,3), mouseTestBrainConservationNonMacaque.data(:,3));
[~, mouseTestBrainConservationIndicesMax] = sort(mouseTestBrainConservationMax, 'descend');
[~, mouseTestBrainConservationRankingMax] = sort(mouseTestBrainConservationIndicesMax);
mouseTestBrainConservationPhyloPMax = cat(1, mouseTestBrainConservationPhyloPInMacaque.data(:,3), mouseTestBrainConservationPhyloPNonMacaque.data(:,3));
[~, mouseTestBrainConservationPhyloPIndicesMax] = sort(mouseTestBrainConservationPhyloPMax, 'descend');
[~, mouseTestBrainConservationPhyloPRankingMax] = sort(mouseTestBrainConservationPhyloPIndicesMax);
median(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2)) - median(mouseTestBrainConservationRankingMax(1:size(mouseTestBrainPredInMacaque,1)/2))
median(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1))) - median(mouseTestBrainConservationRankingMax(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
median(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2)) - median(mouseTestBrainConservationPhyloPRankingMax(1:size(mouseTestBrainPredInMacaque,1)/2))
median(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1))) - median(mouseTestBrainConservationPhyloPRankingMax(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
40*signrank(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2), mouseTestBrainConservationRankingMax(1:size(mouseTestBrainPredInMacaque,1)/2))
40*signrank(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)), mouseTestBrainConservationRankingMax(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
40*signrank(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2), mouseTestBrainConservationPhyloPRankingMax(1:size(mouseTestBrainPredInMacaque,1)/2))
40*signrank(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)), mouseTestBrainConservationPhyloPRankingMax(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
mouseTestBrainConservationRanking = size(mouseTestBrainConservation, 1) - mouseTestBrainConservationRanking;
mouseTestBrainConservationPhyloPRanking = size(mouseTestBrainConservationPhyloP, 1) - mouseTestBrainConservationPhyloPRanking;
mouseTestBrainPredRanking = size(mouseTestBrainPred, 1) - mouseTestBrainPredRanking;
cdfplot(mouseTestBrainConservationRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
hold on
cdfplot(mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
hold on
cdfplot(mouseTestBrainPredRanking(1:size(mouseTestBrainPredInMacaque,1)/2))
hold off
cdfplot(mouseTestBrainConservationRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
hold on
cdfplot(mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
hold on
cdfplot(mouseTestBrainPredRanking(size(mouseTestBrainPredInMacaque,1)/2+1:size(mouseTestBrainPred,1)))
hold off

% Brain macaque enhancer orthologs, multi-species model
mouseTestBrainPredMultiInMacaque = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_rheMac8Huge_summitExtendedMin50Max2Protect5_inMacaqueBrain_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
mouseTestBrainPredMultiNonMacaque = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_rheMac8Huge_summitExtendedMin50Max2Protect5_nonMacaqueBrain_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
ranksum(mouseTestBrainPredMultiInMacaque, mouseTestBrainPredMultiNonMacaque)
median(mouseTestBrainPredMultiInMacaque) - median(mouseTestBrainPredMultiNonMacaque)
[~, mouseTestBrainConservationRanking] = sort(mouseTestBrainConservationIndices);
[~, mouseTestBrainConservationPhyloPRanking] = sort(mouseTestBrainConservationPhyloPIndices);
mouseTestBrainPredMulti = ones(size(mouseTestBrainPredMultiInMacaque,1)/2+size(mouseTestBrainPredMultiNonMacaque,1)/2, 1);
index = 0;
while index < size(mouseTestBrainPredMultiInMacaque,1)/2
mouseTestBrainPredMulti(index+1) = (mouseTestBrainPredMultiInMacaque((2*index)+1) + mouseTestBrainPredMultiInMacaque((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestBrainPredMulti,1)
mouseTestBrainPredMulti(index+1) = (mouseTestBrainPredMultiNonMacaque((2*(index-(size(mouseTestBrainPredMultiInMacaque,1)/2)))+1) + mouseTestBrainPredMultiNonMacaque((2*(index-(size(mouseTestBrainPredMultiInMacaque,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestBrainPredMultiIndices] = sort(mouseTestBrainPredMulti, 'descend');
[~, mouseTestBrainPredMultiRanking] = sort(mouseTestBrainPredMultiIndices);
median(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2)) - median(mouseTestBrainConservationRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
2*ranksum(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2), mouseTestBrainConservationRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
median(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1))) - median(mouseTestBrainConservationRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
2*ranksum(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)), mouseTestBrainConservationRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
median(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2)) - median(mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
2*ranksum(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2), mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
median(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1))) - median(mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
2*ranksum(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)), mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
2*signrank(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2), mouseTestBrainConservationRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
2*signrank(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)), mouseTestBrainConservationRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
2*signrank(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2), mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
2*signrank(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)), mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
median(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2)) - median(mouseTestBrainConservationRankingMax(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
median(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1))) - median(mouseTestBrainConservationRankingMax(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
median(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2)) - median(mouseTestBrainConservationPhyloPRankingMax(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
median(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1))) - median(mouseTestBrainConservationPhyloPRankingMax(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
40*signrank(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2), mouseTestBrainConservationRankingMax(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
40*signrank(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)), mouseTestBrainConservationRankingMax(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
40*signrank(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2), mouseTestBrainConservationPhyloPRankingMax(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
40*signrank(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)), mouseTestBrainConservationPhyloPRankingMax(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
mouseTestBrainConservationRanking = size(mouseTestBrainConservation, 1) - mouseTestBrainConservationRanking;
mouseTestBrainConservationPhyloPRanking = size(mouseTestBrainConservationPhyloP, 1) - mouseTestBrainConservationPhyloPRanking;
mouseTestBrainPredMultiRanking = size(mouseTestBrainPredMulti, 1) - mouseTestBrainPredMultiRanking;
cdfplot(mouseTestBrainConservationRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
hold on
cdfplot(mouseTestBrainConservationPhyloPRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
hold on
cdfplot(mouseTestBrainPredMultiRanking(1:size(mouseTestBrainPredMultiInMacaque,1)/2))
hold off
cdfplot(mouseTestBrainConservationRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
hold on
cdfplot(mouseTestBrainConservationPhyloPRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
hold on
cdfplot(mouseTestBrainPredMultiRanking(size(mouseTestBrainPredMultiInMacaque,1)/2+1:size(mouseTestBrainPredMulti,1)))
hold off

% Brain human enhancer orthologs
mouseTestBrainConservationInHuman = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_inHumanBrain.bed');
mouseTestBrainConservationNonHuman = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_nonHumanBrain.bed');
ranksum(mouseTestBrainConservationInHuman.data(:,1), mouseTestBrainConservationNonHuman.data(:,1))
median(mouseTestBrainConservationInHuman.data(:,1)) - median(mouseTestBrainConservationNonHuman.data(:,1))
ranksum(mouseTestBrainConservationInHuman.data(:,3), mouseTestBrainConservationNonHuman.data(:,3))
median(mouseTestBrainConservationInHuman.data(:,3)) - median(mouseTestBrainConservationNonHuman.data(:,3))
mouseTestBrainConservationPhyloPInHuman = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_inHumanBrain.bed');
mouseTestBrainConservationPhyloPNonHuman = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_nonHumanBrain.bed');
ranksum(mouseTestBrainConservationPhyloPInHuman.data(:,1), mouseTestBrainConservationPhyloPNonHuman.data(:,1))
median(mouseTestBrainConservationPhyloPInHuman.data(:,1)) - median(mouseTestBrainConservationPhyloPNonHuman.data(:,1))
ranksum(mouseTestBrainConservationPhyloPInHuman.data(:,3), mouseTestBrainConservationPhyloPNonHuman.data(:,3))
median(mouseTestBrainConservationPhyloPInHuman.data(:,3)) - median(mouseTestBrainConservationPhyloPNonHuman.data(:,3))
mouseTestBrainPredInHuman = importdata('inAgeBAndStriatum_enhancerShort_hg38Huge_summitExtendedMin50Max2Protect5_inHumanBrain_test_predictedProba.txt');
mouseTestBrainPredNonHuman = importdata('inAgeBAndStriatum_enhancerShort_hg38Huge_summitExtendedMin50Max2Protect5_nonHumanBrain_test_predictedProba.txt');
ranksum(mouseTestBrainPredInHuman, mouseTestBrainPredNonHuman)
median(mouseTestBrainPredInHuman) - median(mouseTestBrainPredNonHuman)
mouseTestBrainConservationHuman = cat(1, mouseTestBrainConservationInHuman.data, mouseTestBrainConservationNonHuman.data);
[~, mouseTestBrainConservationHumanIndices] = sort(mouseTestBrainConservationHuman, 'descend');
[~, mouseTestBrainConservationHumanRanking] = sort(mouseTestBrainConservationHumanIndices);
mouseTestBrainConservationHumanPhyloP = cat(1, mouseTestBrainConservationPhyloPInHuman.data, mouseTestBrainConservationPhyloPNonHuman.data);
[~, mouseTestBrainConservationHumanPhyloPIndices] = sort(mouseTestBrainConservationHumanPhyloP, 'descend');
[~, mouseTestBrainConservationHumanPhyloPRanking] = sort(mouseTestBrainConservationHumanPhyloPIndices);
mouseTestBrainPredHuman = ones(size(mouseTestBrainPredInHuman,1)/2+size(mouseTestBrainPredNonHuman,1)/2, 1);
index = 0;
while index < size(mouseTestBrainPredInHuman,1)/2
mouseTestBrainPredHuman(index+1) = (mouseTestBrainPredInHuman((2*index)+1) + mouseTestBrainPredInHuman((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestBrainPredHuman,1)
mouseTestBrainPredHuman(index+1) = (mouseTestBrainPredNonHuman((2*(index-(size(mouseTestBrainPredInHuman,1)/2)))+1) + mouseTestBrainPredNonHuman((2*(index-(size(mouseTestBrainPredInHuman,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestBrainPredHumanIndices] = sort(mouseTestBrainPredHuman, 'descend');
[~, mouseTestBrainPredHumanRanking] = sort(mouseTestBrainPredHumanIndices);
median(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2)) - median(mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2))
2*ranksum(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2), mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2))
median(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1))) - median(mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
2*ranksum(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)), mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
median(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2)) - median(mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredInHuman,1)/2))
2*ranksum(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2), mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredInHuman,1)/2))
median(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1))) - median(mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
2*ranksum(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)), mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
2*signrank(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2), mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2))
2*signrank(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)), mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
2*signrank(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2), mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredInHuman,1)/2))
2*signrank(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)), mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
mouseTestBrainConservationHumanMax = cat(1, mouseTestBrainConservationInHuman.data(:,3), mouseTestBrainConservationNonHuman.data(:,3));
[~, mouseTestBrainConservationHumanIndicesMax] = sort(mouseTestBrainConservationHumanMax, 'descend');
[~, mouseTestBrainConservationHumanRankingMax] = sort(mouseTestBrainConservationHumanIndicesMax);
mouseTestBrainConservationHumanPhyloPMax = cat(1, mouseTestBrainConservationPhyloPInHuman.data(:,3), mouseTestBrainConservationPhyloPNonHuman.data(:,3));
[~, mouseTestBrainConservationHumanPhyloPIndices] = sort(mouseTestBrainConservationHumanPhyloPMax, 'descend');
[~, mouseTestBrainConservationHumanPhyloPRanking] = sort(mouseTestBrainConservationHumanPhyloPIndices);
median(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2)) - median(mouseTestBrainConservationHumanRankingMax(1:size(mouseTestBrainPredInHuman,1)/2))
median(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1))) - median(mouseTestBrainConservationHumanRankingMax(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
median(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2)) - median(mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredInHuman,1)/2))
median(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1))) - median(mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
40*signrank(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2), mouseTestBrainConservationHumanRankingMax(1:size(mouseTestBrainPredInHuman,1)/2))
40*signrank(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)), mouseTestBrainConservationHumanRankingMax(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
40*signrank(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2), mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredInHuman,1)/2))
40*signrank(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)), mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
mouseTestBrainConservationHumanRanking = size(mouseTestBrainConservationHuman, 1) - mouseTestBrainConservationHumanRanking;
mouseTestBrainConservationHumanPhyloPRanking = size(mouseTestBrainConservationHumanPhyloP, 1) - mouseTestBrainConservationHumanPhyloPRanking;
mouseTestBrainPredHumanRanking = size(mouseTestBrainPredHuman, 1) - mouseTestBrainPredHumanRanking;
cdfplot(mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2))
hold on
cdfplot(mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredInHuman,1)/2))
hold on
cdfplot(mouseTestBrainPredHumanRanking(1:size(mouseTestBrainPredInHuman,1)/2))
hold off
cdfplot(mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
hold on
cdfplot(mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
hold on
cdfplot(mouseTestBrainPredHumanRanking(size(mouseTestBrainPredInHuman,1)/2+1:size(mouseTestBrainPredHuman,1)))
hold off

% Brain human enhancer orthologs, multi-species model
mouseTestBrainPredMultiInHuman = importdata('inAgeBAndStriatum_enhancerShort_hg38Huge_summitExtendedMin50Max2Protect5_inHumanBrain_test_multiSpeciesModel_predictedProba.txt');
mouseTestBrainPredMultiNonHuman = importdata('inAgeBAndStriatum_enhancerShort_hg38Huge_summitExtendedMin50Max2Protect5_nonHumanBrain_test_multiSpeciesModel_predictedProba.txt');
ranksum(mouseTestBrainPredMultiInHuman, mouseTestBrainPredMultiNonHuman)
median(mouseTestBrainPredMultiInHuman) - median(mouseTestBrainPredMultiNonHuman)
[~, mouseTestBrainConservationHumanRanking] = sort(mouseTestBrainConservationHumanIndices);
[~, mouseTestBrainConservationHumanPhyloPRanking] = sort(mouseTestBrainConservationHumanPhyloPIndices);
mouseTestBrainPredMultiHuman = ones(size(mouseTestBrainPredMultiInHuman,1)/2+size(mouseTestBrainPredMultiNonHuman,1)/2, 1);
index = 0;
while index < size(mouseTestBrainPredMultiInHuman,1)/2
mouseTestBrainPredMultiHuman(index+1) = (mouseTestBrainPredMultiInHuman((2*index)+1) + mouseTestBrainPredMultiInHuman((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestBrainPredMultiHuman,1)
mouseTestBrainPredMultiHuman(index+1) = (mouseTestBrainPredMultiNonHuman((2*(index-(size(mouseTestBrainPredMultiInHuman,1)/2)))+1) + mouseTestBrainPredMultiNonHuman((2*(index-(size(mouseTestBrainPredMultiInHuman,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestBrainPredMultiHumanIndices] = sort(mouseTestBrainPredMultiHuman, 'descend');
[~, mouseTestBrainPredMultiHumanRanking] = sort(mouseTestBrainPredMultiHumanIndices);
median(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2)) - median(mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
2*ranksum(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2), mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
median(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1))) - median(mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
2*ranksum(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)), mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
median(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2)) - median(mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
2*ranksum(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2), mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
median(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1))) - median(mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
2*ranksum(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)), mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
2*signrank(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2), mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
2*signrank(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)), mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
2*signrank(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2), mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
2*signrank(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)), mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
median(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2)) - median(mouseTestBrainConservationHumanRankingMax(1:size(mouseTestBrainPredMultiInHuman,1)/2))
median(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1))) - median(mouseTestBrainConservationHumanRankingMax(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
median(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2)) - median(mouseTestBrainConservationHumanPhyloPRankingMax(1:size(mouseTestBrainPredMultiInHuman,1)/2))
median(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1))) - median(mouseTestBrainConservationHumanPhyloPRankingMax(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
40*signrank(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2), mouseTestBrainConservationHumanRankingMax(1:size(mouseTestBrainPredMultiInHuman,1)/2))
40*signrank(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)), mouseTestBrainConservationHumanRankingMax(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
40*signrank(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2), mouseTestBrainConservationHumanPhyloPRankingMax(1:size(mouseTestBrainPredMultiInHuman,1)/2))
40*signrank(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)), mouseTestBrainConservationHumanPhyloPRankingMax(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
mouseTestBrainConservationHumanRanking = size(mouseTestBrainConservationHuman, 1) - mouseTestBrainConservationHumanRanking;
mouseTestBrainConservationHumanPhyloPRanking = size(mouseTestBrainConservationHumanPhyloP, 1) - mouseTestBrainConservationHumanPhyloPRanking;
mouseTestBrainPredMultiHumanRanking = size(mouseTestBrainPredMultiHuman, 1) - mouseTestBrainPredMultiHumanRanking;
cdfplot(mouseTestBrainConservationHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
hold on
cdfplot(mouseTestBrainConservationHumanPhyloPRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
hold on
cdfplot(mouseTestBrainPredMultiHumanRanking(1:size(mouseTestBrainPredMultiInHuman,1)/2))
hold off
cdfplot(mouseTestBrainConservationHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
hold on
cdfplot(mouseTestBrainConservationHumanPhyloPRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
hold on
cdfplot(mouseTestBrainPredMultiHumanRanking(size(mouseTestBrainPredMultiInHuman,1)/2+1:size(mouseTestBrainPredMultiHuman,1)))
hold off

% Brain rat enhancer orthologs
mouseTestBrainConservationInRat = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_inRatBrain.bed');
mouseTestBrainConservationNonRat = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_nonRatBrain.bed');
ranksum(mouseTestBrainConservationInRat.data(:,1), mouseTestBrainConservationNonRat.data(:,1))
median(mouseTestBrainConservationInRat.data(:,1)) - median(mouseTestBrainConservationNonRat.data(:,1))
ranksum(mouseTestBrainConservationInRat.data(:,3), mouseTestBrainConservationNonRat.data(:,3))
median(mouseTestBrainConservationInRat.data(:,3)) - median(mouseTestBrainConservationNonRat.data(:,3))
mouseTestBrainConservationPhyloPInRat = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_inRatBrain.bed');
mouseTestBrainConservationPhyloPNonRat = importdata('inAgeBAndStriatum_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_nonRatBrain.bed');
ranksum(mouseTestBrainConservationPhyloPInRat.data(:,1), mouseTestBrainConservationPhyloPNonRat.data(:,1))
median(mouseTestBrainConservationPhyloPInRat.data(:,1)) - median(mouseTestBrainConservationPhyloPNonRat.data(:,1))
ranksum(mouseTestBrainConservationPhyloPInRat.data(:,3), mouseTestBrainConservationPhyloPNonRat.data(:,3))
median(mouseTestBrainConservationPhyloPInRat.data(:,3)) - median(mouseTestBrainConservationPhyloPNonRat.data(:,3))
mouseTestBrainPredInRat = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_withPeakNames_rn6Huge_summitExtendedMin50Max2Protect5_inRatBrain_test_conv5MuchMuchMoreFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
mouseTestBrainPredNonRat = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_withPeakNames_rn6Huge_summitExtendedMin50Max2Protect5_nonRatBrain_test_conv5MuchMuchMoreFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
ranksum(mouseTestBrainPredInRat, mouseTestBrainPredNonRat)
median(mouseTestBrainPredInRat) - median(mouseTestBrainPredNonRat)
mouseTestBrainConservationRat = cat(1, mouseTestBrainConservationInRat.data, mouseTestBrainConservationNonRat.data);
[~, mouseTestBrainConservationRatIndices] = sort(mouseTestBrainConservationRat, 'descend');
[~, mouseTestBrainConservationRatRanking] = sort(mouseTestBrainConservationRatIndices);
mouseTestBrainConservationRatPhyloP = cat(1, mouseTestBrainConservationPhyloPInRat.data, mouseTestBrainConservationPhyloPNonRat.data);
[~, mouseTestBrainConservationRatPhyloPIndices] = sort(mouseTestBrainConservationRatPhyloP, 'descend');
[~, mouseTestBrainConservationRatPhyloPRanking] = sort(mouseTestBrainConservationRatPhyloPIndices);
mouseTestBrainPredRat = ones(size(mouseTestBrainPredInRat,1)/2+size(mouseTestBrainPredNonRat,1)/2, 1);
index = 0;
while index < size(mouseTestBrainPredInRat,1)/2
mouseTestBrainPredRat(index+1) = (mouseTestBrainPredInRat((2*index)+1) + mouseTestBrainPredInRat((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestBrainPredRat,1)
mouseTestBrainPredRat(index+1) = (mouseTestBrainPredNonRat((2*(index-(size(mouseTestBrainPredInRat,1)/2)))+1) + mouseTestBrainPredNonRat((2*(index-(size(mouseTestBrainPredInRat,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestBrainPredRatIndices] = sort(mouseTestBrainPredRat, 'descend');
[~, mouseTestBrainPredRatRanking] = sort(mouseTestBrainPredRatIndices);
median(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2)) - median(mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredInRat,1)/2))
2*ranksum(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2), mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredInRat,1)/2))
median(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1))) - median(mouseTestBrainConservationRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
2*ranksum(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)), mouseTestBrainConservationRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
median(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2)) - median(mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredInRat,1)/2))
2*ranksum(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2), mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredInRat,1)/2))
median(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1))) - median(mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
2*ranksum(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)), mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
2*signrank(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2), mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredInRat,1)/2))
2*signrank(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)), mouseTestBrainConservationRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
2*signrank(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2), mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredInRat,1)/2))
2*signrank(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)), mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
mouseTestBrainConservationRatMax = cat(1, mouseTestBrainConservationInRat.data(:,3), mouseTestBrainConservationNonRat.data(:,3));
[~, mouseTestBrainConservationRatIndicesMax] = sort(mouseTestBrainConservationRatMax, 'descend');
[~, mouseTestBrainConservationRatRankingMax] = sort(mouseTestBrainConservationRatIndicesMax);
mouseTestBrainConservationRatPhyloPMax = cat(1, mouseTestBrainConservationPhyloPInRat.data(:,3), mouseTestBrainConservationPhyloPNonRat.data(:,3));
[~, mouseTestBrainConservationRatPhyloPIndicesMax] = sort(mouseTestBrainConservationRatPhyloPMax, 'descend');
[~, mouseTestBrainConservationRatPhyloPRankingMax] = sort(mouseTestBrainConservationRatPhyloPIndicesMax);
median(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2)) - median(mouseTestBrainConservationRatRankingMax(1:size(mouseTestBrainPredInRat,1)/2))
median(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1))) - median(mouseTestBrainConservationRatRankingMax(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
median(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2)) - median(mouseTestBrainConservationRatPhyloPRankingMax(1:size(mouseTestBrainPredInRat,1)/2))
median(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1))) - median(mouseTestBrainConservationRatPhyloPRankingMax(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
40*signrank(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2), mouseTestBrainConservationRatRankingMax(1:size(mouseTestBrainPredInRat,1)/2))
40*signrank(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)), mouseTestBrainConservationRatRankingMax(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
40*signrank(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2), mouseTestBrainConservationRatPhyloPRankingMax(1:size(mouseTestBrainPredInRat,1)/2))
40*signrank(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)), mouseTestBrainConservationRatPhyloPRankingMax(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
mouseTestBrainConservationRatRanking = size(mouseTestBrainConservationRat, 1) - mouseTestBrainConservationRatRanking;
mouseTestBrainConservationRatPhyloPRanking = size(mouseTestBrainConservationRatPhyloP, 1) - mouseTestBrainConservationRatPhyloPRanking;
mouseTestBrainPredRatRanking = size(mouseTestBrainPredRat, 1) - mouseTestBrainPredRatRanking;
cdfplot(mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredInRat,1)/2))
hold on
cdfplot(mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredInRat,1)/2))
hold on
cdfplot(mouseTestBrainPredRatRanking(1:size(mouseTestBrainPredInRat,1)/2))
hold off
cdfplot(mouseTestBrainConservationRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
hold on
cdfplot(mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
hold on
cdfplot(mouseTestBrainPredRatRanking(size(mouseTestBrainPredInRat,1)/2+1:size(mouseTestBrainPredRat,1)))
hold off

% Brain rat enhancer orthologs, multi-species model
mouseTestBrainPredMultiInRat = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_withPeakNames_rn6Huge_summitExtendedMin50Max2Protect5_inRatBrain_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
mouseTestBrainPredMultiNonRat = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_withPeakNames_rn6Huge_summitExtendedMin50Max2Protect5_nonRatBrain_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
ranksum(mouseTestBrainPredMultiInRat, mouseTestBrainPredMultiNonRat)
median(mouseTestBrainPredMultiInRat) - median(mouseTestBrainPredMultiNonRat)
[~, mouseTestBrainConservationRatRanking] = sort(mouseTestBrainConservationRatIndices);
[~, mouseTestBrainConservationRatPhyloPRanking] = sort(mouseTestBrainConservationRatPhyloPIndices);
mouseTestBrainPredMultiRat = ones(size(mouseTestBrainPredMultiInRat,1)/2+size(mouseTestBrainPredMultiNonRat,1)/2, 1);
index = 0;
while index < size(mouseTestBrainPredMultiInRat,1)/2
mouseTestBrainPredMultiRat(index+1) = (mouseTestBrainPredMultiInRat((2*index)+1) + mouseTestBrainPredMultiInRat((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestBrainPredMultiRat,1)
mouseTestBrainPredMultiRat(index+1) = (mouseTestBrainPredMultiNonRat((2*(index-(size(mouseTestBrainPredMultiInRat,1)/2)))+1) + mouseTestBrainPredMultiNonRat((2*(index-(size(mouseTestBrainPredMultiInRat,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestBrainPredMultiRatIndices] = sort(mouseTestBrainPredMultiRat, 'descend');
[~, mouseTestBrainPredMultiRatRanking] = sort(mouseTestBrainPredMultiRatIndices);
median(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2)) - median(mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
2*ranksum(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2), mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
median(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1))) - median(mouseTestBrainConservationRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
2*ranksum(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)), mouseTestBrainConservationRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
median(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2)) - median(mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
2*ranksum(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2), mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
median(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1))) - median(mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
2*ranksum(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)), mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
2*signrank(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2), mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
2*signrank(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)), mouseTestBrainConservationRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
2*signrank(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2), mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
2*signrank(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)), mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
median(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2)) - median(mouseTestBrainConservationRatRankingMax(1:size(mouseTestBrainPredMultiInRat,1)/2))
median(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1))) - median(mouseTestBrainConservationRatRankingMax(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
median(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2)) - median(mouseTestBrainConservationRatPhyloPRankingMax(1:size(mouseTestBrainPredMultiInRat,1)/2))
median(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1))) - median(mouseTestBrainConservationRatPhyloPRankingMax(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
40*signrank(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2), mouseTestBrainConservationRatRankingMax(1:size(mouseTestBrainPredMultiInRat,1)/2))
40*signrank(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)), mouseTestBrainConservationRatRankingMax(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
40*signrank(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2), mouseTestBrainConservationRatPhyloPRankingMax(1:size(mouseTestBrainPredMultiInRat,1)/2))
40*signrank(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)), mouseTestBrainConservationRatPhyloPRankingMax(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
mouseTestBrainConservationRatRanking = size(mouseTestBrainConservationRat, 1) - mouseTestBrainConservationRatRanking;
mouseTestBrainConservationRatPhyloPRanking = size(mouseTestBrainConservationRatPhyloP, 1) - mouseTestBrainConservationRatPhyloPRanking;
mouseTestBrainPredMultiRatRanking = size(mouseTestBrainPredMultiRat, 1) - mouseTestBrainPredMultiRatRanking;
cdfplot(mouseTestBrainConservationRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
hold on
cdfplot(mouseTestBrainConservationRatPhyloPRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
hold on
cdfplot(mouseTestBrainPredMultiRatRanking(1:size(mouseTestBrainPredMultiInRat,1)/2))
hold off
cdfplot(mouseTestBrainConservationRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
hold on
cdfplot(mouseTestBrainConservationRatPhyloPRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
hold on
cdfplot(mouseTestBrainPredMultiRatRanking(size(mouseTestBrainPredMultiInRat,1)/2+1:size(mouseTestBrainPredMultiRat,1)))
hold off

% Liver macaque enhancer orthologs
mouseTestLiverConservationInMacaque = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_inMacaqueLiver.bed');
mouseTestLiverConservationNonMacaque = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_nonMacaqueLiver.bed');
ranksum(mouseTestLiverConservationInMacaque.data(:,1), mouseTestLiverConservationNonMacaque.data(:,1))
median(mouseTestLiverConservationInMacaque.data(:,1)) - median(mouseTestLiverConservationNonMacaque.data(:,1))
ranksum(mouseTestLiverConservationInMacaque.data(:,3), mouseTestLiverConservationNonMacaque.data(:,3))
median(mouseTestLiverConservationInMacaque.data(:,3)) - median(mouseTestLiverConservationNonMacaque.data(:,3))
mean(mouseTestLiverConservationInMacaque.data(:,3)) - mean(mouseTestLiverConservationNonMacaque.data(:,3))
mouseTestLiverConservationPhyloPInMacaque = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_inMacaqueLiver.bed');
mouseTestLiverConservationPhyloPNonMacaque = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_nonMacaqueLiver.bed');
ranksum(mouseTestLiverConservationPhyloPInMacaque.data(:,1), mouseTestLiverConservationPhyloPNonMacaque.data(:,1))
median(mouseTestLiverConservationPhyloPInMacaque.data(:,1)) - median(mouseTestLiverConservationPhyloPNonMacaque.data(:,1))
ranksum(mouseTestLiverConservationPhyloPInMacaque.data(:,3), mouseTestLiverConservationPhyloPNonMacaque.data(:,3))
median(mouseTestLiverConservationPhyloPInMacaque.data(:,3)) - median(mouseTestLiverConservationPhyloPNonMacaque.data(:,3))
mouseTestLiverPredInMacaque = importdata('inLiuAll_nonCDS_enhancerShort_rheMac8_summitExtendedMin50Max2XProtect5_inMacaqueLiver_test_predictedProba.txt');
mouseTestLiverPredNonMacaque = importdata('inLiuAll_nonCDS_enhancerShort_rheMac8_summitExtendedMin50Max2XProtect5_nonMacaqueLiver_test_predictedProba.txt');
ranksum(mouseTestLiverPredInMacaque, mouseTestLiverPredNonMacaque)
median(mouseTestLiverPredInMacaque) - median(mouseTestLiverPredNonMacaque)
mouseTestLiverConservation = cat(1, mouseTestLiverConservationInMacaque.data, mouseTestLiverConservationNonMacaque.data);
[~, mouseTestLiverConservationIndices] = sort(mouseTestLiverConservation, 'descend');
[~, mouseTestLiverConservationRanking] = sort(mouseTestLiverConservationIndices);
mouseTestLiverConservationPhyloP = cat(1, mouseTestLiverConservationPhyloPInMacaque.data, mouseTestLiverConservationPhyloPNonMacaque.data);
[~, mouseTestLiverConservationPhyloPIndices] = sort(mouseTestLiverConservationPhyloP, 'descend');
[~, mouseTestLiverConservationPhyloPRanking] = sort(mouseTestLiverConservationPhyloPIndices);
mouseTestLiverPred = ones(size(mouseTestLiverPredInMacaque,1)/2+size(mouseTestLiverPredNonMacaque,1)/2, 1);
index = 0;
while index < size(mouseTestLiverPredInMacaque,1)/2
mouseTestLiverPred(index+1) = (mouseTestLiverPredInMacaque((2*index)+1) + mouseTestLiverPredInMacaque((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestLiverPred,1)
mouseTestLiverPred(index+1) = (mouseTestLiverPredNonMacaque((2*(index-(size(mouseTestLiverPredInMacaque,1)/2)))+1) + mouseTestLiverPredNonMacaque((2*(index-(size(mouseTestLiverPredInMacaque,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestLiverPredIndices] = sort(mouseTestLiverPred, 'descend');
[~, mouseTestLiverPredRanking] = sort(mouseTestLiverPredIndices);
median(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2)) - median(mouseTestLiverConservationRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
2*ranksum(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2), mouseTestLiverConservationRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
median(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1))) - median(mouseTestLiverConservationRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
2*ranksum(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)), mouseTestLiverConservationRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
median(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2)) - median(mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
2*ranksum(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2), mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
median(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1))) - median(mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
2*ranksum(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)), mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
2*signrank(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2), mouseTestLiverConservationRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
2*signrank(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)), mouseTestLiverConservationRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
2*signrank(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2), mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
2*signrank(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)), mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
mouseTestLiverConservationMax = cat(1, mouseTestLiverConservationInMacaque.data(:,3), mouseTestLiverConservationNonMacaque.data(:,3));
[~, mouseTestLiverConservationIndicesMax] = sort(mouseTestLiverConservationMax, 'descend');
[~, mouseTestLiverConservationRankingMax] = sort(mouseTestLiverConservationIndicesMax);
mouseTestLiverConservationPhyloPMax = cat(1, mouseTestLiverConservationPhyloPInMacaque.data(:,3), mouseTestLiverConservationPhyloPNonMacaque.data(:,3));
[~, mouseTestLiverConservationPhyloPIndicesMax] = sort(mouseTestLiverConservationPhyloPMax, 'descend');
[~, mouseTestLiverConservationPhyloPRankingMax] = sort(mouseTestLiverConservationPhyloPIndicesMax);
median(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2)) - median(mouseTestLiverConservationRankingMax(1:size(mouseTestLiverPredInMacaque,1)/2))
median(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1))) - median(mouseTestLiverConservationRankingMax(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
median(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2)) - median(mouseTestLiverConservationPhyloPRankingMax(1:size(mouseTestLiverPredInMacaque,1)/2))
median(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1))) - median(mouseTestLiverConservationPhyloPRankingMax(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
2*signrank(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2), mouseTestLiverConservationRankingMax(1:size(mouseTestLiverPredInMacaque,1)/2))
2*signrank(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)), mouseTestLiverConservationRankingMax(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
2*signrank(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2), mouseTestLiverConservationPhyloPRankingMax(1:size(mouseTestLiverPredInMacaque,1)/2))
2*signrank(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)), mouseTestLiverConservationPhyloPRankingMax(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
mouseTestLiverConservationRanking = size(mouseTestLiverConservation, 1) - mouseTestLiverConservationRanking;
mouseTestLiverConservationPhyloPRanking = size(mouseTestLiverConservationPhyloP, 1) - mouseTestLiverConservationPhyloPRanking;
mouseTestLiverPredRanking = size(mouseTestLiverPred, 1) - mouseTestLiverPredRanking;
cdfplot(mouseTestLiverConservationRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
hold on
cdfplot(mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
hold on
cdfplot(mouseTestLiverPredRanking(1:size(mouseTestLiverPredInMacaque,1)/2))
hold off
cdfplot(mouseTestLiverConservationRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
hold on
cdfplot(mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
hold on
cdfplot(mouseTestLiverPredRanking(size(mouseTestLiverPredInMacaque,1)/2+1:size(mouseTestLiverPred,1)))
hold off

% Liver macaque enhancer orthologs, multi-species model
mouseTestLiverPredMultiInMacaque = importdata('idr.optimal_peak.narrowPeak_inLiuAll_nonCDS_enhancerShort_rheMac8_summitExtendedMin50Max2XProtect5_UCSCNames_inMacaqueLiver_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
mouseTestLiverPredMultiNonMacaque = importdata('idr.optimal_peak.narrowPeak_inLiuAll_nonCDS_enhancerShort_rheMac8_summitExtendedMin50Max2XProtect5_UCSCNames_nonMacaqueLiver_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
ranksum(mouseTestLiverPredMultiInMacaque, mouseTestLiverPredMultiNonMacaque)
median(mouseTestLiverPredMultiInMacaque) - median(mouseTestLiverPredMultiNonMacaque)
[~, mouseTestLiverConservationRanking] = sort(mouseTestLiverConservationIndices);
[~, mouseTestLiverConservationPhyloPRanking] = sort(mouseTestLiverConservationPhyloPIndices);
mouseTestLiverPredMulti = ones(size(mouseTestLiverPredMultiInMacaque,1)/2+size(mouseTestLiverPredMultiNonMacaque,1)/2, 1);
index = 0;
while index < size(mouseTestLiverPredMultiInMacaque,1)/2
mouseTestLiverPredMulti(index+1) = (mouseTestLiverPredMultiInMacaque((2*index)+1) + mouseTestLiverPredMultiInMacaque((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestLiverPredMulti,1)
mouseTestLiverPredMulti(index+1) = (mouseTestLiverPredMultiNonMacaque((2*(index-(size(mouseTestLiverPredMultiInMacaque,1)/2)))+1) + mouseTestLiverPredMultiNonMacaque((2*(index-(size(mouseTestLiverPredMultiInMacaque,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestLiverPredMultiIndices] = sort(mouseTestLiverPredMulti, 'descend');
[~, mouseTestLiverPredMultiRanking] = sort(mouseTestLiverPredMultiIndices);
median(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2)) - median(mouseTestLiverConservationRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
2*ranksum(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2), mouseTestLiverConservationRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
median(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1))) - median(mouseTestLiverConservationRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
2*ranksum(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)), mouseTestLiverConservationRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
median(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2)) - median(mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
2*ranksum(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2), mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
median(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1))) - median(mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
2*ranksum(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)), mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
2*signrank(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2), mouseTestLiverConservationRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
2*signrank(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)), mouseTestLiverConservationRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
2*signrank(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2), mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
2*signrank(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)), mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
median(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2)) - median(mouseTestLiverConservationRankingMax(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
median(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1))) - median(mouseTestLiverConservationRankingMax(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
median(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2)) - median(mouseTestLiverConservationPhyloPRankingMax(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
median(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1))) - median(mouseTestLiverConservationPhyloPRankingMax(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
2*signrank(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2), mouseTestLiverConservationRankingMax(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
2*signrank(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)), mouseTestLiverConservationRankingMax(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
2*signrank(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2), mouseTestLiverConservationPhyloPRankingMax(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
2*signrank(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)), mouseTestLiverConservationPhyloPRankingMax(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
mouseTestLiverConservationRanking = size(mouseTestLiverConservation, 1) - mouseTestLiverConservationRanking;
mouseTestLiverConservationPhyloPRanking = size(mouseTestLiverConservationPhyloP, 1) - mouseTestLiverConservationPhyloPRanking;
mouseTestLiverPredMultiRanking = size(mouseTestLiverPredMulti, 1) - mouseTestLiverPredMultiRanking;
cdfplot(mouseTestLiverConservationRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
hold on
cdfplot(mouseTestLiverConservationPhyloPRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
hold on
cdfplot(mouseTestLiverPredMultiRanking(1:size(mouseTestLiverPredMultiInMacaque,1)/2))
hold off
cdfplot(mouseTestLiverConservationRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
hold on
cdfplot(mouseTestLiverConservationPhyloPRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
hold on
cdfplot(mouseTestLiverPredMultiRanking(size(mouseTestLiverPredMultiInMacaque,1)/2+1:size(mouseTestLiverPredMulti,1)))
hold off

% Liver rat enhancer orthologs
mouseTestLiverConservationInRat = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_inRatLiver.bed');
mouseTestLiverConservationNonRat = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhastConsPlacental_test_nonRatLiver.bed');
ranksum(mouseTestLiverConservationInRat.data(:,1), mouseTestLiverConservationNonRat.data(:,1))
median(mouseTestLiverConservationInRat.data(:,1)) - median(mouseTestLiverConservationNonRat.data(:,1))
ranksum(mouseTestLiverConservationInRat.data(:,3), mouseTestLiverConservationNonRat.data(:,3))
median(mouseTestLiverConservationInRat.data(:,3)) - median(mouseTestLiverConservationNonRat.data(:,3))
mouseTestLiverConservationPhyloPInRat = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_inRatLiver.bed');
mouseTestLiverConservationPhyloPNonRat = importdata('inLiuAll_nonCDS_enhancerShort_summitPlusMinus250bp_conservationPhyloPPlacental_test_nonRatLiver.bed');
ranksum(mouseTestLiverConservationPhyloPInRat.data(:,1), mouseTestLiverConservationPhyloPNonRat.data(:,1))
median(mouseTestLiverConservationPhyloPInRat.data(:,1)) - median(mouseTestLiverConservationPhyloPNonRat.data(:,1))
ranksum(mouseTestLiverConservationPhyloPInRat.data(:,3), mouseTestLiverConservationPhyloPNonRat.data(:,3))
median(mouseTestLiverConservationPhyloPInRat.data(:,3)) - median(mouseTestLiverConservationPhyloPNonRat.data(:,3))
mouseTestLiverPredInRat = importdata('enhancerShort_rn6_summitExtendedMin50Max2XProtect5_inRatLiver_test_predictedProba.txt');
mouseTestLiverPredNonRat = importdata('enhancerShort_rn6_summitExtendedMin50Max2XProtect5_nonRatLiver_test_predictedProba.txt');
ranksum(mouseTestLiverPredInRat, mouseTestLiverPredNonRat)
median(mouseTestLiverPredInRat) - median(mouseTestLiverPredNonRat)
mouseTestLiverConservationRat = cat(1, mouseTestLiverConservationInRat.data, mouseTestLiverConservationNonRat.data);
[~, mouseTestLiverConservationRatIndices] = sort(mouseTestLiverConservationRat, 'descend');
[~, mouseTestLiverConservationRatRanking] = sort(mouseTestLiverConservationRatIndices);
mouseTestLiverConservationRatPhyloP = cat(1, mouseTestLiverConservationPhyloPInRat.data, mouseTestLiverConservationPhyloPNonRat.data);
[~, mouseTestLiverConservationRatPhyloPIndices] = sort(mouseTestLiverConservationRatPhyloP, 'descend');
[~, mouseTestLiverConservationRatPhyloPRanking] = sort(mouseTestLiverConservationRatPhyloPIndices);
mouseTestLiverPredRat = ones(size(mouseTestLiverPredInRat,1)/2+size(mouseTestLiverPredNonRat,1)/2, 1);
index = 0;
while index < size(mouseTestLiverPredInRat,1)/2
mouseTestLiverPredRat(index+1) = (mouseTestLiverPredInRat((2*index)+1) + mouseTestLiverPredInRat((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestLiverPredRat,1)
mouseTestLiverPredRat(index+1) = (mouseTestLiverPredNonRat((2*(index-(size(mouseTestLiverPredInRat,1)/2)))+1) + mouseTestLiverPredNonRat((2*(index-(size(mouseTestLiverPredInRat,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestLiverPredRatIndices] = sort(mouseTestLiverPredRat, 'descend');
[~, mouseTestLiverPredRatRanking] = sort(mouseTestLiverPredRatIndices);
median(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2)) - median(mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredInRat,1)/2))
2*ranksum(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2), mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredInRat,1)/2))
median(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1))) - median(mouseTestLiverConservationRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
2*ranksum(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)), mouseTestLiverConservationRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
median(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2)) - median(mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredInRat,1)/2))
2*ranksum(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2), mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredInRat,1)/2))
median(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1))) - median(mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
2*ranksum(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)), mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
2*signrank(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2), mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredInRat,1)/2))
2*signrank(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)), mouseTestLiverConservationRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
2*signrank(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2), mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredInRat,1)/2))
2*signrank(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)), mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
mouseTestLiverConservationRatMax = cat(1, mouseTestLiverConservationInRat.data, mouseTestLiverConservationNonRat.data);
[~, mouseTestLiverConservationRatIndicesMax] = sort(mouseTestLiverConservationRatMax, 'descend');
[~, mouseTestLiverConservationRatRankingMax] = sort(mouseTestLiverConservationRatIndicesMax);
mouseTestLiverConservationRatPhyloPMax = cat(1, mouseTestLiverConservationPhyloPInRat.data, mouseTestLiverConservationPhyloPNonRat.data);
[~, mouseTestLiverConservationRatPhyloPIndicesMax] = sort(mouseTestLiverConservationRatPhyloPMax, 'descend');
[~, mouseTestLiverConservationRatPhyloPRankingMax] = sort(mouseTestLiverConservationRatPhyloPIndicesMax);
median(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2)) - median(mouseTestLiverConservationRatRankingMax(1:size(mouseTestLiverPredInRat,1)/2))
median(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1))) - median(mouseTestLiverConservationRatRankingMax(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
median(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2)) - median(mouseTestLiverConservationRatPhyloPRankingMax(1:size(mouseTestLiverPredInRat,1)/2))
median(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1))) - median(mouseTestLiverConservationRatPhyloPRankingMax(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
40*signrank(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2), mouseTestLiverConservationRatRankingMax(1:size(mouseTestLiverPredInRat,1)/2))
40*signrank(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)), mouseTestLiverConservationRatRankingMax(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
40*signrank(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2), mouseTestLiverConservationRatPhyloPRankingMax(1:size(mouseTestLiverPredInRat,1)/2))
40*signrank(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)), mouseTestLiverConservationRatPhyloPRankingMax(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
mouseTestLiverConservationRatRanking = size(mouseTestLiverConservationRat, 1) - mouseTestLiverConservationRatRanking;
mouseTestLiverConservationRatPhyloPRanking = size(mouseTestLiverConservationRatPhyloP, 1) - mouseTestLiverConservationRatPhyloPRanking;
mouseTestLiverPredRatRanking = size(mouseTestLiverPredRat, 1) - mouseTestLiverPredRatRanking;
cdfplot(mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredInRat,1)/2))
hold on
cdfplot(mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredInRat,1)/2))
hold on
cdfplot(mouseTestLiverPredRatRanking(1:size(mouseTestLiverPredInRat,1)/2))
hold off
cdfplot(mouseTestLiverConservationRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
hold on
cdfplot(mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
hold on
cdfplot(mouseTestLiverPredRatRanking(size(mouseTestLiverPredInRat,1)/2+1:size(mouseTestLiverPredRat,1)))
hold off

% Liver rat enhancer orthologs, multi-species model
mouseTestLiverPredMultiInRat = importdata('idr.optimal_peak.narrowPeak_inLiuAll_nonCDS_enhancerShort_rn6_summitExtendedMin50Max2XProtect5_inRatLiver_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
mouseTestLiverPredMultiNonRat = importdata('idr.optimal_peak.narrowPeak_inLiuAll_nonCDS_enhancerShort_rn6_summitExtendedMin50Max2XProtect5_nonRatLiver_test_multiSpeciesModel_conv5MostFiltNoInterPoolVeryHighMomHighLRL2SmallBatchPretrainBal_predictedProba.txt');
ranksum(mouseTestLiverPredMultiInRat, mouseTestLiverPredMultiNonRat)
median(mouseTestLiverPredMultiInRat) - median(mouseTestLiverPredMultiNonRat)
[~, mouseTestLiverConservationRatRanking] = sort(mouseTestLiverConservationRatIndices);
[~, mouseTestLiverConservationRatPhyloPRanking] = sort(mouseTestLiverConservationRatPhyloPIndices);
mouseTestLiverPredMultiRat = ones(size(mouseTestLiverPredMultiInRat,1)/2+size(mouseTestLiverPredMultiNonRat,1)/2, 1);
index = 0;
while index < size(mouseTestLiverPredMultiInRat,1)/2
mouseTestLiverPredMultiRat(index+1) = (mouseTestLiverPredMultiInRat((2*index)+1) + mouseTestLiverPredMultiInRat((2*index)+2))/2;
index = index + 1;
end
while index < size(mouseTestLiverPredMultiRat,1)
mouseTestLiverPredMultiRat(index+1) = (mouseTestLiverPredMultiNonRat((2*(index-(size(mouseTestLiverPredMultiInRat,1)/2)))+1) + mouseTestLiverPredMultiNonRat((2*(index-(size(mouseTestLiverPredMultiInRat,1)/2))+2)))/2;
index = index + 1;
end
[~, mouseTestLiverPredMultiRatIndices] = sort(mouseTestLiverPredMultiRat, 'descend');
[~, mouseTestLiverPredMultiRatRanking] = sort(mouseTestLiverPredMultiRatIndices);
median(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2)) - median(mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
2*ranksum(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2), mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
median(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1))) - median(mouseTestLiverConservationRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
2*ranksum(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)), mouseTestLiverConservationRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
median(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2)) - median(mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
2*ranksum(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2), mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
median(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1))) - median(mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
2*ranksum(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)), mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
2*signrank(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2), mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
2*signrank(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)), mouseTestLiverConservationRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
2*signrank(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2), mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
2*signrank(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)), mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
median(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2)) - median(mouseTestLiverConservationRatRankingMax(1:size(mouseTestLiverPredMultiInRat,1)/2))
median(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1))) - median(mouseTestLiverConservationRatRankingMax(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
median(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2)) - median(mouseTestLiverConservationRatPhyloPRankingMax(1:size(mouseTestLiverPredMultiInRat,1)/2))
median(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1))) - median(mouseTestLiverConservationRatPhyloPRankingMax(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
40*signrank(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2), mouseTestLiverConservationRatRankingMax(1:size(mouseTestLiverPredMultiInRat,1)/2))
40*signrank(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)), mouseTestLiverConservationRatRankingMax(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
40*signrank(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2), mouseTestLiverConservationRatPhyloPRankingMax(1:size(mouseTestLiverPredMultiInRat,1)/2))
40*signrank(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)), mouseTestLiverConservationRatPhyloPRankingMax(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
mouseTestLiverConservationRatRanking = size(mouseTestLiverConservationRat, 1) - mouseTestLiverConservationRatRanking;
mouseTestLiverConservationRatPhyloPRanking = size(mouseTestLiverConservationRatPhyloP, 1) - mouseTestLiverConservationRatPhyloPRanking;
mouseTestLiverPredMultiRatRanking = size(mouseTestLiverPredMultiRat, 1) - mouseTestLiverPredMultiRatRanking;
cdfplot(mouseTestLiverConservationRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
hold on
cdfplot(mouseTestLiverConservationRatPhyloPRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
hold on
cdfplot(mouseTestLiverPredMultiRatRanking(1:size(mouseTestLiverPredMultiInRat,1)/2))
hold off
cdfplot(mouseTestLiverConservationRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
hold on
cdfplot(mouseTestLiverConservationRatPhyloPRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
hold on
cdfplot(mouseTestLiverPredMultiRatRanking(size(mouseTestLiverPredMultiInRat,1)/2+1:size(mouseTestLiverPredMultiRat,1)))
hold off