package io.opencaesar.oml.dsl.conversion

import com.google.common.base.Preconditions
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.naming.QualifiedName

class OmlQualifiedNameConverter implements IQualifiedNameConverter {
	
	override String toString(QualifiedName qualifiedName) {
		if (qualifiedName === null)
			throw new IllegalArgumentException("Qualified name cannot be null")
		return qualifiedName.toString("")
	}

	override QualifiedName toQualifiedName(String qualifiedNameAsString) {
		Preconditions.checkArgument(qualifiedNameAsString !== null, "Qualified name cannot be null")
		Preconditions.checkArgument(!qualifiedNameAsString.isEmpty(), "Qualified name cannot be empty")
		var index = qualifiedNameAsString.lastIndexOf('#')
		if (index === -1) {
			index = qualifiedNameAsString.lastIndexOf('/')
		}
		if (index === -1 || index === qualifiedNameAsString.length-1) {
			return QualifiedName.create(qualifiedNameAsString)
		}
		val parentName = qualifiedNameAsString.substring(0, index+1)
		val elementName = qualifiedNameAsString.substring(index+1)
		return QualifiedName.create(parentName, elementName);
	}
	
}
