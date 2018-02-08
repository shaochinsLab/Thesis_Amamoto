class Job{
    int index ;
    int machineNumber ;
    int releaseDate ;
    int[] processingTime ;
    Job(int i){
	index = i ;
    }
    Job(int i, int m){
	index = i ;
	releaseDate= (int)random(0, 50) ;
	processingTime = new int[m] ;
	for(int j = 0 ; j < m ; j++)
	    processingTime[j] = (int)random(1, 50) ;
    }
    Job(int i, int rd, int[] pt) {
	index = i ;
	releaseDate = rd ;
	processingTime = new int[pt.length] ;
	for(int j = 0 ; j < pt.length ; j++)
	    processingTime[j] = pt[j] ;
    }
    int getStartTime(int completionTime){
	return max(completionTime, releaseDate) ;
    }
    String toString() {
	String str = "\n" + "index : " + index + "\nreleaseDate : " + releaseDate
	    + "\nprocessing time : " ;
	for(int i = 0 ; i < processingTime.length ; i++)
	    str += (processingTime[i] + " ") ;
	return str + "\n" ;
    }
}

class JobSet extends ArrayList<Job>{
    JobSet(){
    }
    JobSet(int n, int m){
	for(int i = 0 ; i < n ; i ++)
	    add(new Job(i, m)) ;
	sortByReleaseDate() ;
    }
    void sortByReleaseDate() {
	for(int i = 0 ; i < size() - 1 ; i++){
	    Job minJob = get(i) ;
	    int minIndex = i ;
	    for(int j = i + 1 ; j < size() ; j++){
		Job tmpJob = get(j) ;
		if(minJob.releaseDate > tmpJob.releaseDate){
		    minIndex = j ;
		    minJob = tmpJob ;
		}
	    }
	    if (minIndex == i) continue ;
	    remove(minIndex) ;
	    add(i, minJob) ;
	}
	for(int i = 0 ; i < size() ; i++)
	    get(i).index = i ;
    }
    void showInfo(){
	print("machine " + get(0).machineNumber + " : p : ( ") ;
	for(int i = 0 ; i < size() ; i++)
	    print(get(i).index + " ") ;
	print(")") ;
	
    }
}
