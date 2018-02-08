class Instance {
    Job[] jobs ;  
    int numOfMachines ;  //機械数
    int bestValue ;  //最適解
    int[] bestPartition ;
    int[] machineBestValue ;  //ある分割に対する機械ごとのスケジュールのbestValueを入れておく配列
    Job[][] permutation ;  //ある分割に対する機械ごとのスケジュールを入れておく配列
    Job[][] bestPermutation ;  //最適なスケジュール
    Instance(int n, int m) {
	jobs = new Job[n] ;
	for(int i = 0 ; i < n ; i++)
	    jobs[i] = new Job(i) ;
	sortByReleaseDate(jobs) ;
	numOfMachines = m ;
	bestValue = Integer.MAX_VALUE ;
	bestPartition = new int[n] ;
	machineBestValue = new int[m] ;
	for(int i = 0 ; i < m ; i++)
	    machineBestValue[i] = Integer.MAX_VALUE ;
	permutation = new Job[m][] ;
	bestPermutation = new Job[m][] ;
    }
    Instance(Job[] jobs, int m){
	this.jobs = (Job[])jobs.clone() ;
	sortByReleaseDate(this.jobs) ;
	numOfMachines = m ;
	bestValue = Integer.MAX_VALUE ;
	bestPartition = new int[this.jobs.length] ;
	machineBestValue = new int[m] ;
	for(int i = 0 ; i < m ; i++)
	    machineBestValue[i] = Integer.MAX_VALUE ;
	permutation = new Job[m][] ;
	bestPermutation = new Job[m][] ;
    }
    void setInitialSolution(){  //初期解の設定（貪欲解法で求めた解を設定）
	JobSet[] jobSet = new JobSet[numOfMachines] ;
	int[] completionTime = new int[numOfMachines] ;
	int[] waitingTime = new int[numOfMachines] ;
	for(int i = 0 ; i < numOfMachines ; i++){
	    jobSet[i] = new JobSet() ;
	    completionTime[i] = 0 ;
	    waitingTime[i] = 0 ;
	}
	for(int i = 0 ; i < this.jobs.length ; i++){
	    int machineNumber = 0 ; 
	    int min = completionTime[0] ;
	    for(int j = 1 ; j < completionTime.length ; j++){ 
		if(completionTime[j] < min){
		    min = completionTime[j] ;
		    machineNumber = j ;
		}
	    }
	    bestPartition[i] = machineNumber ;
	    jobSet[machineNumber].add(jobs[i]) ;
	    int startTime = max(jobs[i].releaseDate, completionTime[machineNumber]) ;
	    completionTime[machineNumber] = startTime + jobs[i].processingTime ;
	    waitingTime[machineNumber]
		= max(waitingTime[machineNumber], startTime - jobs[i].releaseDate) ;
	}
	int max = Integer.MIN_VALUE ;
	for(int i = 0 ; i < waitingTime.length ; i++)
	    if(max < waitingTime[i])
		max = waitingTime[i] ;
	bestValue = max ;
	for(int i = 0 ; i < bestPermutation.length ; i++){
	    bestPermutation[i] = new Job[jobSet[i].size()] ;
	    for(int j = 0 ;  j < bestPermutation[i].length ; j++)
		bestPermutation[i][j] = jobSet[i].get(j) ;
	}
    }
    void getPartition(){  //分割を設定し，各分割に対して単一機械でのインスタンスを作る
	RestricedGrowthFunction rgf = new RestricedGrowthFunction(jobs.length, numOfMachines) ;
	int[] order = new int[numOfMachines] ;
	for(int i = 0 ; i < order.length ; i++)
	    order[i] = i ;
	do{
	    if(firstEvaluation(rgf, order))
		getSingleMachineInstance(rgf, order) ;
	}
	while(rgf.increment()) ;
    }
    boolean firstEvaluation(RestricedGrowthFunction rgf, int[] order){
	int[] minCost = new int[numOfMachines] ;
	for(int i = 0 ; i < rgf.body.length ; i++)
	    this.jobs[i].machineNumber = rgf.body[i] ;
	for(int i = 0 ; i < rgf.upperLimit + 1 ; i++){
	    int numOfJobs = 0 ;
	    List list = new List() ;
	    for(int j = 0 ; j < this.jobs.length ; j++){
		if(this.jobs[j].machineNumber == i){
		    list.add(new Item(this.jobs[j])) ;
		    numOfJobs++ ;
		}
	    }
	    SingleMachineInstance si = new SingleMachineInstance(numOfJobs) ;
	    minCost[i] = si.minCost(list) ;
	}
	sort(order, minCost) ;
	for(int i = 0 ; i < numOfMachines ; i++)
	    if(bestValue <= minCost[i]) return false ;
	return true ;
    }
    void getSingleMachineInstance(RestricedGrowthFunction rgf, int[] order){  
	for(int i = 0 ; i < order.length ; i++){
	    int numOfJobs = 0 ;
	    List list = new List() ;
	    for(int j = 0 ; j < this.jobs.length ; j++){
		if(this.jobs[j].machineNumber == order[i]){
		    list.add(new Item(this.jobs[j])) ;
		    numOfJobs++ ;
		}
	    }
	    SingleMachineInstance si = new SingleMachineInstance(numOfJobs) ;
	    si.branchAndBound(list, 0, 0, 0) ;
	    if(bestValue < si.bestValue) break ; //次の機械への割り当てを中断
	    machineBestValue[order[i]] = si.bestValue ;
	    permutation[order[i]] = si.bestPermutation ;
	}
	updateBestPermutation(rgf) ;
    }
    int getPartitionBestValue(){
	int partitionBestValue = Integer.MIN_VALUE ;
	for(int i = 0 ; i < numOfMachines ; i++)
	    if(partitionBestValue < this.machineBestValue[i])
		partitionBestValue = this.machineBestValue[i] ;
	return partitionBestValue ;
    }
    void updateBestPermutation(RestricedGrowthFunction rgf){
	int partitionBestValue = getPartitionBestValue() ;
	if(partitionBestValue < bestValue){
	    bestPartition = (int[])rgf.body.clone() ;
	    bestValue = partitionBestValue ;
	    for(int i = 0 ; i < numOfMachines ; i++)
		bestPermutation[i] = (Job[])permutation[i].clone() ;
	}
	this.machineBestValue = new int[numOfMachines] ;
	for(int i = 0 ; i < numOfMachines ; i++)
	    this.machineBestValue[i] = Integer.MAX_VALUE ;
	permutation = new Job[numOfMachines][] ;
    }
    void sortByReleaseDate(Job[] js){
	for(int i = 0 ; i < js.length - 1 ; i++){
	    for(int j = i + 1 ; j < js.length ; j++){
		if(js[i].releaseDate > js[j].releaseDate){
		    Job tmp = js[j] ;
		    js[j] = js[i] ;
		    js[i] = tmp ;
		}
	    }
	}
	for(int i = 0 ; i < js.length ; i++)
	    js[i].index = i ;
    }
    void sort(int[] order, int[] array){
	for(int i = 0 ; i < array.length - 1 ; i++){
	    for(int j = i + 1 ; j < array.length ; j++){
		if(array[i] < array[j]){
		    int tmp = order[j] ;
		    order[j] = order[i] ;
		    order[i] = tmp ;
		}
	    }
	}
    }
}
