package cluster;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Scanner;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletionService;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorCompletionService;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.InputMismatchException;
import java.util.Iterator;
import java.util.LinkedList;
import picocli.CommandLine;

/**
 * @author Daniel Schaffer
 * A program to perform K-means and/or Ward clustering on activity predictions for enhancers
 */
public class Main {
	//OOPs
	protected static double lowThresh;
	protected static double highThresh;
	protected static Metric metric;
	protected static Function<Double, Double> wardFn;
	
	/**
	 * Given a list of individual PredVectors, clusters them 
	 * into up to numClusters non empty clusters using K-means clustering.
	 * Initializes clusters using the Forgy or K-means++ methods.
	 * Runs up to maxIterations iterations; if 0, runs to convergence.
	 * Careful: some combinations of input and distance method may result in no convergence.
	 * 
	 * @param List<PredVector> vectors, a list of PredVectors
	 * @param List<PredVector> centerVectors, a subset of vectors to use when picking initial centers
	 *                                        Not supported for k-means++
	 * @param int numClusters, the maximum number of (non-empty) clusters to create
	 * @param int maxIterations, the maximum number of iterations to run.
	 * @param boolean kpp Use k-means++ to initialize?
	 * @param booleanrandomSeed Use a non-deterministic source of randomness?
	 * @param restrictInitialCenters Use a strictly-filtered list of input clusters?
	 * @param int nproc Max. number of compute threads to use (total = nproc + 1)
	 * @return List<PVClusters> clusters, a list of clusters that partitions the input vectors.
	 * @throws InterruptedException 
	 * @throws ExecutionException 
	 */
	private static List<PVCluster> kMeans(List<PredVector> vectors, List<PredVector> centerVectors, int numClusters, int maxIterations, boolean kpp, boolean randomSeed, int nproc) throws InterruptedException, ExecutionException{
		if (numClusters <= 0 || centerVectors.size() <= numClusters) {
			return clusterize(vectors);
		}
		System.err.println("Starting k-means initialization");	
		List<PVCluster> clusters = new ArrayList<PVCluster>(numClusters);
		Random gen = randomSeed ? new Random() : new Random(0);
		long newSeed = gen.nextLong();
		gen.setSeed(newSeed); //Should still be deterministic if the initial seed was 0
		System.err.println("K-means initializtion with " + (randomSeed ? "non-deterministic" : "deterministic") + " seed: " + newSeed);
		int numVectors = vectors.size();
		int numCenterVectors = centerVectors.size();
		
		if (kpp) {
			//Initialize using k-means++ method
			Map<PredVector,Double> bestDistMap = new HashMap<PredVector,Double>();
			int centerIndex = gen.nextInt(numVectors);
			PredVector newChoice = vectors.get(centerIndex);
			newChoice.setCenter();
			//System.err.println("Chose " + newChoice + " as cluster center");
			PVCluster newCluster = new PVCluster(newChoice);
			clusters.add(newCluster);
			bestDistMap.put(newChoice, 0.0);
			for (PredVector pv : vectors) {
				if (pv != newChoice) {
					bestDistMap.put(pv, newCluster.dist(pv));
				}
			}
			for (int i = 1; i < numClusters; i++) {
				List<Double> weights = new ArrayList<Double>(numVectors);
				for (PredVector pv : vectors) {
					weights.add(Math.pow(bestDistMap.get(pv), 2));
				}
				centerIndex = RandChoice.randChoice(gen, numVectors, weights);
				newChoice = vectors.get(centerIndex);
				//System.err.println("Chose " + newChoice + " as cluster center");	
				newChoice.setCenter();
				newCluster = new PVCluster(newChoice);
				newChoice.setCluster(newCluster);
				clusters.add(newCluster);
				bestDistMap.put(newChoice, 0.0);
				for (PredVector pv : vectors) {
					if (!pv.isCenter()) {
						bestDistMap.put(pv, Math.min(newCluster.dist(pv), bestDistMap.get(pv)));
					}
				}
			}
		} else {
			//Initialize using Forgy method
			//Uniformly choose numClusters elements to be the initial means
			//This line is apparently the slow way to do this.
			List<Integer> indices = IntStream.range(0, numCenterVectors).boxed().collect(Collectors.toList());
			Collections.shuffle(indices, gen); //Randomization! Yikes!
			for(int i = 0; i < numClusters; i++) {
				PredVector newChoice = centerVectors.get(indices.get(i));
				//System.err.println("Chose " + newChoice + " as cluster center");
				newChoice.setCenter();
				clusters.add(new PVCluster(newChoice));			
				}
		} 
		
		ExecutorService execServ = Executors.newFixedThreadPool(nproc);
		CompletionService<ClusterSwap> compServ = new ExecutorCompletionService<ClusterSwap>(execServ);
		int tasks = 0;
		System.err.println("Assigning remaining enhancers");	
		//Assign remaining vectors; note that distances are based only on initial clusters
		for (PredVector pv : vectors) {
			if (pv.isCenter()) {
				continue; //Chosen as a cluster center
			}
			compServ.submit(() -> {
				PVCluster best = new DummyCluster();
				double bestDist = 3;
				for (PVCluster c : clusters) {
					double dist = c.dist(pv);
					if (dist < bestDist) {
						bestDist = dist;
						best = c;
					}
				}
				return new ClusterSwap(null, pv, best);	//Using as a tuple						
			});
			tasks++;
		}
		while (tasks > 0) {
			ClusterSwap s = compServ.take().get(); //take will wait, get shouldn't
			s.swap(false);
			tasks --;
		}
		
		System.err.println("Starting k-means iteration");		
		//Iterative step
		boolean changesMade = true;
		int iterations = 0;		
				while (changesMade && (maxIterations == 0 || iterations < maxIterations)) {
			iterations ++;
			//Update cluster centers & remove empty clusters
			List<PVCluster> emptyClusters  = new ArrayList<PVCluster>();
			for (PVCluster c : clusters) {
				if (c.isEmpty()) {
					emptyClusters.add(c);
				} else {
					c.updateCenter();
				}
			}
			clusters.removeAll(emptyClusters);
			
			changesMade = false;
			//Reassign clusters
			//We iterate over the vectors directly to prevent concurrent modification
			//That way, we know the current cluster of each vector;
			//This code generates a list of tasks that can be run in parallel
				for (PredVector pv : vectors) {
					compServ.submit(() -> {
						PVCluster old = pv.getCluster();
						PVCluster best = old;
						double bestDist = old.dist(pv);
						for (PVCluster c : clusters) {
							double dist = c.dist(pv);
							if (dist < bestDist) {
								bestDist = dist;
								best = c;
							}
						}
						if (best != old) {
							return new ClusterSwap(old, pv, best);							
						}
						return null;	
					});
					tasks++;
				}	
			//Do swaps (not updating yet)
			int count = 0;
			while (tasks > 0) {
				ClusterSwap s = compServ.take().get(); //take will wait, get shouldn't
				if (s != null) {
					changesMade = true;
					s.swap(false);
					count ++;
				}
				tasks --;
			}
			System.err.println("Made " + Integer.toString(count) + " swaps");
		}

		//Final update/removal; needed since we might stop before convergence
		List<PVCluster> emptyClusters  = new ArrayList<PVCluster>();
		for (PVCluster c : clusters) {
			if (c.isEmpty()) {
				emptyClusters.add(c);
			} else {
				c.updateCenter();
			}
		}
		clusters.removeAll(emptyClusters);
		
		execServ.shutdownNow();  //No jobs running currently
		return clusters;
	}
	
