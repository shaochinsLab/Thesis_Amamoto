class Job {
    int groupNumber ;
    int releaseDate ;
    int startTime ;
    int[] processingTime ;
    boolean flag ;
    Job(int m) {
	processingTime = new int[m] ;
    }
    Job(int r, int p){
	releaseDate = r ;
	processingTime = new int[3] ;
	for(int i = 0 ; i < processingTime.length ; i++)
	    processingTime[i] = p ;
    }
    boolean equals(Job job){
	return (groupNumber == job.groupNumber && flag == job.flag && releaseDate == job.releaseDate) ;
    }
    String toString(){
	return ("releaseDate : " + releaseDate + ", start time : " + startTime  + ", 機械 n : " + processingTime[0] + ", 機械 λ : " + processingTime[1] ) ;
    }
}

class JobSet extends ArrayList<Job> {
    int index ;
    int alpha ;
    int beta ;
    int range ;
    boolean flag ;
    JobSet(){
    }
    JobSet(int i, int a, int b, int m, boolean f) {
	index = i ;
	alpha = a ;
	beta = b ;
	for(int j = 0 ; j < alpha + beta ; j++)
	    add(new Job(m)) ;
	range = 3 * size() ;
	flag = f ;
    }
    void setStartTime(int num){
	get(0).startTime = get(0).releaseDate ;
	for(int i = 1 ; i < size() ; i++){
	    if(get(i - 1).startTime + get(i - 1).processingTime[num] <= get(i).releaseDate)
		get(i).startTime = get(i).releaseDate ;
	    else
		get(i).startTime = get(i - 1).startTime + get(i - 1).processingTime[num] ;
	}
    }

    void sortByReleaseDate(){
	Job tmp ;
	for(int i = 0 ; i < size() - 1 ; i++){
	    for(int j = i + 1 ; j < size() ; j++){
		if(get(i).releaseDate > get(j).releaseDate){
		    tmp = get(j) ;
		    set(j , get(i)) ;
		    set(i , tmp) ;
		}
	    }
	}
    }
    void remove(JobSet js){
	for(int i = 0 ; i < js.size() ; i++)
	    for(int j = 0 ; j < size() ; j++)
		if(js.get(i).equals(get(j)))
		    this.remove(j) ;
    }
    String toString(){
	String str = "" ;
	for(int i = 0 ; i < size() ; i++)
	    str += get(i).toString() ;
	return str ;
    }
}

class JobSetArrayList extends ArrayList<JobSet>{
    int range ;
    JobSetArrayList(){
    }
}

