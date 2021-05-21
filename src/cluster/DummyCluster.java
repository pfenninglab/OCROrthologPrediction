package cluster;

/**
 * This represents a "fake" PVCluster that is used when something needs to be initialized
 * but should always be rewritten. It always has maximum distance (2) from another Clusterable.
 * @author Daniel Schaffer
 */
public class DummyCluster extends PVCluster {

	public DummyCluster() {
		super();
	}
	
	@Override
	public double dist(Clusterable other) { 
		return 2;
	}
	
	@Override
	public void merge(Clusterable other, boolean update) {
		throw new UnsupportedOperationException("Cannot merge with a dummy cluster");
	}

	public void remove(Clusterable other, boolean update) {
		throw new UnsupportedOperationException("Cannot merge with a dummy cluster");
	}
}
