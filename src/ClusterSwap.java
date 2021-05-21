package cluster;

/**
 * Defines the pending move of a Clusterable from one cluster to another
 * @author Daniel Schaffer
 */
public class ClusterSwap {
	private PVCluster old;
	private PVCluster rep;
	private Clusterable thing;
	
	public ClusterSwap(PVCluster o, Clusterable v, PVCluster n) {
		old = o;
		rep = n;
		thing = v;
	}
	
	public ClusterSwap() {
		old = new DummyCluster();
		rep = new DummyCluster();
		thing = new DummyCluster();
	}
	
	//True --> old now empty
	public void swap(boolean update) {
		if (old != null) {
			old.remove(thing, update);
		}
		rep.merge(thing, update);
	}
	
	public PVCluster getOld() {
		return old;
	}
	
	@Override
	public String toString() {
		return "Swapping " + thing.toString() + " from " + old.toString() + " to " + rep.toString();
	}
}
