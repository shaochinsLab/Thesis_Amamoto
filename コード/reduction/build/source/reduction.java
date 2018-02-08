import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class reduction extends PApplet {

int n ;
JobSet[] js ;
int unitWidth ;
int unitHeight ;
SatInstance si ;
WtInstance wi ;

public void setup() {
    
    initialize() ;
}

public void draw(){
    background(255) ;
    for(int i = 0 ; i < js.length ; i++)
	jobAssingment(i, si, wi) ;
    save("scheduling1.jpg") ;
}

public void initialize(){
    n = 3 ;
    VariableSet vs = new VariableSet(n) ;
    int[][] members = {{0,1,2},{0,1,2},{0,1,2},{0,1,2},{0,1,2},{0,1,2}} ;
    boolean[][] flags = {{true, false, true}, {true, false, true}, {true, false, true},
			 {false, true, false}, {false, true, false}, {false, true, false}} ;
    si = new SatInstance(vs, members, flags) ;
    wi = new WtInstance(si) ;

    boolean[] flag = {true, false, false} ;
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
    //
    for(int i = 0 ; i < js.length ; i++){
    	println("\u30b0\u30eb\u30fc\u30d7 " + i + "  \u2192  \u6a5f\u68b0 " + i + " : ") ;
    	for(int j = 0 ; j < js[i].size() ; j++){
    	    println(js[i].get(j)) ;
    	}
    	println() ;
    }
    //
    unitWidth = displayWidth / (wi.range + wi.range/3) ;
    unitHeight = displayHeight / (js.length * 2 + js.length/3) ;
}

public void jobAssingment(int i, SatInstance si, WtInstance wi){
    pushMatrix() ;
    translate(50, 50 + (unitHeight * 2) * i) ;

    strokeWeight(3) ;
    line(0, -unitHeight/2, 0, unitHeight * (js.length * 3) - 50) ;
    for(int j = 0 ; j < si.variableSet.size() ; j++){
	int range = wi.get(j * 2).range ;
	line(range * unitWidth * (j + 1) , -unitHeight/2, range * unitWidth * (j + 1) , unitHeight * (js.length * 3) - 50) ;
    }
    line((wi.range + 3) * unitWidth, -unitHeight/2, (wi.range + 3) * unitWidth, unitHeight * (js.length * 3) - 50) ;
    strokeWeight(1) ;

    for(int j = 0 ; j < js[i].size() ; j++){
	Job job = js[i].get(j) ;
	int processingTime = 0 ;
	if(i < si.variableSet.size()){
	    processingTime = job.processingTime[0] ;
	    if(processingTime == 1)
		fill(200, 200, 255) ;
	    else
		fill(200, 255, 200) ;
	}
	else{
	    processingTime = job.processingTime[1] ;
	    if(j % 2 == 0)
		fill(200, 200, 255) ;
	    else
		fill(200, 255, 200) ;
	}
       	rect(job.startTime * unitWidth, 0, processingTime * unitWidth, unitHeight) ;
	stroke(255,0,0) ;
	strokeWeight(2) ;
	line(job.releaseDate * unitWidth, -10, job.releaseDate * unitWidth, unitHeight + 10) ;
	stroke(0,0,0) ;
	strokeWeight(1) ;
    }
    strokeWeight(5) ;
    line(0,unitHeight, wi.range * unitWidth + 150, unitHeight) ;
    strokeWeight(1) ;
    popMatrix() ;
}
class Assignment{
    Variable variable ;
    boolean flag ;
    Assignment(Variable variable, boolean flag){
	this.variable = variable ;
	this.flag = flag ;
    }
}

class AssignmentSet extends ArrayList<Assignment>{
    AssignmentSet(VariableSet variableSet, boolean[] flag){
	for(int i = 0 ; i < variableSet.size() ; i++)
	    add(new Assignment(variableSet.get(i), flag[i])) ;
    }
}
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
	processingTime[1] = p ;
    }
    public boolean equals(Job job){
	return (groupNumber == job.groupNumber && flag == job.flag && releaseDate == job.releaseDate) ;
    }
    public String toString(){
	return ("releaseDate : " + releaseDate + ", start time : " + startTime  + ", \u6a5f\u68b0 n : " + processingTime[0] + ", \u6a5f\u68b0 \u03bb : " + processingTime[1] ) ;
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
	for (int j = 0 ; j < alpha + beta ; j++)
	    add(new Job(m)) ;
	range = 3 * size() ;
	flag = f ;
    }
    public void setStartTime(int num){
	get(0).startTime = get(0).releaseDate ;
	for(int i = 1 ; i < size() ; i++){
	    if(get(i - 1).startTime + get(i - 1).processingTime[num] <= get(i).releaseDate)
		get(i).startTime = get(i).releaseDate ;
	    else
		get(i).startTime = get(i - 1).startTime + get(i - 1).processingTime[num] ;
	}
    }

    public void sortByReleaseDate(){
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
    public void remove(JobSet js){
	for(int i = 0 ; i < js.size() ; i++)
	    for(int j = 0 ; j < size() ; j++)
		if(js.get(i).equals(get(j)))
		    this.remove(j) ;
    }
    public String toString(){
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
	    JobSet tjs = new JobSet(i, alpha, beta, 3, true) ;
	    JobSet fjs = new JobSet(i, alpha, beta, 3, false) ;
	    add(tjs) ;
	    add(fjs) ;
	}
	for(JobSet js : this)
	    if(js.flag)
		range += js.range ;
	jsArray = new JobSet[si.size()][2] ;
	for(int i = 0 ; i < jsArray.length ; i++)
	    for(int j = 0 ; j < jsArray[i].length ; j++)
		jsArray[i][j] = new JobSet() ;
	setStatus() ;
	setJobOnLiteral(si) ;
    }
    public void setStatus(){
	int startTime = 0 ;
	for(int i = 0 ; i < size() ; i++){
	    if(i != 0 && i % 2 == 0)
		startTime += get(i - 1).range ;
	    for(int j = 0 ; j < get(i).size() ; j++){
		Job job = get(i).get(j) ;
		job.groupNumber = get(i).index ;
		job.flag = get(i).flag ;
		job.processingTime[2] = range + 3 ;
		if(get(i).flag){
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
			    = range + 3 - (startTime + 2 * get(i).alpha + get(i).beta + 2) ;
		    }
		}
		else{
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
			    = range + 3 - (startTime + 2 * (get(i).alpha + get(i).beta ) + 4) ;
		    }
		}
	    }
	}
    }
    public void setJobOnLiteral(SatInstance si){
    	for(int i = 0 ; i < si.size() ; i++){
	    Clause h = si.get(i) ;
    	    JobSet tjs = new JobSet() ;
    	    JobSet fjs = new JobSet() ;
    	    for(int j = 0 ; j < h.size() ; j++){
    		Literal l = h.get(j) ;
		int count = count(si, l, i) ;
		JobSet jst = equalJobSet(new Literal(l.variable, true)) ;
		JobSet jsf = equalJobSet(new Literal(l.variable, false)) ;
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
		    = fjs.get(j + 1).releaseDate - fjs.get(j).releaseDate + 1 ;
	    }
	}
    }
    public int count(SatInstance si, Literal l, int k){
	int count = 0 ;
	for(int i = 0 ; i < k ; i++)
	    if(si.get(i).contains(l))
		count++ ;
	return count ;
    }
    public JobSet equalJobSet(Literal l){
	JobSet js = new JobSet() ;
	for(int i = 0 ; i < size() ; i++)
	    if(l.variable.index == get(i).index && l.flag == get(i).flag){
		js = get(i) ;
		return js ;
	    }
	return null ;
    }
}
class Literal {
    Variable variable ;
    boolean flag ;
    Literal(Variable variable, boolean flag) {
	this.variable = variable ;
	this.flag = flag ;
    }
    public String toString() {
	String stg = "" ;
	if (! flag) stg = "!" ;
	return stg + variable.toString() ;
    }
}

