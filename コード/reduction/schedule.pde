class Schedule{
    JobSet[] jobSet ;
    AssignmentSet assignmentSet ;
    Schedule(int machineNum, WtInstance wi, AssignmentSet as){
	jobSet = new JobSet[machineNum] ;
	assignmentSet = as ;
	setJobSet(wi) ;
    }
    void setJobSet(WtInstance wi){
	for(int i = 0 ; i < jobSet.length ; i++)
	    jobSet[i] = new JobSet() ;
	for(int i = 0 ; i < assignmentSet.size() ; i++){
	    Assignment assignment = assignmentSet.get(i) ;
	    if(assignment.flag)
		jobSet[i] = wi.get(assignment.variable.index * 2 + 1) ;
	    else
		jobSet[i] = wi.get(assignment.variable.index * 2) ;
	}
	for(int i = 0 ; i < wi.jsArray.length ; i++)
	    for(int j = 0 ; j < wi.jsArray[i].length ; j++)
		for(int k = 0 ; k < jobSet.length ; k++)
		    wi.jsArray[i][j].remove(jobSet[k]) ;
	for(int i = 0 ; i < assignmentSet.size() ; i++)
	    jobSet[i].add(new Job(wi.range, 3)) ;
	for(int i = assignmentSet.size() ; i < jobSet.length ; i++){
	    jobSet[i] = wi.jsArray[i - assignmentSet.size()][0] ;
	    for(int j = 0 ; j < wi.jsArray[i - assignmentSet.size()][1].size() ; j++)
		jobSet[i].add(wi.jsArray[i - assignmentSet.size()][1].get(j)) ;
	    jobSet[i].sortByReleaseDate() ;
	}
    }
}
