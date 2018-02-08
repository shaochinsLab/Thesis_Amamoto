int n ;
int m ;

void setup() {
    n = 3 ;
    m = 2 ;
    RestricedGrowthFunction rgf = new RestricedGrowthFunction(n,m) ;
    do{
	println(rgf) ;
    }
    while(rgf.increment()) ;
    exit() ;
}
