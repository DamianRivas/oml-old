package io.opencaesar.oml

import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.EcoreUtil

class Oml {
	
	// Resource
	
	static def getGraph(Resource resource) {
		val head = resource.contents.head
		if (head instanceof Graph) {
			head
		}
	}
	
	// Element
	
	static def getGraph(Element element) {
		var EObject current = element
		while (current !== null && !(current instanceof Graph)) {
			current = current.eContainer
		}
		current as Graph
	}
	
	static def getId(Element element) {
		EcoreUtil.getID(element)
	}
	
	// Annotation
	
	static def getAnnotatedElement(Annotation annotation) {
		if (annotation.eContainer instanceof NamedElementReference) {
			(annotation.eContainer as NamedElementReference).resolve
		} else {
			annotation.eContainer as AnnotatedElement
		}
	}
	
	// AnnotatedElement
	
	// NamedElement
	
	static def String getLocalName(NamedElement element, Resource resource) {
		if (element.eResource == resource) {
			element.name
		} else if (element instanceof Graph) {
			resource.graph?.allImports.findFirst[importedGraph == element]?.importAlias
		} else {
			resource.graph?.allImports.findFirst[importedGraph == element.graph]?.importAlias?.concat(':'+element.name)
		} 
	}
	
	// Graph
	
	static def GraphImport[] getImports(Graph graph) {
		if (graph instanceof Terminology) {
			graph.imports
		} else if (graph instanceof Description) {
			graph.imports
		}
	}
	
	static def Collection<GraphImport> getAllImports(Graph graph) {
		val map = new HashMap<String, GraphImport>
		graph.imports.forEach[a|
			map.put(a.importAlias, a)
		]
		graph.imports.map[importedGraph].forEach[g|
			g.allImports.forEach[a|
				if (!map.containsKey(a.importAlias)) {
					map.put(a.importAlias, a)
				}
			]
		]
		map.values
	}
	
	static def GraphStatement[] getStatements(Graph graph) {
		if (graph instanceof Terminology) {
			graph.statements
		} else if (graph instanceof Description) {
			graph.statements
		}
	}

	static def GraphMember[] getMembers(Graph graph) {
		if (graph instanceof Terminology) {
			graph.members
		} else if (graph instanceof Description) {
			graph.members
		}
	}

	static def GraphMemberReference[] getMemberReferences(Graph graph) {
		if (graph instanceof Terminology) {
			graph.memberReferences
		} else if (graph instanceof Description) {
			graph.memberReferences
		}
	}

	// Terminology

	static def TerminologyMember[] getMembers(Terminology terminology) {
		val members = new ArrayList
		members += terminology.statements.filter(TerminologyMember)
		members += members.filter(ReifiedRelationship).map[a|a.unidirectionalRelationships].flatten
		members
	}

	static def TerminologyMemberReference[] getMemberReferences(Terminology terminology) {
		terminology.statements.filter(TerminologyMemberReference)
	}

	// Description

	static def DescriptionMember[] getMembers(Description description) {
		description.statements.filter(DescriptionMember)
	}

	static def DescriptionMemberReference[] getMemberReferences(Description description) {
		description.statements.filter(DescriptionMemberReference)
	}
	
	// GraphMember
	
	static def String getIri(GraphMember member) {
		member.graph.iri + member.name
	}
	
	// TerminologyMember
	
	static def Terminology getTerminology(TerminologyMember member) {
		member.graph as Terminology
	}

	// Term

	static def Term[] getSpecializedTerms(Term term) {
		term.specializations.map[specializedTerm]
	}
	
	// CharacterizableTerm
	
	// Entity
	
	static def Aspect[] getSpecializedAspects(Entity entity) {
		entity.specializedTerms.filter(Aspect)
	}

	// Aspect
	
	// Concept
	
	static def Concept[] getSpecializedConcepts(Concept concept) {
		concept.specializedTerms.filter(Concept)
	}

	// ReifiedRelationship
	
	static def ReifiedRelationship[] getSpecializedReifiedRelationships(ReifiedRelationship relationship) {
		relationship.specializedTerms.filter(ReifiedRelationship)
	}
	
	static def getUnidirectionalRelationships(ReifiedRelationship relationship) {
		val unidirectional = new ArrayList<ReifiedUnidirectionalRelationship>
		if (relationship.forward !== null) {
			unidirectional += relationship.forward
		}
		if (relationship.inverse !== null) {
			unidirectional += relationship.inverse
		}
		unidirectional
	}
	
	// Structure
	
	// Relationship
	
	// UnreifiedRelationship

	static def UnreifiedRelationship[] getSpecializedUnreifiedRelationships(UnreifiedRelationship relationship) {
		relationship.specializations.map[specializedTerm].filter(UnreifiedRelationship)
	}
	
	// ScalarRange
	
