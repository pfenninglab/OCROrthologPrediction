package cluster;

import java.util.ArrayList;
import java.util.List;

public abstract class Clusterable {
	public abstract double getPred(int i);
	public abstract List<Double> getPreds();
	public abstract double getMeanPred();
	public abstract List<Clusterable> getPVList();
	public abstract void setCluster(PVCluster c);
	public abstract PVCluster getCluster();
	
	
	public double dist(Clusterable other) {
		double d = 0;
		double e = Math.pow(2, -32);
		switch(Main.metric) {
		case pearson:
			d = distPearson(other);
			break;
		case cosine:
			d = distCosine(other);
			break;
		case jaccard:
			d = distJaccard(other);
			break;
		case taxicab:
			d = distTaxicab(other);
			break;
		case euclid:
			d = distEuclid(other);
			break;
		case euclidvar:
			d = distEuclidVar(other);
			break;
		case minkowski3:
			d = distMinkowski3(other);
			break;
		default:
			throw new UnsupportedOperationException("Specified metric is not implemented.");
		}
		//Fixes a bug where we were getting a very small negative number instead of 0
		return Math.abs(d) < e ? 0.0 : d;		
	}
	
	private int getIntersect(Clusterable other, List<Double> thisInt, List<Double> otherInt) {
		
		int intSize = 0;
		for (int i = 0; i < getPreds().size(); i++) {
			if (getPred(i) >= 0 && other.getPred(i) >= 0) {
				intSize++;
				thisInt.add(getPred(i));
				otherInt.add(other.getPred(i));				
			}
		}
		return intSize;
	}
	
	public double distPearson(Clusterable other) {
		int len = getPreds().size();
		if (len != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		int intSize = getIntersect(other, thisInt, otherInt);
		if (intSize == 0) {
			//System.err.println("No intersection with which to find a correlation");
			return 1;
		}
		double thisMean = getMeanPred();
		double otherMean = other.getMeanPred();
		double pNum = 0;
		for (int i = 0; i < intSize; i++) {
			pNum += (thisInt.get(i) - thisMean) * (otherInt.get(i) - otherMean);		
		}
		double thisVar = 0, otherVar = 0;
		for (int i = 0; i < intSize; i++) {
			thisVar += Math.pow(thisInt.get(i) - thisMean, 2);
			otherVar += Math.pow(otherInt.get(i) - otherMean, 2);		
		}
		//For now, just convert so smaller # = closer
		//Should be proportional-ish to Euclidean Distance
		//Scaled from 0 to 1
		return (1 - (pNum / (Math.sqrt(thisVar) * Math.sqrt(otherVar)))) / 2;
	}
	
	public double distCosine(Clusterable other) {
		int len = getPreds().size();
		if (len != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		int intSize = getIntersect(other, thisInt, otherInt);
		if (intSize == 0) {
			//System.err.println("No intersection with which to find a correlation");
			return 1;
		}
		double dot = 0;
		double thisMag = 0;
		double otherMag = 0;
		for (int i = 0; i < intSize; i++) {
			dot += thisInt.get(i) * otherInt.get(i);
			thisMag += thisInt.get(i) * thisInt.get(i);
			otherMag += otherInt.get(i) * otherInt.get(i);
		}
		thisMag = Math.sqrt(thisMag);
		otherMag = Math.sqrt(otherMag);
		//For now, just convert so smaller # = closer
		return 1.0 - (dot / (thisMag * otherMag));
		
	}
	
	public boolean isGoodPred(int i) {
		double pred = getPred(i);
		return pred != -1 && (pred < Main.lowThresh || pred > Main.highThresh);	
	}
	
	public double distJaccard(Clusterable other) { 
		if (getPreds().size() != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		int len = getPreds().size();
		int intSize = 0;
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		for (int i = 0; i < len; i++) {
			if (isGoodPred(i) && other.isGoodPred(i)) {
				intSize++;
				thisInt.add(getPred(i));
				otherInt.add(other.getPred(i));				
			}
		}
		if (intSize == 0) {
			//System.err.println("No intersection with which to find Jaccard" + this.toString() + other.toString());
			return 1.0;
		}
		double bothOneCount = 0.0;
		double oneOneCount = 0.0;
		for (int i = 0; i < intSize; i++) {
			if (thisInt.get(i) > Main.highThresh || otherInt.get(i) > Main.highThresh) {
				oneOneCount += 1.0;
			}
			if (thisInt.get(i) > Main.highThresh && otherInt.get(i) > Main.highThresh) {
				bothOneCount += 1.0;
			}
		}
		if (oneOneCount == 0.0) oneOneCount = 1.0; //Avoid divide by 0
		//For now, just convert so smaller # = closer
		//Should be proportional-ish to Euclidean Distance
		return 1.0 - (bothOneCount / oneOneCount);
	}
	
	//Returns normalized taxicab distance
	public double distTaxicab(Clusterable other) {
		int len = getPreds().size();
		if (len != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		int intSize = getIntersect(other, thisInt, otherInt);
		if (intSize == 0) {
			//System.err.println("No intersection with which to find a correlation");
			return 1;
		}
		double dist= 0.0;
		for (int i = 0; i < intSize; i++) {
			dist += Math.abs(otherInt.get(i) - thisInt.get(i));
		}
		return dist / intSize;
	}
	
	//Returns normalized Euclidean distance
	//Caution: for mult != 1, does NOT produce distances in [0,1]
	public double distEuclid(Clusterable other) {
		int len = getPreds().size();
		if (len != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		int intSize = getIntersect(other, thisInt, otherInt);
		if (intSize == 0) {
			//System.err.println("No intersection with which to find a correlation");
			return 1;
		}
		double distSq = 0.0;
		for (int i = 0; i < intSize; i++) {
			distSq += Math.pow((otherInt.get(i) - thisInt.get(i)), 2);
		}
		return Math.sqrt(distSq / intSize); //Dividing within the sqrt properly normalizes
	}
	
	public double distEuclidVar(Clusterable other) {
		int len = getPreds().size();
		if (len != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		int intSize = getIntersect(other, thisInt, otherInt);
		if (intSize == 0) {
			//System.err.println("No intersection with which to find a correlation");
			return 1;
		}
		double distSq = 0.0;
		for (int i = 0; i < intSize; i++) {
			distSq += Math.pow((otherInt.get(i) - thisInt.get(i)) + 0.5, 2);
		}
		return Math.sqrt(distSq / intSize); //Dividing within the sqrt properly normalizes
	}
	
	public double distMinkowski3(Clusterable other) {
		int len = getPreds().size();
		if (len != other.getPreds().size()) {
			throw new IllegalArgumentException("Vectors must have the same length");	
		}
		List<Double> thisInt = new ArrayList<Double>(len);
		List<Double> otherInt = new ArrayList<Double>(len);
		int intSize = getIntersect(other, thisInt, otherInt);
		if (intSize == 0) {
			//System.err.println("No intersection with which to find a correlation");
			return 1;
		}
		double distSq = 0.0;
		for (int i = 0; i < intSize; i++) {
			distSq += Math.abs(Math.pow((otherInt.get(i) - thisInt.get(i)), 3));
		}
		return Math.cbrt(distSq / intSize); //Dividing within the cbrt properly normalizes
	}
}
