% Plot test set AUCs and AUPRCs:
colormap default
bar([0.962734, 0.956544, 0.969346, 0.964784, 0.993935, 0.891474; 0.945182, 0.738974, 0.884410, 0.954690, 0.965455, 0.900562])

% Plot mini version of test set AUCs and AUPRCs:
bar([0.969346, 0.993935, 0.891474; 0.884410, 0.965455, 0.900562])

% Plot test set AUCs and AUPRCs for mouse enhancers whose orthologs are not brain enhancers in at least one other species and negative set:
bar([0.862875, 0.834725, 0.879997, 0.855972, 0.696157, 0.886039; 0.800016, 0.793417, 0.838553, 0.794482, 0.603508, 0.864265])

% Plot mini version of test set AUCs and AUPRCs for mouse enhancers whose orthologs are not brain enhancers in at least one other species and negative set:
bar([0.879997, 0.696157, 0.886039; 0.838553, 0.603508, 0.864265])

% Plot test set AUCs and AUPRCs for human enhancers whose orthologs are not brain enhancers in mouse and negative set corresponding to non-enhancer orthologs of mouse enhancers
bar([0.749168, 0.732272, 0.781365, 0.762143, 0.654047, 0.783128; 0.578826, 0.568682, 0.662617, 0.598298, 0.443799, 0.643005])

% Plot test set AUCs and AUPRCs for macaque enhancers whose orthologs are not brain enhancers in mouse and negative set corresponding to non-enhancer orthologs of mouse enhancers
bar([0.895135, 0.744001, 0.887774, 0.863023, 0.775482, 0.895300; 0.879766, 0.722995, 0.878157, 0.853627, 0.763626, 0.890343])

% Plot mini version of test set AUCs and AUPRCs for macaque enhancers whose orthologs are not brain enhancers in mouse and negative set corresponding to non-enhancer orthologs of mouse enhancers
bar([0.887774, 0.775482, 0.895300; 0.878157, 0.763626, 0.890343])

% Plot test set AUCs and AUPRCs for rat enhancers whose orthologs are not brain enhancers in mouse and negative set corresponding to non-enhancer orthologs of mouse enhancers
bar([0.706145, 0.621867, 0.705905, 0.694434, 0.628193, 0.699537; 0.638580, 0.548135, 0.659630, 0.632473, 0.525143, 0.638184])

% Plot test set AUCs and AUPRCs for non-restrictive glires-specific enhancers and non-enhancers
bar([0.909961, 0.854705, 0.921350, 0.905094, 0.786859, 0.912979; 0.860386, 0.753566, 0.868279, 0.851260, 0.708801, 0.869219])

% Plot test set AUCs and AUPRCs for non-restrictive euarchonta-specific enhancers and non-enhancers
bar([0.781927, 0.656522, 0.797923, 0.792505, 0.690558, 0.819046; 0.730989, 0.606271, 0.754950, 0.720030, 0.581158, 0.769924])

% Plot mini version of test set AUCs and AUPRCs for non-restrictive euarchonta-specific enhancers and non-enhancers
bar([0.797923, 0.690558, 0.819046; 0.754950, 0.581158, 0.769924])

% Plot test set AUCs and AUPRCs for non-restrictive mouse-specific enhancers and non-enhancers
bar([0.832790, 0.606271, 0.858299, 0.830130, 0.691184, 0.875449; 0.767521, 0.795274, 0.817378, 0.763177, 0.582162, 0.849273])

