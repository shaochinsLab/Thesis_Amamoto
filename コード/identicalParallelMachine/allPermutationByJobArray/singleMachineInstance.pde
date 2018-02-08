class SingleMachineInstance{
    int bestValue ;
    Job[] jobs ;
    Job[] bestPermutation ;
    SingleMachineInstance(){
    }
    SingleMachineInstance(int numOfJobs){
	bestValue = Integer.MAX_VALUE ;
	this.jobs = new Job[numOfJobs] ;
	bestPermutation = new Job[jobs.length] ;
    }
    void branchAndBound(List list, int i, int completionTime, int waitingTime){
	if(i == this.jobs.length){
	    bestValue = waitingTime ;
	    bestPermutation = (Job[])jobs.clone() ;
	}else{
	    for(Item a = list.head.next ; a != list.head ; a = a.next){
		jobs[i] = a.job ;
		int s = max(completionTime, a.job.releaseDate) ;
		int c = s + a.job.processingTime ;
		int w = max(waitingTime, s - a.job.releaseDate) ;
		list.remove(a) ;
		if(evaluation(list, c, w))
		    branchAndBound(list, i + 1, c, w) ;
		list.restore(a) ;
	    }
	}
    }
    int minCost(List list){
	int s = 0 ;
	int c = 0 ;
	int w = 0 ;
	int minProcessingTime = list.minProcessingTime() ;
	for(Item a = list.head.next ; a != list.head ; a = a.next){
	    s = max(c, a.job.releaseDate) ;
	    c = s + minProcessingTime ;
	    w = max(s - a.job.releaseDate, w) ;
	}
	return w ;
    }
    boolean evaluation(List list, int completionTime, int waitingTime){
	int s = 0 ;
	int c = completionTime ;
	int w = waitingTime ;
	int minProcessingTime = list.minProcessingTime() ;
	for(Item a = list.head.next ; a != list.head ; a = a.next){
	    s = max(c, a.job.releaseDate) ;
	    c = s + minProcessingTime ;
	    w = max(s - a.job.releaseDate, w) ;
	    if(bestValue <= w) return false ;
	}
	return true ;
    }
}
