int n ;
JobSet[] js ;
int unitWidth ;
int unitHeight ;
IntList ranges ;
SatInstance si ;
WtInstance wi ;

void setup() {
    size(displayWidth, displayHeight) ;
    initialize() ;
}

void draw(){
    background(255) ;
    for(int i = 0 ; i < js.length ; i++)
	jobAssingment(i, si, wi) ;
    save("trueReduction.jpg") ;
}

void initialize(){
    n = 3 ;
    VariableSet vs = new VariableSet(n) ;
    int[][] members = {{0,1,2}, {0,1,2}, {0,1,2}, {0,1,2}, {0,1,2}, {0,1,2}/*, {0,1,2}, {0,1,2}*/} ;
    boolean[][] flags = {{true, true, false}, {true, true, false}, {true, false, false},
    			 {false, true, true}, {false, false, true}, {false, false, true}} ;
    // boolean[][] flags = {{true, true, true}, {false, false, false}, {true, false, false},
    // 			 {false, true, false}, {false, false, true}, {false, true, true},
    // 			 {true, false, true}, {true, true, false}} ;

    
    ranges = new IntList() ;
    ranges.append(0) ;
    si = new SatInstance(vs, members, flags) ;
    wi = new WtInstance(si) ;
   
    boolean[] flag = {true, false, true} ;
    //boolean[] flag = {true, true, true} ;
    AssignmentSet as = new AssignmentSet(vs, flag) ;
    Schedule schedule = new Schedule(vs.size() + si.size(), wi , as) ;
    js = new JobSet[vs.size() + si.size()] ;
    for(int i = 0 ; i < schedule.jobSet.length ; i++){
	js[i] = (JobSet)schedule.jobSet[i].clone() ;
	if(i < si.variableSet.size())
	    js[i].setStartTime(0) ;
	else
	    js[i].setStartTime(1) ;
    }

    for(int i = 0 ; i < n ; i++){
    	for(int j = 0 ; j < flags.length ; j++){
	    for(int k = 0 ; k < flags[j].length ; k++){
		if(flag[i]){
		    if(flags[j][i])
			js[j + n].get(i).flag = true ;
		    else
			js[j + n].get(i).flag = false ;
		}
		else{
		    if(flags[j][i])
			js[j + n].get(i).flag = false ;
		    else
			js[j + n].get(i).flag = true ;
		}
	    }
    	}
    }
    
    unitWidth = displayWidth / (wi.range + wi.range/3) ;
    unitHeight = displayHeight / (js.length * 2 + js.length/3) ;
    ranges.append(0) ;

    for(int i = 0 ; i < js.length ; i++){
	for(int j = 0 ; j < js[i].size() ; j++){
	    println("機械 " + i + " : 処理開始可能時刻 : " + js[i].get(j).releaseDate) ;
	}
	println("----------------------------") ;
    }
}

void jobAssingment(int i, SatInstance si, WtInstance wi){
    pushMatrix() ;
    translate(100, 50 + (unitHeight * 1.5) * i) ;
    textSize(25) ;
    text("M " + i, -70, unitHeight/2 + 8) ;
    strokeWeight(3) ;
    textSize(16) ;
    if(i < ranges.size()){
    	line(ranges.get(i) * unitWidth, -unitHeight/2 - (unitHeight * 2) * i,
    	     ranges.get(i) * unitWidth,
    	     unitHeight * (wi.range * 3) - 50 - (unitHeight * 2) * i) ;
	// text(ranges.get(i), ranges.get(i) * unitWidth - 10,
	//      -unitHeight/2 - 10 - (unitHeight * 2) * i) ;
    }
    for(int j = 0 ; j < js[i].size() ; j++){
	Job job = js[i].get(j) ;
	int processingTime = 0 ;
	if(i < si.variableSet.size()){
	    processingTime = job.processingTime[0] ;
	    if(j == js[i].size() - 1)
		fill(255, 255, 0) ;
	    else if(processingTime == 1)
		fill(200, 200, 255) ;
	    else
		fill(200, 255, 200) ;
	}
	else{
	    processingTime = job.processingTime[1] ;
	    if(j % 2 == 0)
		fill(188, 200, 219) ;
	    else if(j == js[i].size() - 1)
		fill(255, 255, 0) ;
	    else
		fill(152, 220, 136) ;
	}
	strokeWeight(3) ;
	textSize(25) ;
       	rect(job.startTime * unitWidth, 0, processingTime * unitWidth, unitHeight) ;
	fill(0, 0, 0) ;
	if(i >= si.variableSet.size() && j != js[i].size() - 1){
	    String flag = String.valueOf(job.flag) ;
	    text(flag, job.startTime * unitWidth - 25 + processingTime * unitWidth / 2,
	    	 unitHeight/2 + 8) ;
	}
	textSize(12) ;
	if(!ranges.hasValue(job.startTime)){
	    fill(0, 0, 0) ;
	    //	    text(job.startTime, job.startTime * unitWidth - 5, unitHeight + 27) ;
	}
	stroke(255,0,0) ;
	strokeWeight(2) ;
	if(i >= si.variableSet.size())
	    line(job.releaseDate * unitWidth, -10, job.releaseDate * unitWidth, unitHeight + 10) ;
	// if(job.startTime != job.releaseDate && !ranges.hasValue(job.releaseDate))
	//	    text(job.releaseDate, job.releaseDate * unitWidth - 5, unitHeight + 27) ;
	
	stroke(0,0,0) ;
	strokeWeight(1) ;
    }
    strokeWeight(5) ;
    line(0, unitHeight, wi.range * unitWidth + 150, unitHeight) ;
    strokeWeight(1) ;
    popMatrix() ;
}
