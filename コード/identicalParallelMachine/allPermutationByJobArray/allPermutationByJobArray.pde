void setup(){
    int n = 13 ;
    int m = 2 ;
    Interface intf = new Interface() ;
    Job[] jobs = intf.loadJobs("../allPermutationByJobSet2/data/Instance.csv") ;
    // println(jobs) ;
    Instance instance = new Instance(jobs, m) ;
    // Instance instance = new Instance(n, m) ;
    // intf.writeFile(instance) ;
    instance.setInitialSolution() ;
    int initialSolution = instance.bestValue ;
    intf.showInfo(instance) ;  //初期解の表示
    int s = millis() ;
    instance.getPartition() ;
    int e = millis() - s ;
    int optimalSolution = instance.bestValue ;
    intf.showInfo(instance) ;  //最適解の表示
    println("\ncompetitive ratio : " + (float)initialSolution/optimalSolution) ;
    println("time : " + e + " ms") ;
    exit() ;
}

