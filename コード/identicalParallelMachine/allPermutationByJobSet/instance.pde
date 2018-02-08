class Instance {
    JobSet jobs ;  
    int numOfMachines ;  //機械数
    int bestValue ;  //最適解
    int[] bestPartition ;  //最適な分割
    int[] machineBestValue ;  //ある分割に対する機械ごとのスケジュールのbestValueを入れておく配列
    JobSet[] permutation ;  //ある分割に対する機械ごとのスケジュールを入れておく配列
    JobSet[] bestPermutation ;  //最適なスケジュール
    Instance(int n, int m) {
	jobs = new JobSet(n) ;
	setStatus(n, m) ;
	setInitialSolution() ;
    }
    Instance(JobSet jobs, int m){
	this.jobs = (JobSet)jobs.clone() ;
	setStatus(jobs.size(), m) ;
	setInitialSolution() ;
    }
    void setStatus(int n, int m){
	numOfMachines = m ;
	bestValue = Integer.MAX_VALUE ;
	bestPartition = new int[n] ;
	machineBestValue = new int[m] ;
	permutation = new JobSet[m] ;
	bestPermutation = new JobSet[m] ;
	for(int i = 0 ; i < m ; i++){
	    machineBestValue[i] = Integer.MAX_VALUE ;
	    permutation[i] = new JobSet() ;
	    bestPermutation[i] = new JobSet() ;
	}
    }
    void setInitialSolution(){  //初期解の設定（貪欲解法で求めた解を設定）
	int[] completionTime = new int[numOfMachines] ;
	int[] waitingTime = new int[numOfMachines] ;
	for(int i = 0 ; i < numOfMachines ; i++){
	    completionTime[i] = 0 ;
	    waitingTime[i] = 0 ;
	}
	for(int i = 0 ; i < jobs.size() ; i++){
	    int machineNumber = 0 ; 
	    int min = completionTime[machineNumber] ;
	    for(int j = 1 ; j < completionTime.length ; j++)
		if(completionTime[j] < min){
		    min = completionTime[j] ;
		    machineNumber = j ;
		}
	    bestPartition[i] = machineNumber ;
	    bestPermutation[machineNumber].add(jobs.get(i)) ;
	    int startTime = jobs.get(i).getStartTime(completionTime[machineNumber]) ;
	    completionTime[machineNumber] = startTime + jobs.get(i).processingTime ;
	    waitingTime[machineNumber]
		= max(waitingTime[machineNumber], startTime - jobs.get(i).releaseDate) ;
	}
	int max = waitingTime[0] ;
	for(int i = 1 ; i < waitingTime.length ; i++)
	    if(max < waitingTime[i])
		max = waitingTime[i] ;
	bestValue = max ;
    }
    void getPartition(){  //分割を設定し，各分割に対して単一機械でのインスタンスを作る
	if(bestValue == 0)
	    return ;
	RestricedGrowthFunction rgf = new RestricedGrowthFunction(jobs.size(), numOfMachines) ;
	int[] order = new int[numOfMachines] ;
	do{
	    if(firstEvaluation(rgf, order))
		getSingleMachineInstance(rgf, order) ;
	}
	while(rgf.increment()) ;
    }
    boolean firstEvaluation(RestricedGrowthFunction rgf, int[] order){
	for(int i = 0 ; i < order.length ; i++)
	    order[i] = i ;
	int[] minCost = new int[numOfMachines] ;
	for(int i = 0 ; i < rgf.body.length ; i++)
	    jobs.get(i).machineNumber = rgf.body[i] ;
	for(int i = 0 ; i < rgf.upperLimit + 1 ; i++){
	    JobSet jobSet = new JobSet() ;
	    for(int j = 0 ; j < jobs.size() ; j++){
		if(jobs.get(j).machineNumber == i)
		    jobSet.add(jobs.get(j)) ;
	    }
	    SingleMachineInstance si = new SingleMachineInstance(jobSet, bestValue) ;
	    minCost[i] = si.evaluation(0, 0) ;
	    if(bestValue <= minCost[i]) return false ;
	}
	sort(order, minCost) ;
	return true ;
    }
    void getSingleMachineInstance(RestricedGrowthFunction rgf, int[] order){
	for(int i = 0 ; i < order.length ; i++){
	    JobSet jobSet = new JobSet() ;
	    for(int j = 0 ; j < jobs.size() ; j++){
		if(jobs.get(j).machineNumber == order[i])
		    jobSet.add(jobs.get(j)) ;
	    }
	    SingleMachineInstance si = new SingleMachineInstance(jobSet, bestValue) ;
	    si.branchAndBound(0, 0, 0) ;
	    if(bestValue <= si.bestValue) break ; //次の機械への割り当てを中断
	    machineBestValue[order[i]] = si.bestValue ;
	    permutation[order[i]] = (JobSet)si.bestPermutation.clone() ;
	}
	updateBestPermutation(rgf) ;
    }
    void updateBestPermutation(RestricedGrowthFunction rgf){
	int partitionBestValue = getPartitionBestValue() ;
	if(partitionBestValue < bestValue){
	    bestPartition = (int[])rgf.body.clone() ;
	    bestValue = partitionBestValue ;
	    for(int i = 0 ; i < numOfMachines ; i++)
		bestPermutation[i] = (JobSet)permutation[i].clone() ;
	}
	this.machineBestValue = new int[numOfMachines] ;
	for(int i = 0 ; i < numOfMachines ; i++)
	    this.machineBestValue[i] = Integer.MAX_VALUE ;
	permutation = new JobSet[numOfMachines] ;
    }
    int getPartitionBestValue(){
	int partitionBestValue = Integer.MIN_VALUE ;
	for(int i = 0 ; i < numOfMachines ; i++)
	    if(partitionBestValue < this.machineBestValue[i])
		partitionBestValue = this.machineBestValue[i] ;
	return partitionBestValue ;
    }
    void sort(int[] order, int[] cost){
	for(int i = 0 ; i < cost.length - 1 ; i++){
	    for(int j = i + 1 ; j < cost.length ; j++){
		if(cost[i] < cost[j]){
		    order[j] = i ;
		    order[i] = j ;
		}
	    }
	}
    }
}
