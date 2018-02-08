class Assignment{
    int[] body ;
    int[] body2 ;
    int[] bMax ;
    int[] count ;
    int[] upperBound ;
    int upperLimit ;
    Assignment(int n, int m){
	body = new int[n] ;
	bMax = new int[n] ;
	count = new int[m] ;
	upperBound = new int[m] ;
	upperLimit = m - 1 ;
	for(int i = 0 ; i < m ; i++)
	    upperBound[i] = upperLimit - i ;
	normalize() ;
	body2 = (int[])body.clone() ;
    }
    String toString(){
	return join(nf(body, 0), ",") ;
    }
    boolean increment() {
	if(!shuffle()){
	    body = (int[])body2.clone() ;
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
		    body2 = (int[])body.clone() ;
		    for(int j = 0 ; j < count.length ; j++)
			count[j] = 0 ;
		    return true ;
		}
	    }
	    return false ;
	}
	else
	    return true ;
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
    boolean shuffle(){
	int[] b = (int[])body2.clone() ;
	for(int i = 0 ; i < count.length ; i++){
	    if(count[i] < upperBound[i]){
		for(int j = 0 ; j < body2.length ; j++){
		    if(body2[j] == i)
			b[j] = (upperLimit - upperBound[i]) + count[i] + 1 ; 
		    if(body2[j] == (upperLimit - upperBound[i]) + count[i] + 1)
			b[j] = i ;
		}
		body = (int[])b.clone() ;
		count[i]++ ;
		return true ;
	    }
	}
	return false ;
    }
}
