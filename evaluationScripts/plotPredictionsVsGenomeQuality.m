% Get the distances of glires from Mus musculus
distanceFromMouseGlires = [28.6
55
71
73
70
73
73
73
73
33
33
73
73
73
73
73
70
70
73
33
33
73
71
71
73
73
73
71
55
82
71
28.6
33
33
7.04
0
8.3
3.07
71
73
45
82
73
33
33
82
70
33
73
20.9
33
71
73
71
55
];

% Get the scaffold N50's of glires
scaffoldNFiftyGlires = [65411
36308
37811
4081
55723
27928671
27942054
91436
21893125
110049
62039716
354548
49073
3892
43703
77918
11931245
36811
31026
242123
15246
5314287
30338
28463
20532749
202224
64768
8192786
22080993
16725
31340621
100883
12753307
17270019
122627250
54517951
111406228
131945496
59013
35982
3618479
26863993
12091372
89093
20878
35972871
24714
3760915
35766
14986627
101373
1761345
21523
83865
26350];

% Plot evolutionary distance vs. predictions for non-enhancer orthologs of
% enhancers negative set for brain multi-species model
mousePeakPredictionsMultiTestGlires = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_multiSpeciesModel_peakPredictionsGlires.txt');
mousePeakPredictionsMultiTestGlires.data(:,50) = [];
mousePeakPredictionsMultiTestGlires.data(find(mousePeakPredictionsMultiTestGlires.data == -1)) = NaN;
meanMousePeakPredictionsMultiTestGlires = nanmean(mousePeakPredictionsMultiTestGlires.data)';
mousePeakPredictionsMultiIndicatorTestGlires = zeros(size(mousePeakPredictionsMultiTestGlires.data, 1), 1);
for i=1:size(mousePeakPredictionsMultiTestGlires.data, 1)
if length(find(isnan(mousePeakPredictionsMultiTestGlires.data(i, :)))) < 14
mousePeakPredictionsMultiIndicatorTestGlires(i) = 1;
end
end
sum(mousePeakPredictionsMultiIndicatorTestGlires)
mousePeakPredictionsMultiFiltTestGlires = mousePeakPredictionsMultiTestGlires.data(find(mousePeakPredictionsMultiIndicatorTestGlires==1), :);
meanMousePeakPredictionsMultiFiltTestGlires = nanmean(mousePeakPredictionsMultiFiltTestGlires)';
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGlires, log10(scaffoldNFiftyGlires)) % r = 0.3186, p-value = 0.0177
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGlires, log10(scaffoldNFiftyGlires), 'type', 'Spearman') % rho = 0.1378, p-value = 0.3148
scatter(log10(scaffoldNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGlires, 550, 'k', '.')
stdMousePeakPredictionsMultiFiltTestGlires = nanstd(mousePeakPredictionsMultiFiltTestGlires)';
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGlires, log10(scaffoldNFiftyGlires)) % r = -0.4290, p-value = 0.0011
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGlires, log10(scaffoldNFiftyGlires), 'type', 'Spearman') % rho = -0.2491, p-value = 0.0669
scatter(log10(scaffoldNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGlires, 550, 'k', '.')

mdlBrain = fitglm(horzcat(distanceFromMouseGlires, scaffoldNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGlires)
mdlBrainStd = fitglm(horzcat(distanceFromMouseGlires, scaffoldNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGlires)

% Plot evolutionary distance vs. predictions for non-enhancer orthologs of
% enhancers negative set for liver multi-species model
mousePeakPredictionsMultiTestGliresLiver = importdata('idr.optimal_peak.narrowPeak_inLiuAll_nonCDS_enhancerShort_test_multiSpeciesModel_peakPredictionsGlires.txt');
mousePeakPredictionsMultiTestGliresLiver.data(:,50) = [];
mousePeakPredictionsMultiTestGliresLiver.data(find(mousePeakPredictionsMultiTestGliresLiver.data == -1)) = NaN;
meanMousePeakPredictionsMultiTestGliresLiver = nanmean(mousePeakPredictionsMultiTestGliresLiver.data)';
mousePeakPredictionsMultiIndicatorTestGliresLiver = zeros(size(mousePeakPredictionsMultiTestGliresLiver.data, 1), 1);
for i=1:size(mousePeakPredictionsMultiTestGliresLiver.data, 1)
if length(find(isnan(mousePeakPredictionsMultiTestGliresLiver.data(i, :)))) < 14
mousePeakPredictionsMultiIndicatorTestGliresLiver(i) = 1;
end
end
sum(mousePeakPredictionsMultiIndicatorTestGliresLiver)
mousePeakPredictionsMultiFiltTestGliresLiver = mousePeakPredictionsMultiTestGliresLiver.data(find(mousePeakPredictionsMultiIndicatorTestGliresLiver==1), :);
meanMousePeakPredictionsMultiFiltTestGliresLiver = nanmean(mousePeakPredictionsMultiFiltTestGliresLiver)';
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGliresLiver, log10(scaffoldNFiftyGlires)) % r = 0.3304, p-value = 0.0138
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGliresLiver, log10(scaffoldNFiftyGlires), 'type', 'Spearman') % rho = 0.2627, p-value = 0.0529
scatter(log10(scaffoldNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGliresLiver, 550, 'k', '.')
stdMousePeakPredictionsMultiFiltTestGliresLiver = nanstd(mousePeakPredictionsMultiFiltTestGliresLiver)';
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGliresLiver, log10(scaffoldNFiftyGlires)) % r = -0.3114, p-value = 0.0206
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGliresLiver, log10(scaffoldNFiftyGlires), 'type', 'Spearman') % rho = -0.1956, p-value = 0.1521
scatter(log10(scaffoldNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGliresLiver, 550, 'k', '.')

mdlLiver = fitglm(horzcat(distanceFromMouseGlires, scaffoldNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGliresLiver)
mdlLiverStd = fitglm(horzcat(distanceFromMouseGlires, scaffoldNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGliresLiver)

% Get the distances of glires from Mus musculus
distanceFromMouseGlires = [28.6
55
71
73
70
73
73
73
73
33
33
73
73
73
73
73
70
70
73
33
33
73
71
71
73
73
73
71
55
82
71
28.6
33
33
7.04
0
8.3
3.07
71
73
45
82
73
33
33
82
70
33
73
28.6
20.9
33
71
73
71
55
];

% Get the contig N50's of glires
contigNFiftyGlires = [42476
30651
33245
4080
49369
1039
80583
64807
61105
80761
97133
218543
37562
3890
38650
64805
48087
30710
27983
11648
8259
44830
26062
22138
47778
148451
57102
44137
15675
15057
66492
69839
22511
21250
30916
32813180
29465
17887
44294
28446
30353
42347
19847
73746
18287
64648
17686
36367
29916
76398
100461
67983
34849
18955
64054
23350];

% Plot evolutionary distance vs. predictions for non-enhancer orthologs of
% enhancers negative set for brain multi-species model
mousePeakPredictionsMultiTestGlires = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_multiSpeciesModel_peakPredictionsGlires.txt');
mousePeakPredictionsMultiTestGlires.data(find(mousePeakPredictionsMultiTestGlires.data == -1)) = NaN;
meanMousePeakPredictionsMultiTestGlires = nanmean(mousePeakPredictionsMultiTestGlires.data)';
mousePeakPredictionsMultiIndicatorTestGlires = zeros(size(mousePeakPredictionsMultiTestGlires.data, 1), 1);
for i=1:size(mousePeakPredictionsMultiTestGlires.data, 1)
if length(find(isnan(mousePeakPredictionsMultiTestGlires.data(i, :)))) < 14
mousePeakPredictionsMultiIndicatorTestGlires(i) = 1;
end
end
sum(mousePeakPredictionsMultiIndicatorTestGlires)
mousePeakPredictionsMultiFiltTestGlires = mousePeakPredictionsMultiTestGlires.data(find(mousePeakPredictionsMultiIndicatorTestGlires==1), :);
meanMousePeakPredictionsMultiFiltTestGlires = nanmean(mousePeakPredictionsMultiFiltTestGlires)';
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGlires, log10(contigNFiftyGlires)) % r = 0.3584, p-value = 0.0067
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGlires, log10(contigNFiftyGlires), 'type', 'Spearman') % rho = 0.0770, p-value = 0.5719
scatter(log10(contigNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGlires, 550, 'k', '.')
stdMousePeakPredictionsMultiFiltTestGlires = nanstd(mousePeakPredictionsMultiFiltTestGlires)';
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGlires, log10(contigNFiftyGlires)) % r = -0.2677, p-value = 0.0461
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGlires, log10(contigNFiftyGlires), 'type', 'Spearman') % rho = 0.0902, p-value = 0.5077
scatter(log10(contigNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGlires, 550, 'k', '.')

mdlBrain = fitglm(horzcat(distanceFromMouseGlires, contigNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGlires)
mdlBrainStd = fitglm(horzcat(distanceFromMouseGlires, contigNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGlires)

% Plot evolutionary distance vs. predictions for non-enhancer orthologs of
% enhancers negative set for liver multi-species model
mousePeakPredictionsMultiTestGliresLiver = importdata('idr.optimal_peak.narrowPeak_inLiuAll_nonCDS_enhancerShort_test_multiSpeciesModel_peakPredictionsGlires.txt');
mousePeakPredictionsMultiTestGliresLiver.data(find(mousePeakPredictionsMultiTestGliresLiver.data == -1)) = NaN;
meanMousePeakPredictionsMultiTestGliresLiver = nanmean(mousePeakPredictionsMultiTestGliresLiver.data)';
mousePeakPredictionsMultiIndicatorTestGliresLiver = zeros(size(mousePeakPredictionsMultiTestGliresLiver.data, 1), 1);
for i=1:size(mousePeakPredictionsMultiTestGliresLiver.data, 1)
if length(find(isnan(mousePeakPredictionsMultiTestGliresLiver.data(i, :)))) < 14
mousePeakPredictionsMultiIndicatorTestGliresLiver(i) = 1;
end
end
sum(mousePeakPredictionsMultiIndicatorTestGliresLiver)
mousePeakPredictionsMultiFiltTestGliresLiver = mousePeakPredictionsMultiTestGliresLiver.data(find(mousePeakPredictionsMultiIndicatorTestGliresLiver==1), :);
meanMousePeakPredictionsMultiFiltTestGliresLiver = nanmean(mousePeakPredictionsMultiFiltTestGliresLiver)';
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGliresLiver, log10(contigNFiftyGlires)) % r = 0.3119, p-value = 0.0193
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGliresLiver, log10(contigNFiftyGlires), 'type', 'Spearman') % rho = 0.1419, p-value = 0.2960
scatter(log10(contigNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGliresLiver, 550, 'k', '.')
stdMousePeakPredictionsMultiFiltTestGliresLiver = nanstd(mousePeakPredictionsMultiFiltTestGliresLiver)';
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGliresLiver, log10(contigNFiftyGlires)) % r = -0.3130, p-value = 0.0188
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGliresLiver, log10(contigNFiftyGlires), 'type', 'Spearman') % rho = -0.0837, p-value = 0.5385
scatter(log10(contigNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGliresLiver, 550, 'k', '.')

mdlLiver = fitglm(horzcat(distanceFromMouseGlires, contigNFiftyGlires), meanMousePeakPredictionsMultiFiltTestGliresLiver)
mdlLiverStd = fitglm(horzcat(distanceFromMouseGlires, contigNFiftyGlires), stdMousePeakPredictionsMultiFiltTestGliresLiver)