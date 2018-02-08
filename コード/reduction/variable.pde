class Variable {
    int index ;
    Variable(int i) {
	index = i ;
    }
    String toString() {
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
