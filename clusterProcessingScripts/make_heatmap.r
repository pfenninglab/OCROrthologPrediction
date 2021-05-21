#Contains code to make heatmaps of enhancers

#Using gplots 3.0.1 from github/ChristophH/gplots, 
#which fixes a bug that makes heatmap.2 really slow
library("gplots")


#Heatmaps of all clusters/groups of enhancers
pwd = "/path/to/directory/with/predictions/for/each/cluster"
num_enhancers = 100
tissue = "brain"
setwd(pwd)
colors = c("#f2f2f2", "#ebdbda", "#e4c4c3", "#dcadad", "#d39696", "#c98081", "#be696c", "#b35258", "#a63944", "#991b32")
my_palette <-append(rep("#808080", 10), colors)
for (j in 1:num_enhancers) {
  temp = read.csv(paste0("cluster", j, ".csv", collapse=""), sep=",", header=F)
  temp1 <- as.matrix(temp)
  if (nrow(temp1) > 9){
    png(file = paste0("cluster", toString(j), ".png", collapse=""), width=2625, height=2040)
    heatmap.2(temp1, col=my_palette, dendrogram="none", trace='none', symm=F,symkey=F,symbreaks=T, scale="none", key=F, labRow=F, labCol=F, 
              Colv=F, Rowv=F, margins=c(10,4), lhei = c(1,12), lwid=c(1,20))
    title(paste("cluster", j), line=-2.25, cex.main = 9)
    mtext("220 Boreoeutherians", line=3.5, side=1, cex=6)
    mtext(paste(nrow(temp1), tissue, " enhancers"), line=-0.5, side=2, cex=6)
    rect(0.0178, 0.0134, 1.0012, 0.9596, lwd=40, ljoin=1, lend=2, xpd=T)
    dev.off()
  }
}


#Heatmap highlighting a specific group of species, for one group of enhancers
temp = read.csv("predicted_activity_matrix.csv", sep=",", header=F)
temp1 <- as.matrix(temp)
colors = c("#f2f2f2", "#ebdbda", "#e4c4c3", "#dcadad", "#d39696", "#c98081", "#be696c", "#b35258", "#a63944", "#991b32")
my_palette <-append(rep("#808080", 10), colors)
  
#These correspond to Rat, mouse, macaque, human
keysp = c(142,143,200,217)
temp2 = temp1
collabs = replicate(ncol(temp1), "")
for (i in 1:ncol(temp1)) {
  if (i %in% keysp) {
    collabs[i] = "*"
  } else {
    temp2[,i] = -1
  }
}

png(file = "heatmap_all.png", width=2625, height=2040)
heatmap.2(temp1, col=my_palette, dendrogram="none", trace='none', symm=F,symkey=F,symbreaks=T, scale="none", key=F, labRow=F, labCol=F, 
          Colv=F, Rowv=F, margins=c(10,4), lhei = c(1,12), lwid=c(1,20))
title("All species", line=-2.25, cex.main = 9)
mtext("220 Boreoeutherians", line=3.5, side=1, cex=6)
mtext("1000 brain enhancers", line=-0.5, side=2, cex=6)
rect(0.0178, 0.0134, 1.0012, 0.9596, lwd=40, ljoin=1, lend=2, xpd=T)
dev.off()
    
png(file = "heatmap_few.png", width=2625, height=2040)
heatmap.2(temp2, col=my_palette, dendrogram="none", trace='none', symm=F,symkey=F,symbreaks=T, scale="none", key=F, labRow=F, labCol=F, 
          Colv=F, Rowv=F, margins=c(10,4), lhei = c(1,12), lwid=c(1,20))
title("Four inital species", line=-2.25, cex.main = 9)
mtext("220 Boreoeutherians", line=3.5, side=1, cex=6)
mtext("1000 brain enhancers", line=-0.5, side=2, cex=6)
rect(0.0178, 0.0134, 1.0012, 0.9596, lwd=40, ljoin=1, lend=2, xpd=T)
dev.off()
    






