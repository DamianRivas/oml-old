package io.opencaesar.oml.dsl.ide.symbols

import org.eclipse.xtext.ide.server.symbol.DocumentSymbolMapper.DocumentSymbolKindProvider
import org.eclipse.emf.ecore.EClass

import static io.opencaesar.oml.OmlPackage.Literals.*
import static org.eclipse.lsp4j.SymbolKind.*

class OmlDocumentSymbolKindProvider extends DocumentSymbolKindProvider {

	override protected getSymbolKind(EClass clazz) {
		return switch (clazz) {
			case GRAPH.isSuperTypeOf(clazz): Package
			case ASPECT.isSuperTypeOf(clazz): Interface
			case CONCEPT.isSuperTypeOf(clazz): Class
			case STRUCTURE.isSuperTypeOf(clazz): Struct
			case SCALAR_RANGE.isSuperTypeOf(clazz): Enum
			case REIFIED_RELATIONSHIP.isSuperTypeOf(clazz): Class
			case UNREIFIED_RELATIONSHIP.isSuperTypeOf(clazz): Property
			case FORWARD_DIRECTION.isSuperTypeOf(clazz): Property
			case INVERSE_DIRECTION.isSuperTypeOf(clazz): Property
			case SCALAR_PROPERTY.isSuperTypeOf(clazz): Property
			case STRUCTURED_PROPERTY.isSuperTypeOf(clazz): Property
			case CONCEPT_INSTANCE.isSuperTypeOf(clazz): Object
			case REIFIED_RELATIONSHIP_INSTANCE.isSuperTypeOf(clazz): Object
			default: Property
		}
	}

}
