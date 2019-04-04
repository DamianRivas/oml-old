package io.opencaesar.oml.dsl.conversion

import com.google.inject.Inject
import org.eclipse.xtext.common.services.DefaultTerminalConverters
import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverter

class OmlValueConverterService extends DefaultTerminalConverters {

	@Inject ABBREV_IRIValueConverter abbrev_iriValueConverter

	@Inject IRIValueConverter iriValueConverter

	@Inject QNameValueConverter qnameValueConverter

	@ValueConverter(rule="ABBREV_IRI")
	def IValueConverter<String> getABBREV_IRIConverter() {
		abbrev_iriValueConverter
	}

	@ValueConverter(rule="IRI")
	def IValueConverter<String> getIRIConverter() {
		iriValueConverter
	}

	@ValueConverter(rule="Reference")
	def IValueConverter<String> getReferenceConverter() {
		qnameValueConverter
	}

	@ValueConverter(rule="QName")
	def IValueConverter<String> getQNameConverter() {
		qnameValueConverter
	}
}
