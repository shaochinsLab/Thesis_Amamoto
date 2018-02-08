class Literal {
    Variable variable ;
    boolean flag ;
    Literal(Variable v, boolean flag) {
	variable = v ;
	this.flag = flag ;
    }
    String toString() {
	String stg = "" ;
	if (! flag) stg = "!" ;
	return stg + variable.toString() ;
    }
}

class LiteralSet extends ArrayList<Literal> {
    LiteralSet() {
    }
    String toString() {
	String[] stg = new String[size()] ;
	for (int i = 0 ; i < size() ; i++) 
	    stg[i] = get(i).toString() ;
	return join(stg, ", ") ;
    }
}

class Clause extends LiteralSet {
    Clause(VariableSet vs, int[] members, boolean[] flags) {
	for (int i = 0 ; i < members.length ; i++) 
	    add(new Literal(vs.get(members[i]), flags[i])) ;
    }
    boolean contains(Literal literal){
	for(int i = 0 ; i < size() ; i++)
	    if(get(i).variable.index == literal.variable.index && get(i).flag == literal.flag)
		return true ;
	return false ;
    }
    String toString() {
	String[] stg = new String[size()] ;
	for (int i = 0 ; i < size() ; i++) 
	    stg[i] = get(i).toString() ;
	return "( " + join(stg, " v ") + " )" ;
    }
}

class SatInstance extends ArrayList<Clause> {
    VariableSet variableSet ;
    SatInstance(VariableSet vs, int[][] members, boolean[][] flags) {
	variableSet = vs ;
	for (int i = 0 ; i < members.length ; i++)
	    add(new Clause(variableSet, members[i], flags[i])) ;
    }
    LiteralSet[][] getAppearance() {
    	LiteralSet[][] array = new LiteralSet[variableSet.size()][2] ;
    	for(int i = 0 ; i < variableSet.size() ; i++){
    	    array[i][0] = new LiteralSet() ;
    	    array[i][1] = new LiteralSet() ;
    	}
    	for(LiteralSet ls : this){
    	    for(Literal literal : ls){
    		if(literal.flag) 
    		    array[literal.variable.index][0].add(literal) ;
    		else
    		    array[literal.variable.index][1].add(literal) ;
    	    }
    	}
    	return array ;
    }
    String toString() {
	String[] stg = new String[size()] ;
	for (int i = 0 ; i < size() ; i++) 
	    stg[i] = get(i).toString() ;
	return join(stg, " ^ ")  ;
    }
}
