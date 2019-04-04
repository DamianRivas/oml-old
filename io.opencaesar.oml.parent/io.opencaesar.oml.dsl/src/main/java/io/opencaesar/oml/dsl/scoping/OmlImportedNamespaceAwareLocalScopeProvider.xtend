package io.opencaesar.oml.dsl.scoping

import com.google.common.collect.Lists
import com.google.inject.Inject
import java.util.List
import io.opencaesar.oml.Graph
import io.opencaesar.oml.GraphImport
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import io.opencaesar.oml.dsl.naming.OmlNamespaceImportNormalizer

class OmlImportedNamespaceAwareLocalScopeProvider extends ImportedNamespaceAwareLocalScopeProvider{

	@Inject IQualifiedNameConverter qnc

	override String getImportedNamespace(EObject object) {
		var namespace = super.getImportedNamespace(object)
		if (namespace === null) {
			if (object instanceof GraphImport) {
				val graphResource = EcoreUtil2.getResource(object.eResource, object.importURI);
				if (graphResource !== null && !graphResource.contents.isEmpty) {
					val root = graphResource.contents.get(0)
					if (root instanceof Graph) {
						namespace = root.name
					}
				}
			}
		}
		return namespace;
	}

	protected def Graph getImportedGraph(EObject context) {
		if (context instanceof GraphImport) {
			val graphResource = EcoreUtil2.getResource(context.eResource, context.importURI);
			if (graphResource !== null && !graphResource.contents.isEmpty) {
				val root = graphResource.contents.get(0)
				if (root instanceof Graph) {
					return root
				}
			}
		}
		return null
	}

	override List<ImportNormalizer> internalGetImportedNamespaceResolvers(EObject context, boolean ignoreCase) {
		val importedNamespaceResolvers = Lists.newArrayList();
		
		// add the current graph
		if (context instanceof Graph) {
			importedNamespaceResolvers.add(new OmlNamespaceImportNormalizer(qnc.toQualifiedName(context.iri), context.name, ignoreCase))
		}
		
		val importAxioms = EcoreUtil2.getAllContentsOfType(context, GraphImport)
		// collect all local imports first (so they get priority)
		for (importAxiom : importAxioms) {
			val importPrefix = getImportedNamespace(importAxiom)
			val importedGraph = getImportedGraph(importAxiom)
			if (importPrefix !== null && importedGraph !== null && importedGraph.iri !== null) {
				importedNamespaceResolvers.add(new OmlNamespaceImportNormalizer(qnc.toQualifiedName(importedGraph.iri), importPrefix, ignoreCase))
			}
		}
		
		// then collect all imports transitively up the import chain
		for (importAxiom : importAxioms) {
			val importedGraph = getImportedGraph(importAxiom)
			if (importedGraph !== null) {
				importedNamespaceResolvers.addAll(internalGetImportedNamespaceResolvers(importedGraph, ignoreCase))
			}
		}
		return importedNamespaceResolvers;
	}

	
}