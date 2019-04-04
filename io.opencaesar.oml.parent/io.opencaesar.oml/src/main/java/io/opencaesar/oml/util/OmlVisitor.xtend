package io.opencaesar.oml.util

import io.opencaesar.oml.Element
import org.eclipse.emf.ecore.resource.Resource

/*
 * Subclasses should override the <code>visit</code> method a parameter typed by <code>Element</code> or one of its subtypes 
 */
abstract class OmlVisitor {

	protected def void run(Resource resource) {
		resource.allContents.filter(Element).forEach[visit]
	}

	protected abstract def void visit(Element element)

	protected def void _visit(Element element) {
	 	// Fall-back for types that are not handled by a subclasse's dispatch method.
	}

}