% Plot test set AUCs and AUPRCs for shared brain and liver enhancers and liver enhancers that are not brain enhancers
%bar([0.934877, 0.957793, 0.940664, 0.931863, 0.813873, 0.947164; 0.888877, 0.897616, 0.895788, 0.877841, 0.608024, 0.902142])
%bar([0.953791, 0.949701, 0.954634, 0.946277, 0.867743, 0.949166; 0.912940, 0.891824, 0.913337, 0.900714, 0.765854, 0.904419])
%bar([0.903113, 0.926294, 0.904155, 0.894308, 0.792554, 0.906129; 0.863384, 0.874879, 0.864354, 0.851286, 0.671075, 0.857488])
c = colormap('parula');
scatter([1, 2], [0.934877, 0.888877], 300, [61/255, 38/255, 168/255], '*', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.953791, 0.912940], 300, [61/255, 38/255, 168/255], '.', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.903113, 0.863384], 300, [61/255, 38/255, 168/255], 'x', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.957793, 0.897616], 300, [68/255, 99/255, 252/255], '*', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.949701, 0.891824], 300, [68/255, 99/255, 252/255], '.', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.926294, 0.874879], 300, [68/255, 99/255, 252/255], 'x', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.940664, 0.895788], 300, [28/255, 169/255, 223/255], '*', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.954634, 0.913337], 300, [28/255, 169/255, 223/255], '.', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.904155, 0.864354], 300, [28/255, 169/255, 223/255], 'x', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.931863, 0.877841], 300, [74/255, 203/255, 132/255], '*', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.946277, 0.900714], 300, [74/255, 203/255, 132/255], '.', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.894308, 0.851286], 300, [74/255, 203/255, 132/255], 'x', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.813873, 0.608024], 300, [239/255, 184/255, 53/255], '*', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.867743, 0.765854], 300, [239/255, 184/255, 53/255], '.', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.792554, 0.671075], 300, [239/255, 184/255, 53/255], 'x', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.947164, 0.902142], 300, [249/255, 250/255, 20/255], '*', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.949166, 0.904419], 300, [249/255, 250/255, 20/255], '.', 'jitter', 'on', 'jitterAmount', 0.075)
hold on
scatter([1, 2], [0.906129, 0.857488], 300, [249/255, 250/255, 20/255], 'x', 'jitter', 'on', 'jitterAmount', 0.075)
hold off

% Plot test set sensitivity, specificity, and NPV for glires-specific
% enhancers and non-enhancers before and after calibration
%bar([0.839130, 0.734783, 0.708696, 0.856522, 0.826087, 0.743478; 0.813433, 0.791045, 0.947761, 0.738806, 0.611940, 0.917910; 0.746575, 0.634731, 0.654639, 0.750000, 0.672131, 0.675824])
%bar([0.743478, 0.713043, 0.700000, 0.721739, 0.669565, 0.765217; 0.895522, 0.820896, 0.962687, 0.880597, 0.791045, 0.917910; 0.670391, 0.625000, 0.651515, 0.648352, 0.582418, 0.694915])
%bar([0.839130, 0.734783, 0.708696, 0.856522, 0.826087, 0.743478; 0.743478, 0.713043, 0.700000, 0.721739, 0.669565, 0.765217]) % Sensitivity
%bar([0.813433, 0.791045, 0.947761, 0.738806, 0.611940, 0.917910; 0.895522, 0.820896, 0.962687, 0.880597, 0.791045, 0.917910]) % Specificity
%bar([0.746575, 0.634731, 0.654639, 0.750000, 0.672131, 0.675824; 0.670391, 0.625000, 0.651515, 0.648352, 0.582418, 0.694915]) % NPV
colormap summer
bar([0.856522, 0.721739; 0.738806, 0.880597; 0.750000, 0.648352])

% Plot test set sensitivity, specificity, and precision for euarchonta-specific
% enhancers and non-enhancers before and after calibration
%bar([0.738806, 0.753731, 0.604478, 0.835821, 0.679104, 0.597015; 0.643478, 0.656522, 0.843478, 0.547826, 0.543478, 0.847826; 0.546961, 0.561111, 0.692308, 0.518519, 0.514925, 0.695652])
%bar([0.649254, 0.716418, 0.574627, 0.694030, 0.514925, 0.611940; 0.800000, 0.682609, 0.856522, 0.734783, 0.717391, 0.830435; 0.654135, 0.568047, 0.700000, 0.603896, 0.515817, 0.677686])
%bar([0.738806, 0.753731, 0.604478, 0.835821, 0.679104, 0.597015; 0.649254, 0.716418, 0.574627, 0.694030, 0.514925, 0.611940]) % Sensitivity
%bar([0.643478, 0.656522, 0.843478, 0.547826, 0.543478, 0.847826; 0.800000, 0.682609, 0.856522, 0.734783, 0.717391, 0.830435]) % Specificity
%bar([0.546961, 0.561111, 0.692308, 0.518519, 0.514925, 0.695652; 0.654135, 0.568047, 0.700000, 0.603896, 0.515817, 0.677686]) % Precision
colormap summer
bar([0.835821, 0.694030; 0.547826, 0.734783; 0.518519, 0.603896])

