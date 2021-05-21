package cluster;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Defines a cluster of other Clusterables (PredVectors or other PVClusters).
 * @author Daniel Schaffer
 */
public class PVCluster extends Clusterable{
    private List<Clusterable> pvs;
    private List<Double> center;
    double variance;
    private PVCluster cluster;
	
    //Just adds c; doesn't look at the contents of c
    //Doesn't matter if c is a PredVector
    public PVCluster(Clusterable c) {
    	pvs = new ArrayList<Clusterable>();
    	pvs.add(c);
    	c.setCluster(this);
    	updateCenter();
    	cluster = null;
    }
    
    /**
	 * 
	 */
	public PVCluster() {
		pvs = new ArrayList<Clusterable>();
		center = new ArrayList<Double>();
		cluster = null;
	}
	
	public double withinVariance() {
		return variance;
	}
	
	public boolean isEmpty() {
		return pvs.size() == 0;
	}
	
	@Override
	public double getPred(int i) {
		return center.get(i);
	}
	
	@Override
	public List<Double> getPreds() {
		return center;		
	}
	

//	@Override
	public void merge(Clusterable other, boolean update) {
		List<Clusterable> others = other.getPVList();
		for (Clusterable c: others) {
			c.setCluster(this);
		}
		pvs.addAll(other.getPVList()); //Not checked that all vectors are the same length
		if (update) {
			updateCenter();
		}
	}
	
	public PVCluster mergedCopy(Clusterable other) {
		PVCluster merged = new PVCluster();
		merged.merge(this, false);
		merged.merge(other,  true);
		return merged;
	}
	
	public void remove(Clusterable other, boolean update) {
		pvs.removeAll(other.getPVList()); //Not checked that all vectors are the same length
		if (update) {
			updateCenter();
		}
	}
	
	@Override
	public double getMeanPred() {
		double sum = 0, count = 0;
		for (double f : center) {
			if (f >= 0) {
				sum += f;
				count++;
			}
		}
		return sum / count;
	}

	//Aliases
	@Override
	public List<Clusterable> getPVList() {
		return pvs;
	}
	
	public void updateCenter() {
		if (pvs.size() == 0) { //i.e. everything was removed
			center = new ArrayList<Double>(Collections.nCopies(center.size(), -1.0));
			return;
		}
		if (center == null) {
			center = new ArrayList<Double>();
		}
		if (center.size() == 0) {
			center.addAll(Collections.nCopies(pvs.get(0).getPreds().size(), -1.0)); //Set length so updating works
		}
		for (int i = 0; i < center.size(); i++) {
			double sum = 0, count = 0;
			for (Clusterable pv : pvs) {
				if (Main.metric == Metric.jaccard) {
					if (pv.isGoodPred(i)) {
					    sum += Math.round(pv.getPred(i));
					    count ++;
					} 
				} else if (pv.getPred(i) >= 0) {
					sum += pv.getPred(i);
					count ++;
				}
					
			}
			if (Main.metric == Metric.jaccard) {
				//Use majority voting to merge
				if (count == 0) {
					center.set(i, -1.0);
				} else if (sum > count / 2) {
					center.set(i, 1.0);
				} else if (sum < count / 2) {
					center.set(i, 0.0);
				} else { //Exact tie
					center.set(i,  0.5);
				}
			} else {
				center.set(i, count == 0 ? -1.0 : sum / count);
			}
		}
		//Fake, so we can use dist() method
		PredVector centerPV = new PredVector(center, "dummy");
		for (Clusterable pv : pvs) {
			variance += Main.wardFn.apply(centerPV.dist(pv));
		}
	}
	
	public void setCluster(PVCluster c) {
		cluster = c;
	}
	
	public PVCluster getCluster() {
		return cluster;
	}
	
	@Override
	public String toString() {
		List<String> pvNames = pvs.stream().map( i -> i.toString()).collect(Collectors.toList());
		return String.join("\t", pvNames);
	}

}
