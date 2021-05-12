# Run LOLA on a pair of bed files and a database directory

# Process the command line
args <- commandArgs(trailingOnly = TRUE)
peakDataFile <- args[1] # Bed file (3-column or strand information included)
universeDataFile <- args[2] # Bed file (3-column or strand information included)
dbLocation <- args[3] # Should contain a folder called "collection" that has a sub-directory called "regions" with the bed files
outputFile <- args[4]
redefineUserSets <- args[5]

# Run LOLA
library("methods")
library("LOLA")
regionDB = loadRegionDB(dbLocation)
userSet = readBed(peakDataFile)
universeSet = readBed(universeDataFile)
lolaResults = runLOLA(userSet, universeSet, regionDB, redefineUserSets=eval(parse(text=redefineUserSets)))
write.table(lolaResults[order(dbSet, decreasing=FALSE)], file=outputFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)
	# Can include row.names or col.names in the output if desired