	static def ScalarRange getSpecializedScalarRange(ScalarRange scalar) {
		scalar.specializations.map[specializedTerm].filter(ScalarRange).head
	}
	
	// Scalar
	
	// CharArrayScalar
	
	// BinaryScalar
	
	// PatternScalar
	
	// IRIScalar
	
	// PlainLiteralScalar
	
	// StringScalar
	
	// NumericScalar
	
	// TimeScalar
	
	// EnumerationScalar
	
	// Property
	
	// CharacterizationProperty
	
	// StructuredProperty
	
	static def StructuredProperty[] getSpecializedStructuredProperty(StructuredProperty property) {
		property.specializations.map[specializedTerm].filter(StructuredProperty)
	}

	// ScalarProperty
	
	static def ScalarProperty[] getSpecializedScalarProperty(ScalarProperty property) {
		property.specializations.map[specializedTerm].filter(ScalarProperty)
	}
	
	// AnnotationProperty
	
	// Rule

	// UnidirectionalRelationship
	
	static def Terminology getTerminology(UnidirectionalRelationship relationship) {
		relationship.graph as Terminology
	}

	// ReifiedUnidirectionalRelationship
	
	static def ReifiedRelationship getReifiedRelationship(ReifiedUnidirectionalRelationship relationship) {
		relationship.eContainer as ReifiedRelationship
	}
	
	static def String getSourceIri(ReifiedUnidirectionalRelationship relationship) {
		relationship.iri + 'Source'
	}
	
	static def String getTargetIri(ReifiedUnidirectionalRelationship relationship) {
		relationship.iri + 'Target'
	}

	// ForwardRelationship
	
	static def Entity getSource(ForwardRelationship relationship) {
		(relationship.eContainer as ReifiedRelationship).source
	}
	
	static def Entity getTarget(ForwardRelationship relationship) {
		(relationship.eContainer as ReifiedRelationship).target
	}
	
	static def InverseRelationship getInverseRelationship(ForwardRelationship relationship) {
		relationship.reifiedRelationship.inverse
	}
	
	// InverseRelationship

	static def Entity getSource(InverseRelationship relationship) {
		(relationship.eContainer as ReifiedRelationship).target
	}

	static def Entity getTarget(InverseRelationship relationship) {
		(relationship.eContainer as ReifiedRelationship).source
	}

	static def ForwardRelationship getForwardRelationship(InverseRelationship relationship) {
		relationship.reifiedRelationship.forward
	}
	
	// DescriptionMember
	
	static def Description getDescription(DescriptionMember member) {
		member.graph as Description
	}
	
	// NamedInstance
	
	// ConceptInstance
	
	// ReifiedRelationshipInstance
	
	// NamedElementReference

	// GraphMemberReference
	
	// TerminologyMemberReference
	
	// TermReference
	
	// EntityReference
	
	// AspectReference
	
	static dispatch def Aspect resolve(AspectReference reference) {
		reference.aspect
	}
	
	// ConceptReference

	static dispatch def Concept resolve(ConceptReference reference) {
		reference.concept
	}

	// ReifiedRelationshipReference

	static dispatch def ReifiedRelationship resolve(ReifiedRelationshipReference reference) {
		reference.relationship
	}
	
	// UnreifiedRelationshipReference
	
	static dispatch def UnreifiedRelationship resolve(UnreifiedRelationshipReference reference) {
		reference.relationship
	}

	// StructureReference
	
	static dispatch def Structure resolve(StructureReference reference) {
		reference.structure
	}
	
	// ScalarRangeReference
	
	static dispatch def ScalarRange resolve(ScalarRangeReference reference) {
		reference.scalar
	}

	// StructuredPropertyReference
	
	static dispatch def StructuredProperty resolve(StructuredPropertyReference reference) {
		reference.property
	}

	// ScalarPropertyReference
	
	static dispatch def ScalarProperty resolve(ScalarPropertyReference reference) {
		reference.property
	}
	
	// UnidirectionalRelationshipReference

	// ReifiedUnidirectionalRelationshipReference
	
	static dispatch def ReifiedUnidirectionalRelationship resolve(ReifiedUnidirectionalRelationshipReference reference) {
		reference.relationship
	}
	
	// RuleReference

	static dispatch def Rule resolve(RuleReference reference) {
		reference.rule
	}
	
	// DescriptionMemberReference
	
	// NamedInstanceReference

	// ConceptInstanceReference
	
	static dispatch def ConceptInstance resolve(ConceptInstanceReference reference) {
		reference.instance
	}

	// ReifiedRelationshipInstanceReference
	
	static dispatch def ReifiedRelationshipInstance resolve(ReifiedRelationshipInstanceReference reference) {
		reference.instance
	}

	// Statement
	
	// TerminologyStatement
	
	// DescriptionStatement