	/**
	 * Given a list of Clusterable objects, returns a list of PVClusters 
	 * each containing one of the objects.
	 * @param List<T extends Clusterable> vectors, a list
	 * @return List<PVCluster> clusters, a list of PVClusters the same length as vectors.
	 */
	private static <T extends Clusterable> List<PVCluster> clusterize(List<T> vectors) {
		List<PVCluster> clusters = new ArrayList<PVCluster>(vectors.size());
		for (Clusterable pv : vectors) {
			clusters.add(new PVCluster(pv));
		}
		return clusters;
	}
	
	/**
	 * Given a list of PVClusters, uses Ward clustering to merge them in-place 
	 * until no more than numClusters PVClusters remain. This treats the elements 
	 * of clusters as pre-existing clusters.
	 * 
	 * @param List<PVClsuters> clusters, a list of PVClusters
	 * @param numClusters, the maximum remaining number of clusters after running
	 * @throws InterruptedException 
	 * @throws ExecutionException 
	 */
	private static void wardMergeOld(List<PVCluster> clusters, int numClusters, int nproc) throws InterruptedException, ExecutionException {
		while (clusters.size() > numClusters) {
			//Find the best merge (i.e. the one that increases variance the least
			List<Callable<ClusterMerge>> tasks = new LinkedList<Callable<ClusterMerge>>();
			for (int i = 0; i < clusters.size(); i++) {
				for (int j = i+1; j < clusters.size(); j++) {
					PVCluster c1 = clusters.get(i);
					PVCluster c2 = clusters.get(j);
					tasks.add(() -> { 
						double deltaVar = c1.mergedCopy(c2).withinVariance();
						deltaVar -= c1.withinVariance() + c2.withinVariance();
						return new ClusterMerge(c1, c2, deltaVar);
					});
				}
			}
			//Wait for tasks
			ExecutorService executor = Executors.newFixedThreadPool(nproc);
			//System.err.println("Submitting tasks.");
			List<Future<ClusterMerge>> swaps = executor.invokeAll(tasks); //Blocks until all done
			executor.shutdown();
			//Perform the best merge (in place)		
			ClusterMerge bestMerge = new ClusterMerge();
			for (Future<ClusterMerge> f : swaps) {
				ClusterMerge m = f.get(); //Should be done, so no waiting
				if (m.isBetterThan(bestMerge)) bestMerge = m;
			}
			bestMerge.merge(true);
			clusters.remove(bestMerge.getMerged());
			if (clusters.size() % 100 == 0) {
				System.err.println("Down to " + clusters.size() + " clusters with Ward clustering.");
			}
		}
	}
 
