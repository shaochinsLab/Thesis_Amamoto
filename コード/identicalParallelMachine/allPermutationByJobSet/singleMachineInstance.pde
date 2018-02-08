class SingleMachineInstance{
    int bestValue ;
    List list ;
    JobSet jobs ;
    JobSet bestPermutation ;
    SingleMachineInstance(){
    }
    SingleMachineInstance(JobSet jobSet, int bestValue){
	this.bestValue = bestValue ;
	jobs = (JobSet)jobSet.clone() ;
	bestPermutation = new JobSet() ;
	setList() ;
    }
    void setList(){
	List list = new List() ;
	for(int i = 0 ; i < jobs.size() ; i++)
	    list.add(new Item(jobs.get(i))) ;
	this.list = list ;
    }
    void branchAndBound(int i, int completionTime, int waitingTime){
	if(i == jobs.size()){
	    bestValue = waitingTime ;
	    bestPermutation = (JobSet)jobs.clone() ;
	}else{
	    for(Item a = list.head.next ; a != list.head ; a = a.next){
		jobs.set(i, a.job) ;
		int s = a.job.getStartTime(completionTime) ; ;
		int c = s + a.job.processingTime ;
		int w = max(waitingTime, s - a.job.releaseDate) ;
		list.remove(a) ;
		if(evaluation(c, w) < bestValue)
		    branchAndBound(i + 1, c, w) ;
		list.restore(a) ;
	    }
	}
    }
    int evaluation(int completionTime, int waitingTime){
	int s = 0 ;
	int c = completionTime ;
	int w = waitingTime ;
	int minProcessingTime = list.minProcessingTime() ;
	for(Item a = list.head.next ; a != list.head ; a = a.next){
	    s = max(c, a.job.releaseDate) ;
	    c = s + minProcessingTime ;
	    w = max(s - a.job.releaseDate, w) ;
	}
	return w ;
    }
}
