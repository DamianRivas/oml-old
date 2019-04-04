package io.opencaesar.oml.dsl.ide.symbols

import io.opencaesar.oml.Graph
import io.opencaesar.oml.NamedElement
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ide.server.symbol.DocumentSymbolMapper.DocumentSymbolNameProvider

class OmlDocumentSymbolNameProvider extends DocumentSymbolNameProvider {

	override getName(EObject object) {
		if (object instanceof Graph) {
			return object.iri
		} else if (object instanceof NamedElement) {
			return object.name
		}
		return "<unnamed>"
	}

}
