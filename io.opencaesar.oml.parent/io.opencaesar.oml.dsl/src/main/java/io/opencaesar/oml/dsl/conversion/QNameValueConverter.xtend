package io.opencaesar.oml.dsl.conversion

import com.google.inject.Inject
import org.eclipse.xtext.conversion.IValueConverterService
import org.eclipse.xtext.nodemodel.INode

class QNameValueConverter extends IRIValueConverter {

	@Inject
	protected IValueConverterService valueConverterService;

	override elseToString(String value) {
		return valueConverterService.toString(value, "ABBREV_IRI")
	}
	
	override elseToValue(String string, INode node) {
		return valueConverterService.toValue(string, "ABBREV_IRI", null) as String
	}
	
}