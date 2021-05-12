library("limma")
samples = read.table("/projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/expressionSummary_averageTPMnormMedian_modified.txt", header=TRUE, row.names=1)
sampleMat = matrix(nrow = 8, ncol=2)
sampleMat[,1] = 1
sampleMat[,2] = 1
sampleMat[4,2] = 0
sampleMat[5,2] = 0
sampleMat[6,2] = 0
sampleMat[7,2] = 0
colnames(sampleMat) = c("Base", "EuarchontaVsGlires")
rownames(sampleMat) = c("homSap", "rheMac", "calJac", "musMus", "ratNor", "cavPor", "oryCun", "tupBel")
fit <- lmFit(samples, sampleMat)
fit <- eBayes(fit)
topTable(fit, coef="EuarchontaVsGlires", adjust="BH")

samplesPlus = read.table("/projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/expressionSummary_averageTPMnormMedian_modifiedPlus.txt", header=TRUE, row.names=1)
sampleMatPlus = matrix(nrow = 13, ncol=2)
sampleMatPlus[,1] = 1
sampleMatPlus[,2] = 1
sampleMatPlus[9,2] = 0
sampleMatPlus[10,2] = 0
sampleMatPlus[11,2] = 0
sampleMatPlus[12,2] = 0
sampleMatPlus[13,2] = 0
colnames(sampleMatPlus) = c("Base", "EuarchontagliresVsLaurasiatheria")
rownames(sampleMatPlus) = c("homSap", "rheMac", "calJac", "musMus", "ratNor", "cavPor", "oryCun", "tupBel", "canFam", "felCat", "musFur", "bosTau", "susScr")
fitPlus <- lmFit(samplesPlus, sampleMatPlus)
fitPlus <- eBayes(fitPlus)
topTable(fitPlus, coef="EuarchontagliresVsLaurasiatheria", adjust="BH")

library("dplyr")
samplesFilt = samples %>% filter_at(vars(1:8), any_vars(. >= 1))
fitFilt <- lmFit(samplesFilt, sampleMat)
fitFilt <- eBayes(fitFilt)
topTable(fitFilt, coef="EuarchontaVsGlires", adjust="BH")

samplesPlusFilt = samplesPlus %>% filter_at(vars(1:13), any_vars(. >= 1))
fitPlusFilt <- lmFit(samplesPlusFilt, sampleMatPlus)
fitPlusFilt <- eBayes(fitPlusFilt)
topTable(fitPlusFilt, coef="EuarchontagliresVsLaurasiatheria", adjust="BH")

samplesFiltEuarchonta = samples %>% filter_at(vars(c(1,2,3,8)), all_vars(. >= 1))
fitFiltEuarchonta <- lmFit(samplesFiltEuarchonta, sampleMat)
fitFiltEuarchonta <- eBayes(fitFiltEuarchonta)
topTable(fitFiltEuarchonta, coef="EuarchontaVsGlires", adjust="BH")

samplesFiltFilt = samples %>% filter_at(vars(1:8), any_vars(. >= 5))
fitFiltFilt <- lmFit(samplesFiltFilt, sampleMat)
fitFiltFilt <- eBayes(fitFiltFilt)
topTable(fitFiltFilt, coef="EuarchontaVsGlires", adjust="BH")

samplesFiltFiltEuarchonta = samples %>% filter_at(c(1,2,3,8), all_vars(. >= 5))
fitFiltFiltEuarchonta <- lmFit(samplesFiltFiltEuarchonta, sampleMat)
fitFiltFiltEuarchonta <- eBayes(fitFiltFiltEuarchonta)
topTable(fitFiltFiltEuarchonta, coef="EuarchontaVsGlires", adjust="BH")

samplesFiltFiltGlires = samples %>% filter_at(c(4,5,6,7), all_vars(. >= 5))
fitFiltFiltGlires <- lmFit(samplesFiltFiltGlires, sampleMat)
fitFiltFiltGlires <- eBayes(fitFiltFiltGlires)
topTable(fitFiltFiltGlires, coef="EuarchontaVsGlires", adjust="BH")