class WtInstance extends JobSetArrayList{
    JobSet[][] jsArray ;
    WtInstance(SatInstance si){
	for(int i = 0 ; i < si.getAppearance().length ; i++){
	    int alpha = si.getAppearance()[i][0].size() ;
	    int beta = si.getAppearance()[i][1].size() ;
	    add(new JobSet(i, alpha, beta, 3, true)) ;
	    add(new JobSet(i, alpha, beta, 3, false)) ;
	}
	for(JobSet js : this){
	    if(js.flag){
		range += js.range ;
		ranges.append(range) ;
	    }
	}
	ranges.append(ranges.get(ranges.size() - 1) + 3) ;
	jsArray = new JobSet[si.size()][2] ;
	for(int i = 0 ; i < jsArray.length ; i++)
	    for(int j = 0 ; j < jsArray[i].length ; j++)
		jsArray[i][j] = new JobSet() ;
	setStatus() ;
	setJobOnLiteral(si) ;
    }
    void setStatus(){
	int startTime = 0 ;
	for(int i = 0 ; i < size() ; i++){
	    if(i != 0 && i % 2 == 0)
		startTime += get(i - 1).range ;
	    for(int j = 0 ; j < get(i).size() ; j++){
		Job job = get(i).get(j) ;
		job.groupNumber = get(i).index ;
		job.flag = get(i).flag ;
		job.processingTime[2] = range + 3 ;
		if(get(i).flag){  // 各リテラルに対応するジョブ集合の前半部分 ( false )
		    if(j < get(i).beta - 1){
			job.releaseDate = startTime + j ;
			job.processingTime[0] = 1 ;
		    }
		    else if(j == get(i).beta - 1){
			job.releaseDate = startTime + j ;
			job.processingTime[0] = get(i).alpha + 4 ;
		    }
		    else if(j < get(i).alpha + get(i).beta - 1){
			job.releaseDate = startTime + get(i).alpha + j + 3 ;
			job.processingTime[0] = 1 ;
		    }
		    else{
			job.releaseDate = startTime + get(i).alpha + j + 3 ;
			job.processingTime[0]
			    = range + 2 - (startTime + 2 * get(i).alpha + get(i).beta + 2) ;
		    }
		}
		else{  // 各リテラルに対応するジョブ集合の後半部分 ( true )
		    if(j == 0){
			job.releaseDate = startTime + j ;
			job.processingTime[0] = get(i).beta + 2 ;
		    }
		    else if(j < get(i).alpha - 1){
			job.releaseDate = startTime + get(i).alpha + j + 1 ;
			job.processingTime[0] = 1 ;
		    }
		    else if(j == get(i).alpha - 1){
			job.processingTime[0] = get(i).alpha + 5 ;
			job.releaseDate = startTime + get(i).alpha + j + 1 ;
		    }
		    else if(j < get(i).alpha + get(i).beta - 1){
			job.releaseDate = startTime + get(i).alpha + get(i).beta + 5 + j ;
			job.processingTime[0] = 1 ;
		    }
		    else{
			job.releaseDate = startTime + get(i).alpha + get(i).beta + 5 + j ;
			job.processingTime[0]
			    = range + 2 - (startTime + 2 * (get(i).alpha + get(i).beta ) + 4) ;
		    }
		}
	    }
	}
    }
    void setJobOnLiteral(SatInstance si){
    	for(int i = 0 ; i < si.size() ; i++){
	    Clause h = si.get(i) ;
    	    JobSet tjs = new JobSet() ;
    	    JobSet fjs = new JobSet() ;
    	    for(int j = 0 ; j < h.size() ; j++){
    		Literal l = h.get(j) ;
		int count = count(si, l, i) ;
		JobSet jst = equalJobSet(new Literal(l.variable, true)) ;
		//各リテラル ( true ) に対応するジョブの集合をとってきている
		JobSet jsf = equalJobSet(new Literal(l.variable, false)) ;
		//各リテラル ( false ) に対応するジョブの集合をとってきている
	        if(l.flag){
		    tjs.add(jst.get(jst.beta + count)) ;
		    fjs.add(jsf.get(count)) ;
		}
    		else{
		    tjs.add(jsf.get(jsf.alpha + count)) ;		    
    		    fjs.add(jst.get(count)) ;		    
		}
    	    }
	    fjs.add(new Job(range, 3)) ;
    	    jsArray[i][0] = tjs ;
    	    jsArray[i][1] = fjs ;
    	}
	for(int i = 0 ; i < jsArray.length ; i++){
	    JobSet tjs = jsArray[i][0] ;
	    JobSet fjs = jsArray[i][1] ;
	    for(int j = 0 ; j < tjs.size() ; j++){
		tjs.get(j).processingTime[1]
		    = fjs.get(j + 1).releaseDate - tjs.get(j).releaseDate ;
		fjs.get(j).processingTime[1]
		    = fjs.get(j + 1).releaseDate - fjs.get(j).releaseDate + (4 - tjs.size()) ;
	    }
	}
    }
    int count(SatInstance si, Literal l, int k){
	int count = 0 ;
	for(int i = 0 ; i < k ; i++)
	    if(si.get(i).contains(l))
		count++ ;
	return count ;
    }
    JobSet equalJobSet(Literal l){
	JobSet js = new JobSet() ;
	for(int i = 0 ; i < size() ; i++)
	    if(l.variable.index == get(i).index && l.flag == get(i).flag){
		js = get(i) ;
		return js ;
	    }
	return null ;
    }
}
