class Interface{
    Interface(){
    } 
    void showInfo(Instance instance){
	println("\n------optimal solution------") ;
	print("best partition : ( ") ;
	for(int i = 0 ; i < instance.bestPartition.length ; i++)
	    print(instance.bestPartition[i] + " ") ;
	println(")") ;
	for(int i = 0 ; i < instance.bestPermutation.length ; i++){
	    print("machine " + i  + " ,  p : ( ") ;
	    for(int j = 0 ; j < instance.bestPermutation[i].size() ; j++){
		print(instance.bestPermutation[i].get(j).index + " ") ;
	    }
	    println(")") ;
	}
	println("bestValue = " + instance.bestValue) ;
	println("------------------------------") ;
    }
    JobSet loadJobs(String filename){
    	String[] lines = loadStrings(filename) ;
    	JobSet jobs = new JobSet() ;
    	for(int i = 1 ; i < lines.length ; i++){
    	    int[] data = int(split(lines[i] , ",")) ;
	    int[] pt = new int[data.length - 2] ;
	    for(int j = 2 ; j < data.length ; j++)
		pt[j - 2] = data[j] ;
    	    jobs.add(new Job(i - 1, data[1], pt)) ;
    	}
    	jobs.sortByReleaseDate() ;
    	return jobs ;
    }
    void writeFile(Instance instance){
    	PrintWriter output = createWriter("data/Instance.csv") ;
    	output.println("index,releaseDate,processingTime") ;
    	for(int i = 0 ; i < instance.jobs.size() ; i++){
	    JobSet jobs = instance.jobs ;
    	    output.print(i + ",") ;
	    output.print(jobs.get(i).releaseDate + ",") ;
    	    for(int j = 0 ; j < jobs.get(i).processingTime.length - 1 ; j++)
		output.print(jobs.get(i).processingTime[j] + ",") ;
	    output.println(jobs.get(i).processingTime[jobs.get(i).processingTime.length - 1]) ;
    	}
    	output.flush() ;
    	output.close() ;
    }
}

