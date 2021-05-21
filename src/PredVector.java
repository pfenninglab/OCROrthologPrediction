/**
 * 
 */
package cluster;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Daniel Schaffer
 * Defines a single vector (list) of predictions, which are -1 if they are unknown.
 */
public class PredVector extends Clusterable{
    private String name;
    private List<Double> preds;
    private boolean isCenter;
    private PVCluster cluster;
    
    public PredVector(List<Double> l, String n) {
		name = n;
		preds = l;
		cluster = null;
	}
    
    /**
	 * 
	 */
	public PredVector() {
		name = "";
		preds = new ArrayList<Double>();
		cluster = null;
	}
	
	@Override
	public double getPred(int i) {
		return preds.get(i);
		
	}
	
	@Override
	public List<Double> getPreds() {
		return preds;		
	}
	
	@Override
	public List<Clusterable> getPVList() {
		List<Clusterable> l = new ArrayList<Clusterable>();
		l.add(this);
		return l;		
	}

	@Override
	public double getMeanPred() {
		double sum = 0, count = 0;
		for (double f : preds) {
			if (f >= 0) {
				sum += f;
				count++;
			}
		}
		return sum / count;
	}
	
	//Shallow copy - same list
	//Currently unused
	public PredVector clone() {
		return  new PredVector(preds, name); 
	}
	
	public void setCenter() {
		isCenter = true;
	}
	
	public boolean isCenter() {
		return isCenter;
	}
	
	public void setCluster(PVCluster c) {
		cluster = c;
	}
	
	public PVCluster getCluster() {
		return cluster;
	}
	
	@Override
	public String toString() {
		return name;
	}

}