sampleMatPlusRodents = matrix(nrow = 13, ncol=2)
sampleMatPlusRodents[,1] = 1
sampleMatPlusRodents[,2] = 1
sampleMatPlusRodents[4,2] = 0
sampleMatPlusRodents[5,2] = 0
sampleMatPlusRodents[6,2] = 0
colnames(sampleMatPlusRodents) = c("Base", "NonRodentsVsRodents")
rownames(sampleMatPlusRodents) = c("homSap", "rheMac", "calJac", "musMus", "ratNor", "cavPor", "oryCun", "tupBel", "canFam", "felCat", "musFur", "bosTau", "susScr")
fitPlusRodents <- lmFit(samplesPlus, sampleMatPlusRodents)
fitPlusRodents <- eBayes(fitPlusRodents)
topTable(fitPlusRodents, coef="NonRodentsVsRodents", adjust="BH", number=20)
# Significant genes in: /projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/RodentDiffGenes.txt (15 total)
tt = topTable(fitPlusRodents, coef="NonRodentsVsRodents", adjust="BH", number=5944)
write.table(tt, "/projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/RodentDiffGenesAllResults.txt", quote = FALSE, sep = "\t")

fitPlusRodentsFilt <- lmFit(samplesPlusFilt, sampleMatPlusRodents)
fitPlusRodentsFilt <- eBayes(fitPlusRodentsFilt)
topTable(fitPlusRodentsFilt, coef="NonRodentsVsRodents", adjust="BH", number=20)
# Significant genes in: /projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/RodentDiffGenesMinExpr1.txt (15 total)

samplesPlusFiltFilt = samplesPlus %>% filter_at(vars(1:13), any_vars(. >= 5))
fitPlusRodentsFiltFilt <- lmFit(samplesPlusFiltFilt, sampleMatPlusRodents)
fitPlusRodentsFiltFilt <- eBayes(fitPlusRodentsFiltFilt)
topTable(fitPlusRodentsFiltFilt, coef="NonRodentsVsRodents", adjust="BH", number=20)
# Significant genes in: /projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/RodentDiffGenesMinExpr5.txt (11 total)

sampleMatRodents = matrix(nrow = 8, ncol=2)
sampleMatRodents[,1] = 1
sampleMatRodents[,2] = 1
sampleMatRodents[4,2] = 0
sampleMatRodents[5,2] = 0
sampleMatRodents[6,2] = 0
colnames(sampleMatRodents) = c("Base", "NonRodentsVsRodents")
rownames(sampleMatRodents) = c("homSap", "rheMac", "calJac", "musMus", "ratNor", "cavPor", "oryCun", "tupBel")
fitRodents <- lmFit(samples, sampleMatRodents)
fitRodents <- eBayes(fitRodents)
topTable(fitRodents, coef="NonRodentsVsRodents", adjust="BH", number=20)
# Significant genes in: /projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/RodentDiffGenesEuarchontaglires.txt (2 total)

samplesPlusPlus = read.table("/projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/expressionSummary_averageTPMnormMedian_modifiedPlusPlus.txt", header=TRUE, row.names=1)
sampleMatPlusPlusRodents = matrix(nrow = 15, ncol=2)
sampleMatPlusPlusRodents[,1] = 1
sampleMatPlusPlusRodents[,2] = 1
sampleMatPlusPlusRodents[4,2] = 0
sampleMatPlusPlusRodents[5,2] = 0
sampleMatPlusPlusRodents[6,2] = 0
colnames(sampleMatPlusPlusRodents) = c("Base", "NonRodentsVsRodents")
rownames(sampleMatPlusPlusRodents) = c("homSap", "rheMac", "calJac", "musMus", "ratNor", "cavPor", "oryCun", "tupBel", "canFam", "felCat", "musFur", "bosTau", "susScr", "monDom", "sarHar")
fitPlusPlusRodents <- lmFit(samplesPlusPlus, sampleMatPlusPlusRodents)
fitPlusPlusRodents <- eBayes(fitPlusPlusRodents)
topTable(fitPlusPlusRodents, coef="NonRodentsVsRodents", adjust="BH", number=20)
# Significant genes in: /projects/pfenninggroup/machineLearningForComputationalBiology/regElEvoGrant/RNASeq/Berthelot2018Data/RodentDiffGenesAll.txt (14 total)