class LiteralSet extends ArrayList<Literal> {
    LiteralSet() {
    }
    public String toString() {
	String[] stg = new String[size()] ;
	for (int i = 0 ; i < size() ; i++) 
	    stg[i] = get(i).toString() ;
	return join(stg, ", ") ;
    }
}

class Clause extends LiteralSet {
    Clause(VariableSet variableSet, int[] memberIndices, boolean[] memberFlags) {
	for (int i = 0 ; i < memberIndices.length ; i++) 
	    add(new Literal(variableSet.get(memberIndices[i]), memberFlags[i])) ;
    }
    public boolean contains(Literal literal){
	for(int i = 0 ; i < size() ; i++)
	    if(get(i).variable.index == literal.variable.index && get(i).flag == literal.flag)
		return true ;
	return false ;
    }
    public String toString() {
	String[] stg = new String[size()] ;
	for (int i = 0 ; i < size() ; i++) 
	    stg[i] = get(i).toString() ;
	return "( " + join(stg, " v ") + " )" ;
    }
}

class SatInstance extends ArrayList<Clause> {
    VariableSet variableSet ;
    SatInstance(VariableSet variableSet, int[][] memberIndices, boolean[][] memberFlags) {
	this.variableSet = variableSet ;
	for (int i = 0 ; i < memberIndices.length ; i++)
	    add(new Clause(variableSet, memberIndices[i], memberFlags[i])) ;
    }
    public LiteralSet[][] getAppearance() {
    	LiteralSet[][] lsArray = new LiteralSet[variableSet.size()][2] ;
    	for (int i = 0 ; i < variableSet.size() ; i++) {
    	    lsArray[i][0] = new LiteralSet() ;
    	    lsArray[i][1] = new LiteralSet() ;
    	}
    	for (LiteralSet ls : this) {
    	    for (Literal literal : ls) {
    		if (literal.flag) 
    		    lsArray[literal.variable.index][0].add(literal) ;
    		else
    		    lsArray[literal.variable.index][1].add(literal) ;
    	    }
    	}
    	return lsArray ;
    }
    public String toString() {
	String[] stg = new String[size()] ;
	for (int i = 0 ; i < size() ; i++) 
	    stg[i] = get(i).toString() ;
	return join(stg, " ^ ")  ;
    }
  
}
class Schedule{
    JobSet[] jobSet ;
    AssignmentSet assignmentSet ;
    Schedule(int machineNum, WtInstance wi, AssignmentSet as){
	jobSet = new JobSet[machineNum] ;
	assignmentSet = as ;
	setJobSet(wi) ;
    }
    public void setJobSet(WtInstance wi){
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
	for(int i = assignmentSet.size() ; i < jobSet.length ; i++){
	    jobSet[i] = wi.jsArray[i - assignmentSet.size()][0] ;
	    for(int j = 0 ; j < wi.jsArray[i - assignmentSet.size()][1].size() ; j++)
		jobSet[i].add(wi.jsArray[i - assignmentSet.size()][1].get(j)) ;
	    jobSet[i].sortByReleaseDate() ;
	}
    }
}
class Variable {
    int index ;
    Variable(int i) {
	index = i ;
    }
    public String toString() {
	return ("x" + index) ;
    }	
}

class VariableSet extends ArrayList<Variable>{
    VariableSet(){
    }
    VariableSet(int n){
	for(int i = 0 ; i < n ; i++)
	    add(new Variable(i)) ;
    }
}
  public void settings() {  size(displayWidth, displayHeight) ; }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "reduction" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
