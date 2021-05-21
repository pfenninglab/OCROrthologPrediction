package cluster;

/**
 * Defines the pending merge of a Clusterable from one cluster to another
 * @author Daniel Schaffer
 */
public class ClusterMerge {
	private PVCluster old;
	private PVCluster rep;
	private double deltaVar;
	
	public ClusterMerge(PVCluster o, PVCluster n, double d) {
		old = o;
		rep = n;
		deltaVar = d;
	}
	
	public ClusterMerge() {
		old = new DummyCluster();
		rep = new DummyCluster();
		deltaVar = Double.MAX_VALUE;
	}
	
	//True --> old now empty
	public void merge(boolean update) {
		old.merge(rep, true);
	}
	
 	public PVCluster getMergee() {
		return old;
	}
 
	public PVCluster getMerged() {
		return rep;
	}
	
	public double getDeltaVar() {
		return deltaVar;
	}
	
	public void setDeltaVar(double d) {
		deltaVar = d;
	}
	
	public boolean isBetterThan(ClusterMerge other) {
		return this.deltaVar < other.getDeltaVar();
	}
	
	@Override
	public String toString() {
		return "Merging " + rep.toString() + " into " + old.toString();
	}
}
