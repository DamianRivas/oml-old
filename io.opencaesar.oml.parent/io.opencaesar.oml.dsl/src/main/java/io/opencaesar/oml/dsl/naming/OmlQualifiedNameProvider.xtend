package io.opencaesar.oml.dsl.naming

import io.opencaesar.oml.Graph
import io.opencaesar.oml.GraphMember
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName

import static extension io.opencaesar.oml.Oml.*

class OmlQualifiedNameProvider extends DefaultDeclarativeQualifiedNameProvider {
	
	def QualifiedName qualifiedName(GraphMember member) {
		qualifiedName(member.graph).append(member.name)
	}

	def QualifiedName qualifiedName(Graph graph) {
		converter.toQualifiedName(graph.iri)
	}
	
}
