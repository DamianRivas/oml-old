package io.opencaesar.oml.dsl.conversion

import org.eclipse.xtext.conversion.impl.QualifiedNameValueConverter

class ABBREV_IRIValueConverter extends QualifiedNameValueConverter {

	protected def String getDelimiter() {
		return ":"
	}
	
	override String getStringNamespaceDelimiter() {
		return getDelimiter();
	}
	
	override String getValueNamespaceDelimiter() {
		return getDelimiter();
	}
	
}