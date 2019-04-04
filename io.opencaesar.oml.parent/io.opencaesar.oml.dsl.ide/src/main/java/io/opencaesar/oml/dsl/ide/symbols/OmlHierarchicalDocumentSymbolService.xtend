package io.opencaesar.oml.dsl.ide.symbols

import io.opencaesar.oml.NamedElement
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.ide.server.symbol.HierarchicalDocumentSymbolService

import static extension com.google.common.collect.Iterators.*

class OmlHierarchicalDocumentSymbolService extends HierarchicalDocumentSymbolService {

	override protected getAllContents(Resource resource) {
		return resource.allContents.filter(NamedElement).filter(Object);
	}

}
