void setup(){
    int n = 20 ;
    int m = 6 ;
    Interface intf = new Interface() ;
    JobSet jobs = intf.loadJobs("data/Instance.csv") ;
    int s = millis() ;
    // Instance instance = new Instance(jobs, m) ;
    Instance instance = new Instance(n, m) ;
    intf.writeFile(instance) ;
    int initialSolution = instance.bestValue ;
    intf.showInfo(instance) ;  //初期解の表示
    instance.getPartition() ;
    int e = millis() - s ;
    int optimalSolution = instance.bestValue ;
    intf.showInfo(instance) ;  //最適解の表示
    println("\ncompetitive ratio : " + (float)initialSolution/optimalSolution) ;
    println("time : " + e + " ms") ;
    exit() ;
}