	/**
	 * Given a list of PVClusters, uses Ward clustering to merge them in-place 
	 * until no more than numClusters PVClusters remain. This treats the elements 
	 * of clusters as pre-existing clusters. Hopefully more efficient
	 * 
	 * @param List<PVClsuters> clusters, a list of PVClusters
	 * @param numClusters, the maximum remaining number of clusters after running
	 * @throws InterruptedException 
	 * @throws ExecutionException 
	 */
	private static void wardMerge(List<PVCluster> clusters, int numClusters, int nproc) throws InterruptedException, ExecutionException {
		if (numClusters >= clusters.size() || numClusters == 0) return;
		//Initally compute all distances
		List<Callable<ClusterMerge>> tasks = new LinkedList<Callable<ClusterMerge>>();
		List<ClusterMerge> savedMerges = new LinkedList<ClusterMerge>();
		for (int i = 0; i < clusters.size(); i++) {
			for (int j = i+1; j < clusters.size(); j++) {
				PVCluster c1 = clusters.get(i);
				PVCluster c2 = clusters.get(j);
				tasks.add(() -> { 
					double deltaVar = c1.mergedCopy(c2).withinVariance();
					deltaVar -= c1.withinVariance() + c2.withinVariance();
					return new ClusterMerge(c1, c2, deltaVar);
				});
			}
		}
		ExecutorService executor = Executors.newFixedThreadPool(nproc);
		List<Future<ClusterMerge>> swaps = executor.invokeAll(tasks); //Blocks until all done
		//executor.shutdown();
		for (Future<ClusterMerge> f : swaps) {
			ClusterMerge m = f.get(); //Waiting
			savedMerges.add(m);
		}
		ClusterMerge bestMerge;
		while (clusters.size() > numClusters + 1) {
			//Perform the best merge (in place)		
			bestMerge = new ClusterMerge();
			for (ClusterMerge m : savedMerges) {
				if (m.isBetterThan(bestMerge)) bestMerge = m;
			}
			bestMerge.merge(true);
			clusters.remove(bestMerge.getMerged());
			if (clusters.size() % 100 == 0) {
				System.err.println("Down to " + clusters.size() + " clusters with Ward clustering.");
			}
			
			//Set<ClusterMerge> toRemove = new HashSet<ClusterMerge>();
			Set<ClusterMerge> toReplace = new HashSet<ClusterMerge>();
			Iterator<ClusterMerge> i = savedMerges.iterator();
			while (i.hasNext()) {
				ClusterMerge merge = i.next();
				if (merge.getMerged() == bestMerge.getMerged() || merge.getMergee() == bestMerge.getMerged()) {
					//toRemove.add(merge);
					i.remove();
				} else if (merge.getMerged() == bestMerge.getMergee() || merge.getMergee() == bestMerge.getMergee()) {
					toReplace.add(merge);
				}
			}
			//toRemove.addAll(toReplace);
			//savedMerges.removeAll(toRemove);
			List<Callable<Boolean>> updateTasks = new ArrayList<Callable<Boolean>>();
			for (ClusterMerge m : toReplace) { //Update distances in place
				PVCluster c1 = m.getMergee();
				PVCluster c2 = m.getMerged();
				updateTasks.add(() -> { 
					double deltaVar = c1.mergedCopy(c2).withinVariance();
					deltaVar -= c1.withinVariance() + c2.withinVariance();
					m.setDeltaVar(deltaVar);
					return true; 
				});
			}
			executor = Executors.newFixedThreadPool(nproc);
			executor.invokeAll(updateTasks); 
			executor.shutdown(); //Blocks until all done
		}
		//Last merge
		bestMerge = new ClusterMerge();
		for (ClusterMerge m : savedMerges) {
			if (m.isBetterThan(bestMerge)) bestMerge = m;
		}
		bestMerge.merge(true);
		clusters.remove(bestMerge.getMerged());
		executor.shutdown();
	}
	
