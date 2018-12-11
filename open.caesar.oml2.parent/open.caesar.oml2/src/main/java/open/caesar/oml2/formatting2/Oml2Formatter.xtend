/*
 * generated by Xtext 2.14.0
 */
package open.caesar.oml2.formatting2

import com.google.inject.Inject
import open.caesar.oml2.Extent
import open.caesar.oml2.Terminology
import open.caesar.oml2.services.Oml2GrammarAccess
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument

class Oml2Formatter extends AbstractFormatter2 {
	
	@Inject extension Oml2GrammarAccess

	def dispatch void format(Extent extent, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (module : extent.modules) {
			module.format
		}
	}

	def dispatch void format(Terminology terminology, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (terminologyStatement : terminology.statements) {
			terminologyStatement.format
		}
	}
	
	// TODO: implement for 
}