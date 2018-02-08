class RestricedGrowthFunction {
    int[] body ;
    int upperLimit ;
    int[] bMax ;
    RestricedGrowthFunction(int n, int m) {
	body = new int[n] ;  // 分割
	upperLimit = m - 1 ;  // 機械数の上限
	bMax = new int[n] ;  // i - 1 番目までに使った機械数
	normalize() ;
    }
    String toString() {
	return join(nf(body, 0), ",") ;
    }
    boolean increment() {
	for (int i = body.length - 1 ; i > 0 ; i--) {
	    if (body[i] == min(bMax[i] + 1, upperLimit)) {
		body[i] = 0 ;
	    }
	    else {
		body[i]++ ;
		if (body[i] > bMax[i]) {
		    for (int j = i + 1 ; j < body.length ; j++)
			bMax[j] = body[i] ;
		}
		normalize() ;
		return true ;
	    }
	}
	return false ;
    }
    void normalize() {
    	for (int j = 1 ; j < body.length ; j++) {
    	    int k = body.length - j ;
    	    int v = upperLimit + 1 - j ;
    	    if (bMax[k] >= v) break ;
    	    body[k] = v ;
    	    bMax[k] = v - 1 ;
    	}
    }
}