	/**
	 * Given a list of Clusterables, clusters them into at most numClusters
	 * new clusters using Ward clustering. That is, this treats each element 
	 * of preds as an individual object and forms new clusters (also of type
	 * PVCluster) containing the elements of preds.
	 * 
	 * @param List<T extends Clusterable> preds, a list of PVClusters or PredVectors
	 * @param numClusters, the maximum number of meta-clusters to produce
	 * @return List<PVCluster> clusters, a list of clusters that partition preds.
	 * @throws ExecutionException 
	 * @throws InterruptedException 
	 */
	private static <T extends Clusterable> List<PVCluster> wardCluster(List<T> preds, int numClusters, int nproc) throws InterruptedException, ExecutionException {
		//Put everything in its own cluster
		List<PVCluster> clusters = clusterize(preds);
		//Merge in place
		wardMerge(clusters, numClusters, nproc);
		return clusters;
	}
	
	/**
	 * Generates PredVectors to represent enhancers from a tab-delimited input file, 
	 * where rows represent enhancers and columns represent species
	 * 
	 * @param File input, a tab-delimtied file of enhancer activity predictions
	 * @param maxRows, the maximum number of rows to read. If 0, will read all rows in the file
	 * @return List<PredVector> pvs, the list of PredVectors obtained by parsing the file.
	 * @throws FileNotFoundException
	 */
	private static List<PredVector> parseInputRows(File input, int maxRows) throws FileNotFoundException {
		List<PredVector> pvs = new ArrayList<PredVector>();
		Scanner reader = new Scanner(input);
		int count = 0;
		while(reader.hasNextLine() && (maxRows == 0 || count < maxRows)) {
			String[] tokens = reader.nextLine().trim().split("\t");
			if (tokens.length > 1) {
				//in Python: [double(i) for i in tokens[1:]]
				List<Double> preds = new ArrayList<Double>(tokens.length - 1);
				for (int i = 1; i < tokens.length; i++) {
					preds.add(Double.parseDouble(tokens[i]));
				}
				pvs.add(new PredVector(preds, tokens[0]));
				count ++;
			}
		}
		reader.close();
		return pvs;
	}
	
