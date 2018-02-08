class Item {
    Job job ;
    Item previous ;
    Item next ;
    Item(Job j) {
	job = j ;
	previous = this ;
	next = this ;
    }
    String toString() {
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
    boolean isEmpty(){
	return head.next == head ;
    }
    void add(Item a) {
	add(head.previous, a) ;
    }
    void add(Item a, Item b) {
	b.next = a.next ;
	b.previous = a ;
	b.next.previous = b.previous.next = b ;
    }
    void remove(Item a) {
	a.previous.next = a.next ;
	a.next.previous = a.previous ;
    }
    void restore(Item a) {
	a.next.previous = a.previous.next = a ;
    }
    int minProcessingTime(int machineNumber){
	int min = Integer.MAX_VALUE ;
	for(Item a = head.next ; a != head ; a = a.next)
	    if(a.job.processingTime[machineNumber] < min)
		min = a.job.processingTime[machineNumber] ;
	return min ;
    }
}
