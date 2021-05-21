package cluster;

import java.io.File;

import picocli.CommandLine.*;

enum Metric {pearson, cosine, jaccard, taxicab, euclid, euclidvar, minkowski3}
enum FnType {square, ident, sqrt, tan}

/**
 * @author Daniel Schaffer
 * This class defines the command line options, which are parsed by PicoCLI.
 */
@Command(name="ClusterEnhancers", description = "Do some useful stuff")
class Options {
	  @Option(names = { "-r", "--max-rows" }, paramLabel = "<r>", defaultValue = "0", description = "read at most <r> rows of the input file, default 0 (read all rows)")
    int maxRows;
    
    @Option(names={ "-i", "--input" }, paramLabel = "<f>", required = true, description = "Input file")
    File inputFile;
    
    @Option(names={ "-o", "--output" }, paramLabel = "<f>", required = true, description = "Output file (tab delimted)")
    File outputFile;
    
    @Option(names={ "-m", "--matrix-output" }, paramLabel = "<f>", description = "Output distance matrix (comma delimted) of clusters to file")
    File matrixOutFile;
    
    @Option(names={ "-d", "--distance-metric" }, defaultValue = "pearson", description = "Distance metric to use: ${COMPLETION-CANDIDATES} (default: ${DEFAULT-VALUE})")
    Metric metric = null;
    
    @Option(names={ "-e", "--distance-transform" }, defaultValue = "ident", description = "Transform of distance used in Ward clustering: ${COMPLETION-CANDIDATES} (default: ${DEFAULT-VALUE})")
    FnType wardFnType = null;
    
    @Option(names={ "-f", "--filter-input" }, arity = "0..1", defaultValue = "0.0", fallbackValue="0.5,0.25", description = "Controls input filtering. If not used, no input filtering is done. If used with 0 arguments,"
    		+ " overall and clade-based filtering is done with respective thresholds ${FALLBACK-VALUE}. If used with 1 argument, overall filtering ONLY is done with that threshold. If used with 2 arguments, overall"
    		+ " and clade-based filtering is done with those thresholds, respectivly.", paramLabel = "(<d>)", split=",")
    double[] inputThresholds;
    
    @Option(names={ "-g", "--filter-output" }, arity = "0..1", defaultValue = "0.0", fallbackValue="0.75,0.5", description = "Controls output filtering. 0-argument defulat thresholds are ${FALLBACK-VALUE}. "
    		+ "See -f for other behavior", paramLabel = "(<d>)", split=",")
    double[] outputThresholds;
    
    @Option(names={ "-t", "--transform-output" }, paramLabel = "<d>", description = "Apply the distance transformation specified by -e to the output distance matrix.")
    boolean transformOutput; //TODO: Only allow if -m is passed
    
    @Option(names={ "-k", "--k-means" }, paramLabel="<n>", defaultValue = "0", description = "Number of k-means clusters to make (default 0 = no k-means clustering)")
    int kMeansClusters;
    
    @Option(names={ "-w", "--ward" }, paramLabel="<n>", defaultValue = "0", description = "Number of ward clusters to make (default 0 = no Ward clustering)")
    int wardClusters;
    
    @Option(names={ "--treat-kmeans-clusters-as-clusters" }, description = "Treat k-means clusters as pre-existing clusters for Ward clustering (default: treat them as individuals)")
    boolean treatKClustersAsClusters;
    
    @Option(names={ "-a", "--nproc" }, paramLabel="<n>", defaultValue = "1", description = "Number of compute processors to use (default: 1)")
    int nproc; 
    
    @Option(names={ "-x", "--low-threshold" }, paramLabel="<d>", defaultValue = "0.5", description = "Threshold to be considered a negative prediction (defulat: ${DEFAULT-VALUE})")
    double lowThresh;
    
    @Option(names={ "-y", "--high-threshold" }, paramLabel="<d>", defaultValue = "0.5", description = "Threshold to be considered a positive prediction (default: ${DEFAULT-VALUE})")
    double highThresh;
    
    @Option(names={"--kmeans-max-iterations" }, paramLabel="<n>", defaultValue = "30", description = "Maximum number of iterations for k-means (default: ${DEFAULT-VALUE})")
    int kMeansMaxIts;
    
    @Option(names={"--kmeans-nondeterministic" },description = "Don't use a fixed seed for k-means initialization")
    boolean kMeansRandom; 
    
    @Option(names = { "-c", "--columns" }, description = "Read input columns instead of rows, default false (read rows). If specified, no clade-based filtering will happen")
    boolean columns;
    
    @Option(names = {"--filter-verbose" }, description = "Print every vector and cluster that is filtered out.")
    boolean filterVerbose;
    
    @Option(names = { "--sample" }, paramLabel = "<r>", defaultValue = "0", description = "sample <r> enhancers from all filtered enhancers (default: use all enhancers)")
    int sample;
    
    @ArgGroup(exclusive = false)
    CFFiles cladeFiles;
    
    static class CFFiles {
    	@Option(names = { "-s", "--species-file" }, required = true, paramLabel = "<f>", description = "List of species matching order of columns")
    	File speciesFile;
    
    	@Option(names = { "-l", "--clade-file" }, required = true, paramLabel = "<f>", description = "File where 2nd column is species and 4th column is clades. Required for clade-based filtering.")
    	File cladeFile;
    
    }
    
    @ArgGroup(exclusive = true)
    KMeansExclusiveArguments exclKArgs;
    
    static class KMeansExclusiveArguments {
    	@Option(names={ "-p", "--kmeans++" }, description = "Use k-means++ for k-means cluster initialization")
        boolean kpp;
    	
    	@Option(names={"--kmeans-filter-centers" }, arity = "0..1", defaultValue = "0.0", fallbackValue="0.75,0.5", description = "Allows stricter filtering of inputs that can be chosen as a k-means initial center. "
    			+ "Not compatiblewith k-means++. If not used, all input that passes input filtering can be an inital center. If used with 0 arguments,"
        		+ " overall and clade-based filtering is done with respective thresholds ${FALLBACK-VALUE}. If used with 1 argument, overall filtering ONLY is done with that threshold. If used with 2 arguments, overall"
        		+ " and clade-based filtering is done with those thresholds, respectivly.", paramLabel = "(<d>)", split=",")
        double[] centerThresholds;
    	
    }

    @Option(names = { "-h", "--help" }, usageHelp = true, description = "display a help message")
    boolean helpRequested;
}
