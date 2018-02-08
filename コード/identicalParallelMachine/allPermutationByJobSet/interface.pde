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
    	    jobs.add(new Job(i - 1, data[1], data[2])) ;
    	}
    	jobs.sortByReleaseDate() ;
    	return jobs ;
    }
    void writeFile(Instance instance){
	PrintWriter output = createWriter("data/Instance.csv") ;
    	output.println("index,releaseDate,processingTime") ;
    	for(int i = 0 ; i < instance.jobs.size() ; i++){
    	    output.print(i + ",") ;
    	    output.print(instance.jobs.get(i).releaseDate + ",") ;
    	    output.println(instance.jobs.get(i).processingTime + ",") ;
    	}
    	output.flush() ;
    	output.close() ;
    }
}