% Plot test set sensitivity, specificity, and precision for liver enhancers
% that do and do not overlap brain enhancers before and after calibration
%bar([0.898077, 0.713462, 0.797115, 0.908654, 0.862500, 0.849038; 0.785925, 0.971319, 0.947960, 0.747191, 0.528681, 0.927558; 0.563329, 0.884386, 0.824876, 0.525000, 0.360096, 0.782801])
%bar([0.851923, 0.686538, 0.791346, 0.830769, 0.789423, 0.859615; 0.889119, 0.975754, 0.950325, 0.887936, 0.685689, 0.919870; 0.702617, 0.896985, 0.830474, 0.695093, 0.435775, 0.767382])
%bar([0.898077, 0.713462, 0.797115, 0.908654, 0.862500, 0.849038; 0.851923, 0.686538, 0.791346, 0.830769, 0.789423, 0.859615]) % Sensitivity
%bar([0.785925, 0.971319, 0.947960, 0.747191, 0.528681, 0.927558; 0.889119, 0.975754, 0.950325, 0.887936, 0.685689, 0.919870]) % Specificity
%bar([0.563329, 0.884386, 0.824876, 0.525000, 0.360096, 0.782801; 0.702617, 0.896985, 0.830474, 0.695093, 0.435775, 0.767382]) % Precision
%bar([0.946809, 0.695035, 0.849882, 0.947991, 0.918440, 0.873522; 0.735232, 0.957806, 0.924051, 0.697257, 0.580696, 0.899262; 0.614735, 0.880240, 0.833140, 0.582849, 0.494275, 0.794624])
%bar([0.907801, 0.671395, 0.840426, 0.892435, 0.828605, 0.879433; 0.853376, 0.966245, 0.929325, 0.851266, 0.719409, 0.889768; 0.734226, 0.898734, 0.841420, 0.728062, 0.568532, 0.780693])
%bar([0.946809, 0.695035, 0.849882, 0.947991, 0.918440, 0.873522; 0.907801, 0.671395, 0.840426, 0.892435, 0.828605, 0.879433]) % Sensitivity
%bar([0.735232, 0.957806, 0.924051, 0.697257, 0.580696, 0.899262; 0.853376, 0.966245, 0.929325, 0.851266, 0.719409, 0.889768]) % Specificity
%bar([0.614735, 0.880240, 0.833140, 0.582849, 0.494275, 0.794624; 0.734226, 0.898734, 0.841420, 0.728062, 0.568532, 0.780693]) % Precision
%bar([0.859887, 0.607345, 0.714124, 0.863277, 0.837853, 0.757062; 0.756396, 0.961910, 0.922683, 0.712052, 0.561683, 0.904207; 0.639765, 0.889165, 0.822917, 0.601338, 0.490248, 0.799046])
%bar([0.791525, 0.577966, 0.702825, 0.776271, 0.828605, 0.764407; 0.855600, 0.967879, 0.926663, 0.852757, 0.719409, 0.892553; 0.733892, 0.900528, 0.828229, 0.726216, 0.568532, 0.781629])
%bar([0.859887, 0.607345, 0.714124, 0.863277, 0.837853, 0.757062; 0.791525, 0.577966, 0.702825, 0.776271, 0.828605, 0.764407]) % Sensitivity
%bar([0.756396, 0.961910, 0.922683, 0.712052, 0.561683, 0.904207; 0.855600, 0.967879, 0.926663, 0.852757, 0.719409, 0.892553]) % Specificity
%bar([0.639765, 0.889165, 0.822917, 0.601338, 0.490248, 0.799046; 0.733892, 0.900528, 0.828229, 0.726216, 0.568532, 0.781629]) % Precision
c = colormap('summer')
scatter([.9, 1.9, 2.9], [0.908654, 0.747191, 0.525000], 300, [0, 127/255, 102/255], '*')
hold on
scatter([.9, 1.9, 2.9], [0.947991, 0.697257, 0.582849], 300, [0, 127/255, 102/255], '.')
hold on
scatter([.9, 1.9, 2.9], [0.863277, 0.712052, 0.601338], 300, [0, 127/255, 102/255], 'x')
hold on
scatter([1.1, 2.1, 3.1], [0.830769, 0.887936, 0.695093], 300, [1, 1, 102/255], '*')
hold on
scatter([1.1, 2.1, 3.1], [0.892435, 0.851266, 0.728062], 300, [1, 1, 102/255], '.')
hold on
scatter([1.1, 2.1, 3.1], [0.776271, 0.852757, 0.726216], 300, [1, 1, 102/255], 'x')
hold off
bar([0.898077, 0.713462, 0.797115, 0.908654, 0.862500, 0.849038; 0.946809, 0.695035, 0.849882, 0.947991, 0.918440, 0.873522; 0.859887, 0.607345, 0.714124, 0.863277, 0.837853, 0.757062])

