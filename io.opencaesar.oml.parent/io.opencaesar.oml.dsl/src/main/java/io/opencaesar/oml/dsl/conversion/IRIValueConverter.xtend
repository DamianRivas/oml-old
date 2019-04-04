package io.opencaesar.oml.dsl.conversion

import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.conversion.impl.AbstractValueConverter
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.util.Strings

class IRIValueConverter extends AbstractValueConverter<String> {

	override String toString(String value) {
		if (value.startsWith("http://") || value.contains(".oml")) {
			return '<' + Strings.convertToJavaString(value, false) + '>'
		} else {
			return elseToString(value)
		}
	}

	def elseToString(String value) {
		return Strings.convertToJavaString(value, false)
	}

	override toValue(String string, INode node) {
		if (string === null) {
			return null;
		}
		try {
			if (string.startsWith('<') && string.endsWith('>')) {
				return Strings.convertFromJavaString(string.substring(1, string.length() - 1), true);
			} else {
				return elseToValue(string, node)
			}
		} catch (IllegalArgumentException e) {
			throw new ValueConverterException(e.getMessage(), node, e);
		}
	}
	
	def elseToValue(String string, INode node) {
		return Strings.convertFromJavaString(string, true)
	}
	
}