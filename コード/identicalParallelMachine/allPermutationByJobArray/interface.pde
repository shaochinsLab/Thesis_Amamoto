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
	    for(int j = 0 ; j < instance.bestPermutation[i].length ; j++){
		print(instance.bestPermutation[i][j].index + " ") ;
	    }
	    println(")") ;
	}
	println("bestValue = " + instance.bestValue) ;
	println("------------------------------") ;
    }
    Job[] loadJobs(String filename){
    	String[] lines = loadStrings(filename) ;
    	Job[] jobs = new Job[lines.length - 1] ;
    	for(int i = 1 ; i < lines.length ; i++){
    	    int[] data = int(split(lines[i] , ",")) ;
    	    jobs[i - 1] = new Job(i - 1, data[1], data[2]) ;
    	}
    	return jobs ;
    }
    void writeFile(Instance instance){
    	PrintWriter output = createWriter("data/Instance.csv") ;
    	output.println("index,releaseDate,processingTime") ;
    	for(int i = 0 ; i < instance.jobs.length ; i++){
    	    output.print(i + ",") ;
    	    output.print(instance.jobs[i].releaseDate + ",") ;
    	    output.println(instance.jobs[i].processingTime + ",") ;
    	}
    	output.flush() ;
    	output.close() ;
    }
}