	/**
	 * Generates PredVectors to represent species from a tab-delimited input file, 
	 * where rows represent enhancers and columns represent species
	 * 
	 * @param File enhancerFile, a tab-delimtied file of enhancer activity predictions
	 * @param List<String> speciesNames, the species corresponding to each column of the enhancer file
	 * @return List<PredVector> pvs, the list of PredVectors obtained by parsing the file.
	 * @throws FileNotFoundException
	 */
	private static List<PredVector> parseInputColumns(File enhancerFile, List<String> speciesNames, int maxRows) throws FileNotFoundException{
		System.err.println("Warning: reading column-wise is untested and may or may not work as desired.");
		List<PredVector> pvs = new ArrayList<PredVector>();
		List<List<Double>> predLists = new ArrayList<List<Double>>(speciesNames.size());
		for (int i = 0; i < speciesNames.size(); i++) {
			predLists.add(new ArrayList<Double>());
		}
		//Read predictions
		Scanner reader = new Scanner(enhancerFile);
		int count = 0;
		while (reader.hasNextLine() && (maxRows == 0 || count < maxRows)) {
			String[] tokens = reader.nextLine().trim().split("\t");
			if (tokens.length > 1) {
				List<Double> preds = new ArrayList<Double>(tokens.length - 1);
				for (int i = 1; i < tokens.length; i++) {
					preds.add(Double.parseDouble(tokens[i]));
				}				
				//names.size() should equal preds.size(), but we ignore any predictions
				//we have over the number of species.
				if (preds.size() < speciesNames.size()) {
					reader.close();
					throw new InputMismatchException("Fewer predictions than species");
				}
				for (int i = 0; i < speciesNames.size(); i++) {
					predLists.get(i).add(preds.get(i));
				}
				count++;
			}
		}
		
		//Make PredVectors
		for (int i = 0; i < speciesNames.size(); i++) {
			pvs.add(new PredVector(predLists.get(i), speciesNames.get(i)));
		}
		reader.close();
		return pvs;
	}
	
	/**
	 * Filters PredVectors or PVClusters to keep only those with predictions in more than threshold * (# of species) species.
	 * @param List<T extends Clusterable> allVectors, a list of PredVectors
	 * @param double threshold, the threshold to use for filtering. Should be in [0,1]
	 * @param boolean verbose, print each thing filtered? 
	 * @return List<T> filtered, a filtered subset of PredVector
	 */
	private static <T extends Clusterable> List<T> filterOverall (List<T> allVectors, double threshold, boolean verbose) {
		List<T> filtered = new ArrayList<T>();
		for (T pv : allVectors) {
			int goodCount = 0;
			for (int i = 0; i < pv.getPreds().size(); i++) {
				if (pv.isGoodPred(i)) {
					goodCount += 1;
				}
			}
			if (goodCount  > threshold * pv.getPreds().size()) {
				filtered.add(pv);
			} else if (verbose) {
				System.err.println("Filtered " + pv);
			}
		}
		return filtered;
	}
	
	/**
	 * Filters PredVectors or PVClusters to keep only those with prediction in more than threshold for each clade.
	 * Should only be used when enhancers were read row-wise.
	 * @param List<T extends Clusterable> allVectors, a list of PredVectors or PVClusters
	 * @param double threshold, the threshold to sue for filtering. Should be in [0,1].
	 * @param List<String> speciesNames, the species corresponding to each element of the enhancer predictions
	 * @param Map<String, String>, a map from species to clade names.
	 * @param boolean verbose, print each thing filtered? 
	 * @return List<T> filtered, a filtered subset of PredVector
	 * @throws FileNotFoundException
	 */
	private static <T extends Clusterable> List<T> filterByClade(List<T> allVectors, double threshold, List<String> speciesNames, Map<String, String> cladeMap, boolean verbose) throws FileNotFoundException {				
		//Do filtering
		List<T> filtered = new ArrayList<T>();
		for (T pv : allVectors) {
			Map<String, Integer> cladePreds = new HashMap<String, Integer>();
			Map<String, Integer> cladeCounts = new HashMap<String, Integer>();
			for (int i = 0; i < pv.getPreds().size(); i++) {
				if (i < speciesNames.size()) {
					String clade = cladeMap.get(speciesNames.get(i));
					if (!cladePreds.containsKey(clade)) {
						cladePreds.put(clade, 0); //# with predictions
						cladeCounts.put(clade, 0); //Total #
					}
					cladeCounts.put(clade, cladeCounts.get(clade) + 1);
					cladePreds.put(clade, cladePreds.get(clade) + (pv.isGoodPred(i) ? 1 : 0));
				}
			}
			boolean keep = true;
			for (String clade : cladeCounts.keySet()) {
				if (cladePreds.get(clade) <= threshold * cladeCounts.get(clade)) {
					keep = false;
				}
			}
			if (keep) {
				filtered.add(pv);
			} else if (verbose) {
				System.err.println("Filtered " + pv);
			}
		}
		return filtered;
	}
	
