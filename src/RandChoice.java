/**
 * 
 */
package cluster;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

/**
 * @author Daniel Schaffer
 * A partial port of the random.choices function from Python
 */
public class RandChoice {
	
	/**
	 * Chooses a random integer in [0,max) based on an arbitrary probability distribution
	 * Based on the python function random.choices, but restricted to 1) returning an int
	 * and 2) a non-cumulative probability distribution
	 * 
	 * @param gen A source of randomness
	 * @param max The (exclusive) max integer to choose
	 * @param weights A list of probabilities for each i in [0,max)
	 * @return a random integer in [0,max) based on weights
	 */
	public static int randChoice(Random gen, int max, List<Double> weights) {
		int hi = weights.size() - 1;
		//Make weights cumulative
		List<Double> cumWeights = new ArrayList<Double>(weights.size());
		double prevSum = 0;
		for (double w : weights) {
			prevSum += w;
			cumWeights.add(prevSum);
		}
		int binSearchResult = Collections.binarySearch(cumWeights.subList(0, hi), gen.nextDouble() * cumWeights.get(hi));
		int insertionPoint = -binSearchResult - 1;
		return insertionPoint;
		
	}

}