% Plot test set AUCs and AUPRCs for full mouse liver test set, mouse liver
% enhancers whose orthologs are not liver enhancers in at least one other
% species and negative set, non-restrictive mouse-specific liver enhancers
% and non-enhancers, macaque enhancers whose orthologs are
% not liver enhancers in mouse and negative set corresponding to
% non-enhancer orthologs of mouse enhancers, rat enhancers whose orthologs
% are not liver enhancers in mouse and negative set corresponding to
% non-enhancer orthologs of mouse enhancers, liver non-restrictive glires-specific
% enhancers and non-enhancers, and liver non-restrictive euarchonta-specific enhancers and non-enhancers
%colormap copper
%bar([0.843743, 0.828386, 0.806063; 0.747208, 0.815566, 0.766077])
%colormap jet
%bar([0.812156, 0.705107; 0.800311, 0.641004])
%c = colormap('copper');
%j = colormap('jet');
%glirescolor = (c(1,:) + j(64,:))/2;
%bar([0.862520, 0.777558; 0.795285, 0.680274])
c = colormap('copper');
colormap copper
bar([0.843743, 0.828386, 0.806063, 0.812156, 0.705107, 0.862520, 0.777558; 0.747208, 0.815566, 0.766077, 0.800311, 0.641004, 0.795285, 0.680274])

% Plot test set AUCs and AUPRCs for mouse shared liver and brain enhancers
% and brain enhancers that are not liver enhancers, rat shared liver and brain enhancers
% and brain enhancers that are not liver enhancers, and macaque shared liver and brain enhancers
% and brain enhancers that are not liver enhancers
%colormap copper
%bar([0.903458, 0.883914, 0.889856; 0.914491, 0.752439, 0.858749])
scatter([1, 2], [0.903458, 0.914491], 300, [0, 0, 0], '*')
hold on
scatter([1, 2], [0.883914, 0.752439], 300, [161/255, 101/255, 64/255], '.')
hold on
scatter([1, 2], [0.889856, 0.858749], 300, [212/255, 132/255, 84/255], 'x')
hold off

% Plot test set AUCs and AUPRCs for brain multi-species model with full brain
% test set, non-restrictive clade-specific enhancers and non-enhancers,
% non-restrictive species-specific enhancers and non-enhancers, and shared
% brain and liver enhancers and liver enhancers that are not brain
% enhancers
colormap cool
bar([0.900754, 0.908299, 0.823627, 0.943402; 0.882919, 0.921803, 0.815247, 0.905133])

% Plot test set AUCs and AUPRCs for liver multi-species model with full
% liver test set, non-restrictive clade-specific enhancers and non-enhancers,
% non-restrictive species-specific enhancers and non-enhancers, and shared
% liver and brain enhancers and brain enhancers that are not liver
% enhancers
colormap cool
bar([0.877036, 0.871140, 0.814345, 0.916803; 0.858130, 0.869711, 0.649190, 0.884210])

% Plot test set AUCs and AUPRCs for liver mouse-only and multi-species
% models with non-restrictive laurasatheria-specific enhancer and
% non-enhancer test sets
colormap winter
bar([0.693710, 0.778919; 0.635183, 0.738950])