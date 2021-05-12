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

% Define the logistic function
ft = fittype('c/(1 + a*exp(-b*x))');

% Plot evolutionary distance vs. predictions for flanking regions negative set
mousePeakPredictionsTestGliresFlank = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_flankNeg_peakPredictionsGlires.txt');
mousePeakPredictionsTestGliresFlank.data(find(mousePeakPredictionsTestGliresFlank.data == -1)) = NaN;
meanMousePeakPredictionsTestGliresFlank = nanmean(mousePeakPredictionsTestGliresFlank.data)';
mousePeakPredictionsIndicatorTestGliresFlank = zeros(size(mousePeakPredictionsTestGliresFlank.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGliresFlank.data, 1)
if length(find(isnan(mousePeakPredictionsTestGliresFlank.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGliresFlank(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGliresFlank)
mousePeakPredictionsFiltTestGliresFlank = mousePeakPredictionsTestGliresFlank.data(find(mousePeakPredictionsIndicatorTestGliresFlank==1), :);
meanMousePeakPredictionsFiltTestGliresFlank = nanmean(mousePeakPredictionsFiltTestGliresFlank)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresFlank, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresFlank, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresFlank, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresFlank, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresFlank, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGliresFlank = nanstd(mousePeakPredictionsFiltTestGliresFlank)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresFlank, distanceFromMouseGlires) % c = 0.9403, p = 6.0625e-27
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresFlank, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.6626, p = 2.6527e-08
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresFlank, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresFlank, ft)
plot(g)
hold off

% Plot evolutionary distance vs. predictions for enhancers in other tissues negative set
mousePeakPredictionsTestGliresOther = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_nonCerebrumMouseTissueNeg_peakPredictionsGlires.txt');
mousePeakPredictionsTestGliresOther.data(find(mousePeakPredictionsTestGliresOther.data == -1)) = NaN;
meanMousePeakPredictionsTestGliresOther = nanmean(mousePeakPredictionsTestGliresOther.data)';
mousePeakPredictionsIndicatorTestGliresOther = zeros(size(mousePeakPredictionsTestGliresOther.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGliresOther.data, 1)
if length(find(isnan(mousePeakPredictionsTestGliresOther.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGliresOther(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGliresOther)
mousePeakPredictionsFiltTestGliresOther = mousePeakPredictionsTestGliresOther.data(find(mousePeakPredictionsIndicatorTestGliresOther==1), :);
meanMousePeakPredictionsFiltTestGliresOther = nanmean(mousePeakPredictionsFiltTestGliresOther)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresOther, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresOther, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresOther, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresOther, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresOther, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGliresOther = nanstd(mousePeakPredictionsFiltTestGliresOther)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresOther, distanceFromMouseGlires) % c = 0.8910, p = 3.6154e-20
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresOther, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.6110, p = 5.6923e-07
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresOther, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresOther, ft)
plot(g)
hold off

% Plot evolutionary distance vs. predictions for 10X G/C, repeat-matched negative set
mousePeakPredictionsTestGliresGC = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_RandomGCRepeat10XNeg_peakPredictionsGlires.txt');
mousePeakPredictionsTestGliresGC.data(find(mousePeakPredictionsTestGliresGC.data == -1)) = NaN;
meanMousePeakPredictionsTestGliresGC = nanmean(mousePeakPredictionsTestGliresGC.data)';
mousePeakPredictionsIndicatorTestGliresGC = zeros(size(mousePeakPredictionsTestGliresGC.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGliresGC.data, 1)
if length(find(isnan(mousePeakPredictionsTestGliresGC.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGliresGC(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGliresGC)
mousePeakPredictionsFiltTestGliresGC = mousePeakPredictionsTestGliresGC.data(find(mousePeakPredictionsIndicatorTestGliresGC==1), :);
meanMousePeakPredictionsFiltTestGliresGC = nanmean(mousePeakPredictionsFiltTestGliresGC)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresGC, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresGC, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresGC, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresGC, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresGC, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGliresGC = nanstd(mousePeakPredictionsFiltTestGliresGC)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresGC, distanceFromMouseGlires) % c = 0.8994, p = 4.6771e-21
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresGC, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.6178, p = 3.9225e-07
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresGC, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresGC, ft)
plot(g)
hold off


% Plot evolutionary distance vs. predictions for 2X G/C, repeat-matched negative set
mousePeakPredictionsTestGliresGCSmall = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_RandomGCRepeat2XNeg_peakPredictionsGlires.txt');
mousePeakPredictionsTestGliresGCSmall.data(find(mousePeakPredictionsTestGliresGCSmall.data == -1)) = NaN;
meanMousePeakPredictionsTestGliresGCSmall = nanmean(mousePeakPredictionsTestGliresGCSmall.data)';
mousePeakPredictionsIndicatorTestGliresGCSmall = zeros(size(mousePeakPredictionsTestGliresGCSmall.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGliresGCSmall.data, 1)
if length(find(isnan(mousePeakPredictionsTestGliresGCSmall.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGliresGCSmall(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGliresGCSmall)
mousePeakPredictionsFiltTestGliresGCSmall = mousePeakPredictionsTestGliresGCSmall.data(find(mousePeakPredictionsIndicatorTestGliresGCSmall==1), :);
meanMousePeakPredictionsFiltTestGliresGCSmall = nanmean(mousePeakPredictionsFiltTestGliresGCSmall)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresGCSmall, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresGCSmall, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresGCSmall, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresGCSmall, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresGCSmall, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGliresGCSmall = nanstd(mousePeakPredictionsFiltTestGliresGCSmall)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresGCSmall, distanceFromMouseGlires) % c = 0.9495, p = 7.4740e-29
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresGCSmall, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.6499, p = 5.9736e-08
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresGCSmall, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresGCSmall, ft)
plot(g)
hold off

% Plot evolutionary distance vs. predictions for 10X dinucleotide-shuffled negative set
mousePeakPredictionsTestGliresShuf = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_DiShuf10XNeg_peakPredictionsGlires.txt');
mousePeakPredictionsTestGliresShuf.data(find(mousePeakPredictionsTestGliresShuf.data == -1)) = NaN;
meanMousePeakPredictionsTestGliresShuf = nanmean(mousePeakPredictionsTestGliresShuf.data)';
mousePeakPredictionsIndicatorTestGliresShuf = zeros(size(mousePeakPredictionsTestGliresShuf.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGliresShuf.data, 1)
if length(find(isnan(mousePeakPredictionsTestGliresShuf.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGliresShuf(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGliresShuf)
mousePeakPredictionsFiltTestGliresShuf = mousePeakPredictionsTestGliresShuf.data(find(mousePeakPredictionsIndicatorTestGliresShuf==1), :);
meanMousePeakPredictionsFiltTestGliresShuf = nanmean(mousePeakPredictionsFiltTestGliresShuf)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresShuf, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresShuf, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresShuf, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresShuf, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresShuf, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGliresShuf = nanstd(mousePeakPredictionsFiltTestGliresShuf)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresShuf, distanceFromMouseGlires) % c = 0.9496, p = 6.9579e-29
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresShuf, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.7740, p = 2.6407e-12
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresShuf, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresShuf, ft)
plot(g)
hold off

% Plot evolutionary distance vs. predictions for non-enhancer orthologs of
% enhancers negative set
mousePeakPredictionsTestGlires = importdata('Cortex_AgeB_ATAC_out_ppr.IDR0.1.filt.inAgeBAndStriatum_enhancerShort_test_peakPredictionsGlires.txt');
mousePeakPredictionsTestGlires.data(find(mousePeakPredictionsTestGlires.data == -1)) = NaN;
meanMousePeakPredictionsTestGlires = nanmean(mousePeakPredictionsTestGlires.data)';
mousePeakPredictionsIndicatorTestGlires = zeros(size(mousePeakPredictionsTestGlires.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGlires.data, 1)
if length(find(isnan(mousePeakPredictionsTestGlires.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGlires(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGlires)
mousePeakPredictionsFiltTestGlires = mousePeakPredictionsTestGlires.data(find(mousePeakPredictionsIndicatorTestGlires==1), :);
meanMousePeakPredictionsFiltTestGlires = nanmean(mousePeakPredictionsFiltTestGlires)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGlires, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGlires, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGlires, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGlires, 'exp1')
plot(f)
hold off
%p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGlires, 1);
%f = polyval(p, distanceFromMouseGlires);
%plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGlires = nanstd(mousePeakPredictionsFiltTestGlires)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGlires, distanceFromMouseGlires) % c = 0.9219, p = 6.7624e-24
[c, p] = corr(stdMousePeakPredictionsFiltTestGlires, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.7187, p = 4.4463e-10
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGlires, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGlires, ft)
plot(g)
hold off

% Plot evolutionary distance vs. predictions for liver
mousePeakPredictionsTestGliresLiver = importdata('inLiuAll_nonCDS_enhancerShort_test_peakPredictionsGlires.txt');
mousePeakPredictionsTestGliresLiver.data(find(mousePeakPredictionsTestGliresLiver.data == -1)) = NaN;
meanMousePeakPredictionsTestGliresLiver = nanmean(mousePeakPredictionsTestGliresLiver.data)';
mousePeakPredictionsIndicatorTestGliresLiver = zeros(size(mousePeakPredictionsTestGliresLiver.data, 1), 1);
for i=1:size(mousePeakPredictionsTestGliresLiver.data, 1)
if length(find(isnan(mousePeakPredictionsTestGliresLiver.data(i, :)))) < 14
mousePeakPredictionsIndicatorTestGliresLiver(i) = 1;
end
end
sum(mousePeakPredictionsIndicatorTestGliresLiver)
mousePeakPredictionsFiltTestGliresLiver = mousePeakPredictionsTestGliresLiver.data(find(mousePeakPredictionsIndicatorTestGliresLiver==1), :);
meanMousePeakPredictionsFiltTestGliresLiver = nanmean(mousePeakPredictionsFiltTestGliresLiver)';
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresLiver, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsFiltTestGliresLiver, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresLiver, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresLiver, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsFiltTestGliresLiver, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsFiltTestGliresLiver = nanstd(mousePeakPredictionsFiltTestGliresLiver)';
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresLiver, distanceFromMouseGlires) % c = 0.5908, p = 1.6388e-06
[c, p] = corr(stdMousePeakPredictionsFiltTestGliresLiver, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.4625, p = 3.3279e-04
scatter(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresLiver, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsFiltTestGliresLiver, ft)
plot(g)
hold off

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
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGlires, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGlires, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsMultiFiltTestGlires, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsMultiFiltTestGlires, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsMultiFiltTestGlires, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsMultiFiltTestGlires = nanstd(mousePeakPredictionsMultiFiltTestGlires)';
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGlires, distanceFromMouseGlires) % c = 0.8899, p = 4.7346e-20
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGlires, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.6314, p = 2.6527e-08
scatter(distanceFromMouseGlires, stdMousePeakPredictionsMultiFiltTestGlires, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsMultiFiltTestGlires, ft)
plot(g)
hold off

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
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGliresLiver, distanceFromMouseGlires)
[c, p] = corr(meanMousePeakPredictionsMultiFiltTestGliresLiver, distanceFromMouseGlires, 'type', 'Spearman')
scatter(distanceFromMouseGlires, meanMousePeakPredictionsMultiFiltTestGliresLiver, 550, 'k', '.')
hold on
f = fit(distanceFromMouseGlires, meanMousePeakPredictionsMultiFiltTestGliresLiver, 'exp1')
plot(f)
hold off
% p = polyfit(distanceFromMouseGlires, meanMousePeakPredictionsMultiFiltTestGliresLiver, 1);
% f = polyval(p, distanceFromMouseGlires);
% plot(distanceFromMouseGlires, f);
stdMousePeakPredictionsMultiFiltTestGliresLiver = nanstd(mousePeakPredictionsMultiFiltTestGliresLiver)';
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGliresLiver, distanceFromMouseGlires) % c = 0.6882, p = 4.5957e-09
[c, p] = corr(stdMousePeakPredictionsMultiFiltTestGliresLiver, distanceFromMouseGlires, 'type', 'Spearman') % c = 0.5149, p = 4.9110e-05
scatter(distanceFromMouseGlires, stdMousePeakPredictionsMultiFiltTestGliresLiver, 550, 'k', '.')
hold on
g = fit(distanceFromMouseGlires, stdMousePeakPredictionsMultiFiltTestGliresLiver, ft)
plot(g)
hold off