	// Axiom

	// TermSpecializationAxiom

	static def Term getSpecializingTerm(TermSpecializationAxiom axiom) {
		if (axiom.eContainer instanceof TermReference) {
			(axiom.eContainer as TermReference).resolve as Term
		} else {
			axiom.eContainer as Term
		}
	}
	
	// EntityRestrictionAxiom
	
	static def getRestrictedEntity(EntityRestrictionAxiom axiom) {
		if (axiom.eContainer instanceof EntityReference) {
			(axiom.eContainer as EntityReference).resolve as Entity
		} else {
			axiom.eContainer as Entity
		}
	}
	
	// RelationshipRestrictionAxiom
	
	// ExistentialRelationshipRestrictionAxiom
	
	// UniversalRelationshipRestrictionAxiom
	
	// ScalarPropertyRestrictionAxiom
	
	// TypedScalarPropertyRestrictionAxion
	
	// ExistentialScalarPropertyRestrictionAxiom
	
	// UniversalScalarPropertyRestrictionAxiom
	
	// ParticularScalarPropertyRestrictionAxiom
	
	// StructuredPropertyRestrictionAxiom
	
	// ConceptInstanceTypeAxiom
	
	static def getConceptInstance(ConceptInstanceTypeAssertion assertion) {
		if (assertion.eContainer instanceof ConceptInstanceReference) {
			(assertion.eContainer as ConceptInstanceReference).resolve as ConceptInstance
		} else {
			assertion.eContainer as ConceptInstance
		}
	}

	// ReifiedRelationshipInstanceTypeAxiom

	static def getReifiedRelationshipInstance(ReifiedRelationshipInstanceTypeAssertion assertion) {
		if (assertion.eContainer instanceof ReifiedRelationshipInstanceReference) {
			(assertion.eContainer as ReifiedRelationshipInstanceReference).resolve as ReifiedRelationshipInstance
		} else {
			assertion.eContainer as ReifiedRelationshipInstance
		}
	}
	
	// Assertion
	
	// InstancePropertyValueAssertion

	static def getInstance(InstancePropertyValueAssertion assertion) {
		if (assertion.eContainer instanceof NamedInstanceReference) {
			(assertion.eContainer as NamedInstanceReference).resolve as NamedInstance
		} else {
			assertion.eContainer as Instance
		}
	}
	
	// ScalarPropertyValueAssertion
	
	// StructuredPropertyValueAssertion
	
	// GraphImport

	static def String getImportAlias(GraphImport axiom) {
		if (axiom.importedNamespace !== null) {
			axiom.importedNamespace
		} else {
			axiom.getImportedGraph?.name
		}
	}
	
	static def Graph getImportedGraph(GraphImport axiom) {
		val contextURI = axiom.eResource.URI
		val newURI =URI.createURI(axiom.importURI).resolve(contextURI)
		val resource = axiom.eResource.getResourceSet().getResource(newURI, true)
		resource.contents.filter(Graph).findFirst[true]
	}
	
	// TerminologyImport
	
	static def getTerminology(TerminologyImport _import) {
		_import.eContainer as Terminology
	}
	
	// TerminologyExtension
	
	// DescriptionImport

	static def getDescription(DescriptionImport _import) {
		_import.eContainer as Description
	}
	
	// DescriptionUsage
	
	// DescriptionRefinement
	
	// Instance
	
	// StructureInstance
	
	static def getDeclaringAxiom(StructureInstance instance) {
		if (instance.eContainer instanceof StructuredPropertyRestrictionAxiom) {
			instance.eContainer as StructuredPropertyRestrictionAxiom
		}
	}
	
	static def getDeclaringAssertion(StructureInstance instance) {
		if (instance.eContainer instanceof StructuredPropertyValueAssertion) {
			instance.eContainer as StructuredPropertyValueAssertion
		}
	}

	// LiteralValue
	
	// LiteralBoolean
	
	// LiteralDateTime
	
	// LiteralString
	
	// LiteralUUID
	
	// LiteralURI
	
	// LiteralNumber
	
	// LiteralReal
	
	// LiteralRational
	
	// LiteralFloat
	
	// LiteralDecimal
	
	// Predicate

	static def getRule(Predicate predicate) {
		predicate.eContainer as Rule
	}

	// EntityPredicate

	static def variableIri(EntityPredicate predicate) {
		predicate.rule.graph.iri+predicate.variable
	}

	// RelationshipPredicate
	
	static def variable1Iri(RelationshipPredicate predicate) {
		predicate.rule.graph.iri+predicate.variable1
	}
	
	static def variable2Iri(RelationshipPredicate predicate) {
		predicate.rule.graph.iri+predicate.variable2
	}
	
	// UnidirectionalRelationshipPredicate
	
	// ReifiedRelationshipPredicate
}