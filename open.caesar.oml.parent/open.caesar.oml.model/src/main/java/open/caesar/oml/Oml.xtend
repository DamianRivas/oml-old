package open.caesar.oml

import java.util.List

class Oml {
	
	static dispatch def List<ModuleStatement> allStatements(Module module) {
		return null
	}
	
	static dispatch def List<TerminologyStatement> allStatements(Terminology terminology) {
		return terminology.statements
	}

}