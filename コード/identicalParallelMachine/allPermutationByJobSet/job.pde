class Job{
    int index ;
    int machineNumber ;
    int releaseDate ;
    int processingTime ;
    Job(int i){
	this(i, (int)random(0, 50), (int)random(1, 10)) ;
    }
    Job(int i, int rd, int pt) {
	index = i ;
	releaseDate = rd ;
	processingTime = pt ;
    }
    int getStartTime(int completionTime){
	return max(completionTime, releaseDate) ;
    }
    String toString() {
	return "\n" + "index : " + index + "\n" +
	    "release date : " + releaseDate + "\n" +
	    "processing time : " + processingTime + "\n" ;
    }
}

class JobSet extends ArrayList<Job>{
    JobSet(){
    }
    JobSet(int n) {
	for (int i = 0 ; i < n ; i++)
	    add(new Job(i)) ;
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
    boolean contains(Job job){
	for(int i = 0 ; i < size() ; i++)
	    if(get(i).index == job.index)
		return false ;
	return true ;
    }
    void showInfo(){
	print("machine " + get(0).machineNumber + " : p : ( ") ;
	for(int i = 0 ; i < size() ; i++)
	    print(get(i).index + " ") ;
	print(")") ;
	
    }
}
