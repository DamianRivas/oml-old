package io.opencaesar.oml.dsl.resource

import com.google.inject.Inject
import java.util.HashMap
import io.opencaesar.oml.Graph
import io.opencaesar.oml.NamedElement
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy
import org.eclipse.xtext.scoping.impl.ImportUriResolver
import org.eclipse.xtext.util.IAcceptor

import static extension io.opencaesar.oml.Oml.*

class OmlResourceDescriptionStrategy extends DefaultResourceDescriptionStrategy {
	
	public static val IMPORTS = "imports"
	
	@Inject ImportUriResolver uriResolver

	override boolean createEObjectDescriptions(EObject eObject, IAcceptor<IEObjectDescription> acceptor) {
		if(eObject instanceof Graph) {
			this.createEObjectDescriptionForGraph(eObject, acceptor)
			return true
		}
		else if (eObject instanceof NamedElement) {
			return super.createEObjectDescriptions(eObject, acceptor)
		}
		return false
	}

	def createEObjectDescriptionForGraph(Graph graph, IAcceptor<IEObjectDescription> acceptor) {
		val uris = newArrayList()
		graph.imports.forEach[uris.add(uriResolver.apply(it))]
		val userData = new HashMap<String, String>
		userData.put(IMPORTS, uris.join(","))
		acceptor.accept(EObjectDescription.create(QualifiedName.create(graph.eResource.URI.toString), graph, userData))
	}
}