	/**
	 * Reads a list of species names, one per line from a file.
	 * Technically, can be used to read generic strings.
	 * @param File speciesFile, a file where species are listed as the first column of each line.
	 * @return List<String> names, a list of species names.
	 * @throws FileNotFoundException
	 */
	private static List<String> readSpeciesNames(File speciesFile) throws FileNotFoundException{
		List<String> names = new ArrayList<String>();
		Scanner reader = new Scanner(speciesFile);
		while (reader.hasNextLine()) { //Read each species
			String[] tokens = reader.nextLine().trim().split("\t");
			if (tokens.length > 0) {
				names.add(tokens[0]);
			}	
		}
		reader.close();
		return names;
	}
	
	/**
	 * Reads a map of species to clades from a file
	 * Should only be used when enhancers were read row-wise.
	 * @param File cladeFile, a file (with a header line) where the species and their clades
	 *                        are given in columns 2 and 4, respectively.
	 * @return List<String, String> cladeMap, a map from species to clades
	 * @throws FileNotFoundException
	 */
	private static Map<String, String> readCladeMap(File cladeFile) throws FileNotFoundException{
		Map<String, String> cladeMap = new HashMap<String, String>();
		Scanner reader = new Scanner(cladeFile);
		if (reader.hasNextLine()) reader.nextLine();
		while (reader.hasNextLine()) {
			String[] tokens = reader.nextLine().trim().split("\t");
			if (tokens.length > 3) {
				cladeMap.put(tokens[1].replace('_',  ' '), tokens[3]);
			}
		}
		reader.close();
		return cladeMap;
	}
	
	
	/**
	 * @param args
	 * @throws IOException 
	 * @throws ExecutionException 
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws IOException, InterruptedException, ExecutionException {
		Options opts = new Options();
		new CommandLine(opts).parseArgs(args);

		if (opts.helpRequested) {
			CommandLine.usage(opts, System.out);
			System.exit(0);
		}
		
		//Convert some arguments to more useful forms
		boolean rows = !opts.columns;
		double inputFilterThresh = opts.inputThresholds[0];
		double inputCladeFilterThresh = rows && opts.inputThresholds.length == 2 && opts.cladeFiles != null
										? opts.inputThresholds[1] : 0.0;
		double centerFilterThresh = opts.exclKArgs != null ? opts.exclKArgs.centerThresholds[0] : 0.0;
		double centerCladeFilterThresh = opts.exclKArgs != null && opts.exclKArgs.centerThresholds.length == 2 && opts.cladeFiles != null 
	                                     ? opts.exclKArgs.centerThresholds[1] : 0.0;
		double outputFilterThresh = opts.outputThresholds[0];
		double outputCladeFilterThresh = rows && opts.outputThresholds.length >= 2 && opts.cladeFiles != null
										? opts.outputThresholds[1] : 0.0;
	    Map<String, String> cladeMap = opts.cladeFiles != null ? readCladeMap(opts.cladeFiles.cladeFile) : null;
	    List<String> speciesNames = opts.cladeFiles != null ? readSpeciesNames(opts.cladeFiles.speciesFile) : null;
	    
	    int kMeansMaxIts = opts.kMeansMaxIts;
	    	    
	    //Set globals
	    metric = opts.metric;
	    lowThresh = opts.lowThresh;
	    highThresh = opts.highThresh;
	    
	    switch (opts.wardFnType) {
	    case square:
	    	wardFn = x -> Math.pow(x,  2);
	    	break;
	    case ident:
	    	wardFn = x -> x;
	    	break;
	    case sqrt:
	    	wardFn = x -> Math.sqrt(x);
	    	break;
	    case tan:
	    	wardFn = x -> Math.tan(x);
	    	break;
	    default:
	    	throw new UnsupportedOperationException("Specified function is not implemented.");
	    }
	    
		//Do stuff
		List<PredVector> inputVectors = new ArrayList<PredVector>();
		if (rows) inputVectors = parseInputRows(opts.inputFile, opts.maxRows);
		else inputVectors = parseInputColumns(opts.inputFile, speciesNames, opts.maxRows);
		System.err.println("Read in " + inputVectors.size() + " enhancers");
		
		if (inputFilterThresh > 0) {
			inputVectors = filterOverall(inputVectors, inputFilterThresh, opts.filterVerbose);
			System.err.println(inputVectors.size() + " enhancers remaining after overall filtering w/ threshold " + inputFilterThresh);
		} 
		if (inputCladeFilterThresh > 0) {
			inputVectors = filterByClade(inputVectors, inputCladeFilterThresh, speciesNames, cladeMap, opts.filterVerbose);
			System.err.println(inputVectors.size() + " enhancers remaining after clade-based filtering w/ threshold " + inputCladeFilterThresh);
		}
		
		if (opts.sample > 0 && opts.sample < inputVectors.size()) {
			Collections.shuffle(inputVectors);
			inputVectors = inputVectors.subList(0,opts.sample);
		}
		
		
		List<PVCluster> results;
		if (opts.kMeansClusters > 0) {
			List<PredVector> centerVectors = inputVectors;
			if (centerFilterThresh > inputFilterThresh) {
				centerVectors = filterOverall(centerVectors, centerFilterThresh, false);
				System.err.println(centerVectors.size() + " center-eligible enhancers remaining after overall filtering w/ threshold " + centerFilterThresh);
			} 
			if (centerCladeFilterThresh > inputCladeFilterThresh) {
				centerVectors = filterByClade(centerVectors, centerCladeFilterThresh, speciesNames, cladeMap, opts.filterVerbose);
				System.err.println(centerVectors.size() + " center-eligible enhancers remaining after clade-based filtering w/ threshold " + centerCladeFilterThresh);
			}
			results = kMeans(inputVectors, centerVectors, opts.kMeansClusters, kMeansMaxIts, opts.exclKArgs != null ? opts.exclKArgs.kpp : false, opts.kMeansRandom, opts.nproc);
			System.err.println("Produced " + results.size() + " clusters with k-means.");
		} else {
			results = clusterize(inputVectors);	
		}
		
		if (opts.wardClusters > 0) {
			System.err.println("Starting Ward clustering");
			if (opts.treatKClustersAsClusters) wardMerge(results, opts.wardClusters, opts.nproc);
			else results = wardCluster(results, opts.wardClusters, opts.nproc);
		}
		
		if (outputFilterThresh > 0) {
			results = filterOverall(results, outputFilterThresh, opts.filterVerbose);
			System.err.println(results.size() + " clusters remaining after overall filtering w/ threshold " + outputFilterThresh);
		} 
		if (outputCladeFilterThresh > 0) {
			results = filterByClade(results, outputCladeFilterThresh, speciesNames, cladeMap, opts.filterVerbose);
			System.err.println(results.size() + " clusters remaining after clade-based filtering w/ threshold " + outputCladeFilterThresh);
		}
		
		//Basic output
		System.err.println("Writing output to " + opts.outputFile.getName());
		FileWriter output = new FileWriter(opts.outputFile);
		int clusterNumber = 1;
		for (Clusterable c : results) {
			String line = "cluster" + clusterNumber + "\t" + c.toString();
			output.write(line + "\n");
			clusterNumber++;
		}
		output.close();
		
		//Matrix output;
		if (opts.matrixOutFile != null) {
			output = new FileWriter(opts.matrixOutFile);
			for (Clusterable c : results) {
				List<String> dists = new ArrayList<String>(results.size());
				for (Clusterable d : results) {
					double dist = c.dist(d);
					if (opts.transformOutput) {
						dist = wardFn.apply(dist);
					}
					dists.add(Double.toString(dist));
				}
				String line = String.join(",", dists);
				output.write(line + "\n");
			}
			output.close();
		}
				
		System.err.println("Finished.");
		System.exit(0);
	}

}
