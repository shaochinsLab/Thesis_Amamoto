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
