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

public class doublyLinkedList extends PApplet {

int n ;   //\u30b8\u30e7\u30d6\u6570
int m ;   //\u6a5f\u68b0\u6570
int partitionBestValue ;   //\u5206\u5272\u306e\u4e2d\u3067\u3082\u3063\u3068\u3082\u826f\u3044waiting time
int bestValue ;   //\u5168\u3066\u306e\u5206\u5272\u306e\u4e2d\u3067\u3082\u3063\u3068\u3082\u826f\u3044waiting time
int[] f ;   //\u5206\u5272\u3092\u5165\u308c\u308b\u7bb1
int[] bestPartition ;   //f\u306e\u30b3\u30d4\u30fc\u306e\u7bb1\uff08bestValue\u304c\u66f4\u65b0\u3055\u308c\u305f\u6642\u3060\u3051\uff0cf\u306e\u30b3\u30d4\u30fc\u3092\u5165\u308c\u308b\uff09
Job[] js ;   //\u30b8\u30e7\u30d6\u306e\u96c6\u5408
Job[] permutation ;   //\u5206\u5272\u5148\u306e\u9806\u5217\u3092\u5165\u308c\u308b\u7bb1
int[] machineWaitingTime ;   //\u6a5f\u68b0\u3054\u3068\u306ewaiting time\u306e\u4e2d\u3067\u3082\u3063\u3068\u3082\u826f\u3044waiting time
Job[][] bp ;   //\u3042\u308bf\u306e\u4e2d\u3067\uff0c\u4e00\u756a\u3044\u3044waiting time\u3092\u6301\u3063\u305fpermutation\u306e\u7d44\u307f\u5408\u308f\u305b\u3092\u5165\u308c\u308b\u7bb1
Job[][] bestPermutation ;   //bestValue\u304c\u66f4\u65b0\u3055\u308c\u305f\u6642\uff0cpermutation\u306e\u7d44\u307f\u5408\u308f\u305b\u306e\u30b3\u30d4\u30fc\u3092\u5165\u308c\u308b\u7bb1
PrintWriter output ;
int allCount = 0 ;
int evaluationCount = 0 ;
int bCount = 0 ;

public void setup(){
  initialize() ;
  int s = millis() ;
  allPermutation(f, 1, 0) ;
  showInfo() ;
  println("time : " + (millis() - s) + " ms") ;
  println("\u5224\u5b9a\u56de\u6570 : " + allCount + " \u56de") ;
  println("\u901a\u5e38 \u679d\u5207\u308a\u56de\u6570 : " + bCount + " \u56de") ;
  println("\u6539\u826f \u679d\u5207\u308a\u56de\u6570 : " + evaluationCount + " \u56de") ;
  exit() ;
}

//\u5206\u5272\u4f5c\u6210
public void allPermutation(int[] f, int i, int fmax){
  if(i < n){
    for(int j = 0 ; j <= fmax ; j++){
      f[i] = j ;
      allPermutation(f, i + 1, fmax) ;
    }
    f[i] = fmax + 1 ;
    allPermutation(f, i + 1, fmax + 1) ;
  }
  else {
    if(fmax + 1 == m){
      //	    displayPartition(f, fmax) ;
      allPermutation(js, f, fmax) ;
      getBestValue(f) ;
      reset() ;
    }
  }
}

//\u5404\u5206\u5272\u5148\u3067\u53cc\u65b9\u5411\u30ea\u30b9\u30c8\u3092\u4f5c\u6210
public void allPermutation(Job[] js, int[] f, int fmax){
  for(int i = 0 ; i < f.length ; i++)
  js[i].machineNumber = f[i] ;
  for(int i = 0 ; i <= fmax ; i++){
    List list = new List() ;
    int numOfJobs = 0 ;
    for(int j = 0 ; j < n ; j++){
      if(js[j].machineNumber == i){
        list.add(new Item(js[j])) ;
        numOfJobs++ ;
      }
    }
    permutation = new Job[numOfJobs] ;
    allPermutation(list, numOfJobs, i, 0, 0, 0) ;
    if(bestValue <= machineWaitingTime[i])
    break ;
  }
}

//\u4e0a\u3067\u4f5c\u3063\u305f\u53cc\u65b9\u5411\u30ea\u30b9\u30c8\u3092\u57fa\u306b\u5206\u5b50\u9650\u5b9a\u6cd5\u3067\u9806\u5217\u3092\u4f5c\u6210
public void allPermutation(List list, int numOfJobs, int machineNumber, int i, int completionTime, int waitingTime){
  if(i == numOfJobs){
    machineWaitingTime[machineNumber] = waitingTime ;
    bp[machineNumber] = (Job[])permutation.clone() ;
    //	display(permutation, machineNumber, waitingTime) ;
  }
  else{
    for(Item a = list.head.next ; a != list.head ; a = a.next){
      permutation[i] = a.job ;
      int s = max(completionTime, a.job.releaseDate) ;
      int c = s + a.job.processingTime ;
      int w = max(waitingTime, s - a.job.releaseDate) ;
      if(machineWaitingTime[machineNumber] <= w){
        bCount++ ;
        break ;
      }
      list.remove(a) ;
      if(list.evaluation(list.minProcessingTime(), c, w))
      allPermutation(list, numOfJobs, machineNumber, i + 1, c, w) ;
      list.restore(a) ;
    }
  }
}

public void getBestValue(int[] f){   //\u5206\u5272f\u306e\u3068\u304d\u306ewaiting time\u306e\u8a08\u7b97\u3068bestValue\u306e\u66f4\u65b0
  partitionBestValue = machineWaitingTime[0] ;
  for(int i = 1 ; i < machineWaitingTime.length ; i++)
  if(partitionBestValue < machineWaitingTime[i])
  partitionBestValue = machineWaitingTime[i] ;
  //   println("partition bestValue : " + partitionBestValue) ;
  if(partitionBestValue < bestValue){
    bestValue = partitionBestValue ;
    bestPartition = (int[])f.clone() ;
    for(int i = 0 ; i < m ; i++)
    bestPermutation[i] = bp[i] ;
  }
}

public void reset(){   //\u6b21\u306e\u5206\u5272\u306b\u79fb\u308b\u6642\u306b\uff0c\u5404\u6a5f\u68b0\u306b\u304a\u3051\u308bwaiting time\u3092reset\u3059\u308b
  for(int i = 0 ; i < machineWaitingTime.length ; i++)
  machineWaitingTime[i] = Integer.MAX_VALUE ;
}

//\u521d\u671f\u5024\u306e\u8a2d\u5b9a\u306a\u3069
public void initialize(){
  n = 10 ;
  m = 1 ;
  JobSet jobs = new JobSet(n) ;
  js = jobs.toArray() ;

  f = new int[n] ;
  f[0] = 0 ;
  machineWaitingTime = new int[m] ;

  for(int i = 0 ; i < machineWaitingTime.length ; i++)
  machineWaitingTime[i] = Integer.MAX_VALUE ;
  bestValue = Integer.MAX_VALUE ;

  bp = new Job[m][] ;
  bestPermutation = new Job[m][] ;
}
class Instance {
  JobSet jobs ;
  Instance(int n, int m) {
    jobs = new JobSet(n) ;

  }
}

//\u8868\u793a
public void displayPartition(int[] f, int fmax){
  print("\nf : ( ") ;
  for(int i = 0 ; i < f.length ; i++)
  print(f[i] + " ") ;
  println("), fmax = " + fmax) ;
}

public void display(JobSet permutation, int machineNumber, int waitingTime){
  print("machine " + machineNumber + ", p : ( ") ;
  for(int i = 0 ; i < permutation.size() ; i++)
  print(permutation.get(i).index + " ") ;
  println("), waiting time = " + waitingTime) ;
}

public void showInfo(){
  println("\n------optimal solution------") ;
  print("best partition : ( ") ;
  for(int i = 0 ; i < bestPartition.length ; i++)
  print(bestPartition[i] + " ") ;
  println(")") ;
  for(int i = 0 ; i < bestPermutation.length ; i++){
    print("machine " + i  + ", p : ( ") ;
    for(int j = 0 ; j < bestPermutation[i].length ; j++){
      print(bestPermutation[i][j].index + " ") ;
    }
    println(")") ;
  }
  println("bestValue = " + bestValue) ;
}

//\u30d5\u30a1\u30a4\u30eb\u306e\u8aad\u307f\u8fbc\u307f\uff0c\u66f8\u304d\u8fbc\u307f
public Job[] loadJobs(String filename){
  String[] lines = loadStrings(filename) ;
  Job[] js = new Job[lines.length - 1] ;
  for(int i = 1 ; i < lines.length ; i++){
    int[] data = PApplet.parseInt(split(lines[i] , ",")) ;
    js[i - 1] = new Job(i - 1, data[1], data[2]) ;
  }
  sortByReleaseDate(js) ;
  return js ;
}

public void writeFile(String filename ,Job[] js){
  output = createWriter("data/" + filename) ;
  output.println("index,releaseDate,processingTime") ;
  for(int i = 0 ; i < js.length ; i++){
    output.print(i + ",") ;
    output.print(js[i].releaseDate + ",") ;
    output.println(js[i].processingTime + ",") ;
  }
  output.flush() ;
  output.close() ;
}
class Job{
  int index ;
  int machineNumber ;
  int releaseDate ;
  int processingTime ;
  Job(int i){
    this(i, (int)random(0, 50), (int)random(30, 40)) ;
  }
  Job(int i, int rd, int pt) {
    index = i ;
    releaseDate = rd ;
    processingTime = pt ;
  }
  public String toString() {
    return "\n" + "index : " + index + "\n" +
    "release date : " + releaseDate + "\n" +
    "processing time : " + processingTime + "\n" ;
  }
}

class JobSet extends ArrayList<Job>{
  JobSet(){
  }
  JobSet(int n) {
    for (int i = 0 ; i < n ; i++)
    add(new Job(i)) ;
    sortByReleaseDate() ;
    writeFile("Instance.csv", js) ;
  }
  public void sortByReleaseDate() {
    for(int i = 0 ; i < size() - 1 ; i++){
      Job minJob = get(i) ;
      int minIndex = i ;
      for(int j = i + 1 ; j < size() ; j++){
        Job tmpJob = get(j) ;
        if(minJob.releaseDate > tmpJob.releaseDate){
          minIndex = j ;
          minJob = tmpJob ;
        }
      }
      if (minIndex == i) continue ;
      remove(minIndex) ;
      add(i, minJob) ;
    }
    for(int i = 0 ; i < size() ; i++)
    get(i).index = i ;
  }
}
class Item {
  Job job ;
  Item previous ;
  Item next ;
  Item(Job j) {
    job = j ;
    previous = this ;
    next = this ;
  }
  public String toString() {
    return job.toString() ;
  }
}

class List {
  Item head ;
  List(Item a) {
    head = a ;
  }
  List() {
    head = new Item(new Job(-1)) ;
  }
  public boolean isEmpty(){
    return head.next == head ;
  }
  public void add(Item a) {
    add(head.previous, a) ;
  }
  public void add(Item a, Item b) {
    b.next = a.next ;
    b.previous = a ;
    b.next.previous = b.previous.next = b ;
  }
  public void remove(Item a) {
    a.previous.next = a.next ;
    a.next.previous = a.previous ;
  }
  public void restore(Item a) {
    a.next.previous = a.previous.next = a ;
  }
  public int minProcessingTime(){
    int min = Integer.MAX_VALUE ;
    for(Item a = head.next ; a != head ; a = a.next)
    if(a.job.processingTime < min)
    min = a.job.processingTime ;
    return min ;
  }
  public boolean evaluation(int completionTime, int waitingTime){
    return evaluation(minProcessingTime(), completionTime, waitingTime) ;
  }
  public boolean evaluation(int minProcessingTime, int completionTime, int waitingTime){
    allCount++ ;
    int s = 0 ;
    int c = completionTime ;
    int w = waitingTime ;
    for(Item a = head.next ; a != head ; a = a.next){
      s = max(c, a.job.releaseDate) ;
      c = s + minProcessingTime ;
      w = max(s - a.job.releaseDate, w) ;
      if (bestValue <= w){
        evaluationCount++ ;
        return false ;
      }
    }
    return true ;
  }
}
class RestricedGrowthFunction {
  int[] body ;
  int upperLimit ;
  int[] upperBound ;
  RestricedGrowthFunction(int n, int m) {
    body = new int[n] ;
    upperLimit = m - 1 ;
    upperBound = new int[n] ;
    for (int i = 1 ; i < upperBound.length ; i++)
    upperBound[i] = 1 ;
  }
  public String toString() {
    return join(nf(body, 0), ",") ;
  }
  public boolean increment() {
    for (int i = body.length - 1 ; i > 0 ; i--) {
      if (body[i] == upperBound[i]) {
        body[i] = 0 ;
      }
      else {
        body[i]++ ;
        if (body[i] < upperLimit && body[i] == upperBound[i]) {
          for (int j = i + 1 ; j < body.length ; j++) {
            upperBound[j] = body[i] + 1 ;
          }
        }
        return true ;
      }
    }
    return false ;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "doublyLinkedList" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
