package io.opencaesar.oml.util

import io.opencaesar.oml.Annotation
import io.opencaesar.oml.AnnotationProperty
import io.opencaesar.oml.Aspect
import io.opencaesar.oml.AspectReference
import io.opencaesar.oml.Assertion
import io.opencaesar.oml.Axiom
import io.opencaesar.oml.BinaryScalar
import io.opencaesar.oml.CharacterizableTerm
import io.opencaesar.oml.Concept
import io.opencaesar.oml.ConceptInstance
import io.opencaesar.oml.ConceptInstanceReference
import io.opencaesar.oml.ConceptInstanceTypeAssertion
import io.opencaesar.oml.ConceptReference
import io.opencaesar.oml.Description
import io.opencaesar.oml.DescriptionKind
import io.opencaesar.oml.DescriptionRefinement
import io.opencaesar.oml.DescriptionStatement
import io.opencaesar.oml.DescriptionUsage
import io.opencaesar.oml.Element
import io.opencaesar.oml.Entity
import io.opencaesar.oml.EntityPredicate
import io.opencaesar.oml.EntityReference
import io.opencaesar.oml.EnumerationScalar
import io.opencaesar.oml.ExistentialRelationshipRestrictionAxiom
import io.opencaesar.oml.ExistentialScalarPropertyRestrictionAxiom
import io.opencaesar.oml.ForwardRelationship
import io.opencaesar.oml.Graph
import io.opencaesar.oml.GraphMember
import io.opencaesar.oml.GraphMemberReference
import io.opencaesar.oml.IRIScalar
import io.opencaesar.oml.InverseRelationship
import io.opencaesar.oml.LiteralBoolean
import io.opencaesar.oml.LiteralDateTime
import io.opencaesar.oml.LiteralDecimal
import io.opencaesar.oml.LiteralFloat
import io.opencaesar.oml.LiteralNumber
import io.opencaesar.oml.LiteralRational
import io.opencaesar.oml.LiteralReal
import io.opencaesar.oml.LiteralString
import io.opencaesar.oml.LiteralURI
import io.opencaesar.oml.LiteralUUID
import io.opencaesar.oml.LiteralValue
import io.opencaesar.oml.NamedInstance
import io.opencaesar.oml.NamedInstanceReference
import io.opencaesar.oml.NumericScalar
import io.opencaesar.oml.OmlFactory2
import io.opencaesar.oml.OmlPackage
import io.opencaesar.oml.ParticularScalarPropertyRestrictionAxiom
import io.opencaesar.oml.PlainLiteralScalar
import io.opencaesar.oml.Predicate
import io.opencaesar.oml.ReifiedRelationship
import io.opencaesar.oml.ReifiedRelationshipInstance
import io.opencaesar.oml.ReifiedRelationshipInstanceReference
import io.opencaesar.oml.ReifiedRelationshipInstanceTypeAssertion
import io.opencaesar.oml.ReifiedRelationshipPredicate
import io.opencaesar.oml.ReifiedRelationshipPredicateKind
import io.opencaesar.oml.ReifiedRelationshipReference
import io.opencaesar.oml.ReifiedUnidirectionalRelationship
import io.opencaesar.oml.ReifiedUnidirectionalRelationshipReference
import io.opencaesar.oml.Rule
import io.opencaesar.oml.RuleReference
import io.opencaesar.oml.Scalar
import io.opencaesar.oml.ScalarProperty
import io.opencaesar.oml.ScalarPropertyReference
import io.opencaesar.oml.ScalarPropertyValueAssertion
import io.opencaesar.oml.ScalarRange
import io.opencaesar.oml.ScalarRangeReference
import io.opencaesar.oml.StringScalar
import io.opencaesar.oml.Structure
import io.opencaesar.oml.StructureInstance
import io.opencaesar.oml.StructureReference
import io.opencaesar.oml.StructuredProperty
import io.opencaesar.oml.StructuredPropertyReference
import io.opencaesar.oml.StructuredPropertyRestrictionAxiom
import io.opencaesar.oml.StructuredPropertyValueAssertion
import io.opencaesar.oml.Term
import io.opencaesar.oml.TermReference
import io.opencaesar.oml.TermSpecializationAxiom
import io.opencaesar.oml.Terminology
import io.opencaesar.oml.TerminologyExtension
import io.opencaesar.oml.TerminologyKind
import io.opencaesar.oml.TerminologyStatement
import io.opencaesar.oml.TimeScalar
import io.opencaesar.oml.UnidirectionalRelationship
import io.opencaesar.oml.UnidirectionalRelationshipPredicate
import io.opencaesar.oml.UniversalRelationshipRestrictionAxiom
import io.opencaesar.oml.UniversalScalarPropertyRestrictionAxiom
import io.opencaesar.oml.UnreifiedRelationship
import io.opencaesar.oml.UnreifiedRelationshipReference
import java.io.File
import java.math.BigDecimal
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

import static extension io.opencaesar.oml.Oml.*

class OmlWriter {
	
	var pathExtension = '.oml'

	val roots = new HashMap<String, Graph>
	val cache = new HashMap<String, EObject>
	val defer = new ArrayList<Runnable>
	
	protected def <T extends Element> create(Class<T> type) {
		OmlFactory2.INSTANCE.create(type)
	}
	
	protected def <T extends GraphMember> T create(Class<T> type, String iri) {
		val object = OmlFactory2.INSTANCE.create(type)
		cache.put(iri, object)
		return object
	}
	
	protected def <T extends GraphMember> resolve(Class<T> type, String iri) {
		cache.get(iri) as T
	}
	
	protected def <T extends GraphMemberReference> T getOrCreateReference(Graph graph, GraphMember member, Class<T> type) {
		var reference = graph.memberReferences.findFirst[resolve == member] as T
		if (reference === null) {
			reference = member.createReference as T
			if (graph instanceof Terminology) {
				graph.statements.add(reference as TerminologyStatement) 
			} else if (graph instanceof Description) {
				graph.statements.add(reference as DescriptionStatement) 
			}
		}
		reference
	}
	
	def void addGraph(Graph graph) {
		graph.members.forEach[member|cache.put(member.iri, member)]
	}
	
	def void setPathExtension(String pathExtension) {
		this.pathExtension = pathExtension
	}

	def start() {
		createBuiltInVocabularies()
	}
	
	def finish(ResourceSet resourceSet, String baseURI) {
		defer.forEach[run]
		roots.forEach[relativePath, graph|
			val file = new File(baseURI+'/'+relativePath)
			var resourceURI = URI.createFileURI(file.canonicalPath)
			var resource = resourceSet.createResource(resourceURI)
			resource.contents.add(graph)
		]
	}

	// Annotation

	def addAnnotation(Graph graph, String elementIri, String propertyIri, LiteralValue value) {
		val annotation = create(Annotation)
		defer.add [annotation.property = resolve(AnnotationProperty, propertyIri)]
		annotation.value = value
		defer.add [
			val element = resolve(GraphMember, elementIri)
			if (element.graph == graph) {
				element.annotations += annotation
			} else {
				graph.getOrCreateReference(element, GraphMemberReference).annotations += annotation 
			}
		]
		return annotation
	}

	def addAnnotation(Graph graph, GraphMember element, String propertyIri, LiteralValue value) {
		addAnnotation(graph, element.iri, propertyIri, value)
	}
	
	def addAnnotation(Graph graph, String propertyIri, LiteralValue value) {
		val annotation = create(Annotation)
		defer.add [annotation.property = resolve(AnnotationProperty, propertyIri)]
		annotation.value = value
		graph.annotations += annotation
		return annotation
	}

	def addAnnotation(Axiom axiom, String propertyIri, LiteralValue value) {
		val annotation = create(Annotation)
		defer.add [annotation.property = resolve(AnnotationProperty, propertyIri)]
		annotation.value = value
		axiom.annotations += annotation
		return annotation
	}

	def addAnnotation(Assertion assertion, String propertyIri, LiteralValue value) {
		val annotation = create(Annotation)
		defer.add [annotation.property = resolve(AnnotationProperty, propertyIri)]
		annotation.value = value
		assertion.annotations += annotation
		return annotation
	}

	// Terminology

	def createTerminology(TerminologyKind kind, String iri, String name, String relativePath) {
		val terminology = create(Terminology)
		terminology.kind = kind
		terminology.iri = iri
		terminology.name = name
		roots.put(relativePath, terminology)
		return terminology
	}
	
	// Description
	
	def createDescription(DescriptionKind kind, String iri, String name, String relativePath) {
		val description = create(Description)
		description.kind = kind
		description.iri = iri
		description.name = name
		roots.put(relativePath, description)
		return description
	}

	// Aspect

	def addAspect(Terminology terminology, String name) {
		val aspect = create(Aspect, terminology.iri+name)
		aspect.name = name
		terminology.statements += aspect
		return aspect
	}
	
	// Concept

	def addConcept(Terminology terminology, String name) {
		val concept = create(Concept, terminology.iri+name)
		concept.name = name
		terminology.statements += concept
		return concept
	}

	// ReifiedRelationship
	
	def addReifiedRelationship(
		Terminology terminology, String name, String sourceIri, String targetIri, 
		boolean functional, boolean inverseFunctional, boolean symmetric, 
		boolean asymmetric, boolean reflexive, boolean irreflexive, boolean transitive) {
		val relationship = create(ReifiedRelationship, terminology.iri+name)
		relationship.name = name
		defer.add [relationship.source = resolve(Entity, sourceIri)]
		defer.add [relationship.target = resolve(Entity, targetIri)]
		relationship.functional = functional
		relationship.inverseFunctional = inverseFunctional
		relationship.symmetric = symmetric
		relationship.asymmetric = asymmetric
		relationship.reflexive = reflexive
		relationship.irreflexive = irreflexive
		relationship.transitive = transitive
		terminology.statements += relationship
		return relationship
	}

	// UnreifiedRelationship

	def addUnreifiedRelationship(
		Terminology terminology, String name, String sourceIri, String targetIri, 
		boolean functional, boolean inverseFunctional, boolean symmetric, 
		boolean asymmetric, boolean reflexive, boolean irreflexive, boolean transitive) {
		val relationship = create(UnreifiedRelationship, terminology.iri+name)
		relationship.name = name
		defer.add [relationship.source = resolve(Entity, sourceIri)]
		defer.add [relationship.target = resolve(Entity, targetIri)]
		relationship.functional = functional
		relationship.inverseFunctional = inverseFunctional
		relationship.symmetric = symmetric
		relationship.asymmetric = asymmetric
		relationship.reflexive = reflexive
		relationship.irreflexive = irreflexive
		relationship.transitive = transitive
		terminology.statements += relationship
		return relationship
	}

	// Structure

	def addStructure(Terminology terminology, String name) {
		val structure = create(Structure, terminology.iri+name)
		structure.name = name
		terminology.statements += structure
		return structure
	}
	
	// Scalar

	def addScalar(Terminology terminology, String name) {
		val scalar = create(Scalar, terminology.iri+name)
		scalar.name = name
		terminology.statements += scalar
		return scalar
	}
	
	// BinaryScalar

	def addBinaryScalar(Terminology terminology, String name,
		Integer length, Integer minLength, Integer maxLength) {
		val scalar = create(BinaryScalar, terminology.iri+name)
		scalar.name = name
		scalar.length = length
		scalar.minLength = minLength
		scalar.maxLength = maxLength
		terminology.statements += scalar
		return scalar
	}
	
	// IRIScalar

	def addIRIScalar(Terminology terminology, String name,
		Integer length, Integer minLength, Integer maxLength, String pattern) {
		val scalar = create(IRIScalar, terminology.iri+name)
		scalar.name = name
		scalar.length = length
		scalar.minLength = minLength
		scalar.maxLength = maxLength
		scalar.pattern = pattern
		terminology.statements += scalar
		return scalar
	}
	
	// PlainLiteralScalar

	def addPlainLiteralScalar(Terminology terminology, String name,
		Integer length, Integer minLength, Integer maxLength,
		String pattern, String language) {
		val scalar = create(PlainLiteralScalar, terminology.iri+name)
		scalar.name = name
		scalar.length = length
		scalar.minLength = minLength
		scalar.maxLength = maxLength
		scalar.pattern = pattern
		scalar.language = language
		terminology.statements += scalar
		return scalar
	}
	
	// StringScalar

	def addStringScalar(Terminology terminology, String name,
		Integer length, Integer minLength, Integer maxLength, String pattern) {
		val scalar = create(StringScalar, terminology.iri+name)
		scalar.name = name
		scalar.name = name
		scalar.length = length
		scalar.minLength = minLength
		scalar.maxLength = maxLength
		scalar.pattern = pattern
		terminology.statements += scalar
		return scalar
	}
	
	// NumericScalar

	def addNumericScalar(Terminology terminology, String name,
		LiteralNumber minInclusive, LiteralNumber minExclusive, 
		LiteralNumber maxInclusive, LiteralNumber maxExclusive) {
		val scalar = create(NumericScalar, terminology.iri+name)
		scalar.name = name
		scalar.minInclusive = minInclusive
		scalar.minExclusive = minExclusive
		scalar.maxInclusive = maxInclusive
		scalar.maxExclusive = maxExclusive
		terminology.statements += scalar
		return scalar
	}
	
	// TimeScalar

	def addTimeScalar(Terminology terminology, String name,
		LiteralDateTime minInclusive, LiteralDateTime minExclusive, 
		LiteralDateTime maxInclusive, LiteralDateTime maxExclusive) {
		val scalar = create(TimeScalar, terminology.iri+name)
		scalar.name = name
		scalar.minInclusive = minInclusive
		scalar.minExclusive = minExclusive
		scalar.maxInclusive = maxInclusive
		scalar.maxExclusive = maxExclusive
		terminology.statements += scalar
		return scalar
	}
	
	// EnumerationScalar

	def addEnumerationScalar(Terminology terminology, String name, LiteralValue...literals) {
		val scalar = create(EnumerationScalar, terminology.iri+name)
		scalar.name = name
		scalar.literals += literals
		terminology.statements += scalar
		return scalar
	}
	
	// StructuredProperty

	def addStructuredProperty(Terminology terminology, String name, 
		String domainIri, String rangeIri, boolean functional) {
		val property = create(StructuredProperty, terminology.iri+name)
		property.name = name
		defer.add [property.domain = resolve(CharacterizableTerm, domainIri)]
		defer.add [property.range = resolve(Structure, rangeIri)]
		property.functional = functional
		terminology.statements += property
		return property
	}
	
	// ScalarProperty

	def addScalarProperty(Terminology terminology, String name,
		String domainIri, String rangeIri, boolean functional) {
		val property = create(ScalarProperty, terminology.iri+name)
		property.name = name
		defer.add [property.domain = resolve(CharacterizableTerm, domainIri)]
		defer.add [property.range = resolve(ScalarRange, rangeIri)]
		property.functional = functional
		terminology.statements += property
		return property
	}
	
	// AnnotationProperty

	def addAnnotationProperty(Terminology terminology, String name) {
		val property = create(AnnotationProperty, terminology.iri+name)
		property.name = name
		terminology.statements += property
		return property
	}
	
	// Rule

	def addRule(Terminology terminology, String name, UnidirectionalRelationshipPredicate consequent, Predicate...antecedent) {
		val rule = create(Rule, terminology.iri+name)
		rule.name = name
		rule.consequent = consequent
		rule.antecedent += antecedent
		terminology.statements += rule
		return rule
	}
	
	// ForwardRelationship

	def addForwardRelationship(ReifiedRelationship relationship, String name) {
		val forward = create(ForwardRelationship, relationship.terminology.iri+name)
		forward.name = name
		relationship.forward = forward
		return forward
	}

	// InverseRelationship

	def addInverseRelationship(ReifiedRelationship relationship, String name) {
		val inverse = create(InverseRelationship, relationship.terminology.iri+name)
		inverse.name = name
		relationship.inverse = inverse
		return inverse
	}
	
	// ConceptInstance

	def addConceptInstance(Description description, String name) {
		val instance = create(ConceptInstance, description.iri+name)
		instance.name = name
		description.statements += instance
		return instance
	}
	
	// ReifiedRelationshipInstance

	def addReifiedRelationshipInstance(Description description, String name, 
		String sourceIri, String targetIri) {
		val instance = create(ReifiedRelationshipInstance, description.iri+name)
		instance.name = name
		defer.add [instance.source = resolve(NamedInstance, sourceIri)]
		defer.add [instance.target = resolve(NamedInstance, targetIri)]
		description.statements += instance
		return instance
	}

	// AspectReference
	
	def dispatch createReference(Aspect aspect) {
		val reference = create(AspectReference)
		reference.aspect = aspect
		return reference
	}

	// ConceptReference

	def dispatch createReference(Concept concept) {
		val reference = create(ConceptReference)
		reference.concept = concept
		return reference
	}
	
	// ReifiedRelationshipReference

	protected def dispatch createReference(ReifiedRelationship relationship) {
		val reference = create(ReifiedRelationshipReference)
		reference.relationship = relationship
		return reference
	}
	
	// UnreifiedRelationshipReference

	protected def dispatch createReference(UnreifiedRelationship relationship) {
		val reference = create(UnreifiedRelationshipReference)
		reference.relationship = relationship
		return reference
	}
	
	// StructureReference

	protected def dispatch createReference(Structure structure) {
		val reference = create(StructureReference)
		reference.structure = structure
		return reference
	}
	
	// ScalarRangeReference

	protected def dispatch createReference(ScalarRange scalar) {
		val reference = create(ScalarRangeReference)
		reference.scalar = scalar
		return reference
	}
	
	// StructuredPropertyReference

	protected def dispatch createReference(StructuredProperty property) {
		val reference = create(StructuredPropertyReference)
		reference.property = property
		return reference
	}
	
	// ScalarPropertyReference

	protected def dispatch createReference(ScalarProperty property) {
		val reference = create(ScalarPropertyReference)
		reference.property = property
		return reference
	}
	
	// ReifiedUnidirectionalRelationshipReference

	protected def dispatch createReference(ReifiedUnidirectionalRelationship relationship) {
		val reference = create(ReifiedUnidirectionalRelationshipReference)
		reference.relationship = relationship
		return reference
	}
	
	// RuleReference

	protected def dispatch createReference(Rule rule) {
		val reference = create(RuleReference)
		reference.rule = rule
		return reference
	}
	
	// ConceptInstanceReference

	protected def dispatch createReference(ConceptInstance instance) {
		val reference = create(ConceptInstanceReference)
		reference.instance = instance
		return reference
	}

	// ReifiedRelationshipInstanceReference

	protected def dispatch createReference(ReifiedRelationshipInstance instance) {
		val reference = create(ReifiedRelationshipInstanceReference)
		reference.instance = instance
		return reference
	}
	
	// TermSpecializationAxiom

	def addTermSpecializationAxiom(Terminology terminology, String specializingIri, String specializedIri) {
		val axiom = create(TermSpecializationAxiom)
		defer.add [axiom.specializedTerm = resolve(Term, specializedIri)]
		defer.add [
			val specializing = resolve(Term, specializingIri)
			if (specializing.terminology == terminology) {
				specializing.specializations += axiom
			} else {
				terminology.getOrCreateReference(specializing, TermReference).specializations += axiom 
			}
		]
		return axiom
	}
	
	def addTermSpecializationAxiom(Terminology terminology, Term specializing, String specializedIri) {
		addTermSpecializationAxiom(terminology, specializing.iri, specializedIri)
	}

	// ExistentialRelationshipRestrictionAxiom

	def addExistentialRelationshipRestrictionAxiom(Terminology terminology, String entityIri, String relationshipIri, String typeIri) {
		val axiom = create(ExistentialRelationshipRestrictionAxiom)
		defer.add [axiom.relationship = resolve(UnidirectionalRelationship, relationshipIri)]
		defer.add [axiom.restrictedTo = resolve(Entity, typeIri)]
		defer.add [
			val entity = resolve(Entity, entityIri)
			if (entity.terminology == terminology) {
				entity.restrictions += axiom
			} else {
				terminology.getOrCreateReference(entity, EntityReference).restrictions += axiom 
			}
		]
		return axiom
	}
	
	def addExistentialRelationshipRestrictionAxiom(Terminology terminology, Entity entity, String relationshipIri, String typeIri) {
		addExistentialRelationshipRestrictionAxiom(terminology, entity.iri, relationshipIri, typeIri)
	}
	
	// UniversalRelationshipRestrictionAxiom

	def addUniversalRelationshipRestrictionAxiom(Terminology terminology, String entityIri, String relationshipIri, String typeIri) {
		val axiom = create(UniversalRelationshipRestrictionAxiom)
		defer.add [axiom.relationship = resolve(UnidirectionalRelationship, relationshipIri)]
		defer.add [axiom.restrictedTo = resolve(Entity, typeIri)]
		defer.add [
			val entity = resolve(Entity, entityIri)
			if (entity.terminology == terminology) {
				entity.restrictions += axiom
			} else {
				terminology.getOrCreateReference(entity, EntityReference).restrictions += axiom 
			}
		]
		return axiom
	}

	def addUniversalRelationshipRestrictionAxiom(Terminology terminology, Entity entity, String relationshipIri, String typeIri) {
		addUniversalRelationshipRestrictionAxiom(terminology, entity.iri, relationshipIri, typeIri)
	}
	
	// ExistentialScalarPropertyRestrictionAxiom

	def addExistentialScalarPropertyRestrictionAxiom(Terminology terminology, String entityIri, String propertyIri, String typeIri) {
		val axiom = create(ExistentialScalarPropertyRestrictionAxiom)
		defer.add [axiom.property = resolve(ScalarProperty, propertyIri)]
		defer.add [axiom.restrictedTo = resolve(ScalarRange, typeIri)]
		defer.add [
			val entity = resolve(Entity, entityIri)
			if (entity.terminology == terminology) {
				entity.restrictions += axiom
			} else {
				terminology.getOrCreateReference(entity, EntityReference).restrictions += axiom 
			}
		]
		return axiom
	}

	def addExistentialScalarPropertyRestrictionAxiom(Terminology terminology, Entity entity, String propertyIri, String typeIri) {
		addExistentialScalarPropertyRestrictionAxiom(terminology, entity.iri, propertyIri, typeIri)
	}

	// UniversalScalarPropertyRestrictionAxiom

	def addUniversalScalarPropertyRestrictionAxiom(Terminology terminology, String entityIri, String propertyIri, String typeIri) {
		val axiom = create(UniversalScalarPropertyRestrictionAxiom)
		defer.add [axiom.property = resolve(ScalarProperty, propertyIri)]
		defer.add [axiom.restrictedTo = resolve(ScalarRange, typeIri)]
		defer.add [
			val entity = resolve(Entity, entityIri)
			if (entity.terminology == terminology) {
				entity.restrictions += axiom
			} else {
				terminology.getOrCreateReference(entity, EntityReference).restrictions += axiom 
			}
		]
		return axiom
	}

	def addUniversalScalarPropertyRestrictionAxiom(Terminology terminology, Entity entity, String propertyIri, String typeIri) {
		addUniversalScalarPropertyRestrictionAxiom(terminology, entity.iri, propertyIri, typeIri)
	}

	// ParticularScalarPropertyRestrictionAxiom

	def addParticularScalarPropertyRestrictionAxiom(Terminology terminology, String entityIri, String propertyIri, LiteralValue value) {
		val axiom = create(ParticularScalarPropertyRestrictionAxiom)
		axiom.value = value
		defer.add [axiom.property = resolve(ScalarProperty, propertyIri)]
		defer.add [
			val entity = resolve(Entity, entityIri)
			if (entity.terminology == terminology) {
				entity.restrictions += axiom
			} else {
				terminology.getOrCreateReference(entity, EntityReference).restrictions += axiom 
			}
		]
		return axiom
	}

	def addParticularScalarPropertyRestrictionAxiom(Terminology terminology, Entity entity, String propertyIri, LiteralValue value) {
		addParticularScalarPropertyRestrictionAxiom(terminology, entity.iri, propertyIri, value)
	}
	
	// StructuredPropertyRestrictionAxiom

	def addStructuredPropertyRestrictionAxiom(Terminology terminology, String entityIri, String propertyIri, StructureInstance value) {
		val axiom = create(StructuredPropertyRestrictionAxiom)
		axiom.value = value
		defer.add [axiom.property = resolve(StructuredProperty, propertyIri)]
		defer.add [
			val entity = resolve(Entity, entityIri)
			if (entity.terminology == terminology) {
				entity.restrictions += axiom
			} else {
				terminology.getOrCreateReference(entity, EntityReference).restrictions += axiom 
			}
		]
		return axiom
	}

	def addStructuredPropertyRestrictionAxiom(Terminology terminology, Entity entity, String propertyIri, StructureInstance value) {
		addStructuredPropertyRestrictionAxiom(terminology, entity.iri, propertyIri, value)
	}
	
	// ConceptInstanceTypeAssertion
	
	def addConceptInstanceTypeAssertion(Description description, String instanceIri, String conceptIri) {
		val axiom = create(ConceptInstanceTypeAssertion)
		defer.add [axiom.concept = resolve(Concept, conceptIri)]
		defer.add [
			val instance = resolve(ConceptInstance, instanceIri)
			if (instance.description == description) {
				instance.types += axiom
			} else {
				description.getOrCreateReference(instance, ConceptInstanceReference).types += axiom 
			}
		]
		return axiom
	}

	def addConceptInstanceTypeAssertion(Description description, ConceptInstance instance, String conceptIri) {
		addConceptInstanceTypeAssertion(description, instance.iri, conceptIri)
	}

	// ReifiedRelationshipInstanceTypeAssertion

	def addReifiedRelationshipInstanceTypeAssertion(Description description, String instanceIri, String relationshipIri) {
		val axiom = create(ReifiedRelationshipInstanceTypeAssertion)
		defer.add [axiom.relationship = resolve(ReifiedRelationship, relationshipIri)]
		defer.add [
			val instance = resolve(ReifiedRelationshipInstance, instanceIri)
			if (instance.description == description) {
				instance.types += axiom
			} else {
				description.getOrCreateReference(instance, ReifiedRelationshipInstanceReference).types += axiom 
			}
		]
		return axiom
	}

	def void addReifiedRelationshipInstanceTypeAssertion(Description description, ReifiedRelationshipInstance instance, String relationshipIri) {
		addReifiedRelationshipInstanceTypeAssertion(description, instance.iri, relationshipIri)
	}
	
	// ScalarPropertyValueAssertion

	def addScalarPropertyValueAssertion(Description description, String instanceIri, String propertyIri, LiteralValue value) {
		val assertion = create(ScalarPropertyValueAssertion)
		assertion.value = value
		defer.add [assertion.property = resolve(ScalarProperty, propertyIri)]
		defer.add [		
			val instance = resolve(NamedInstance, instanceIri)
			if (instance.description == description) {
				instance.propertyValues += assertion
			} else {
				description.getOrCreateReference(instance, NamedInstanceReference).propertyValues += assertion 
			}
		]
		return assertion
	}

	def addScalarPropertyValueAssertion(Description description, NamedInstance instance, String propertyIri, LiteralValue value) {
		addScalarPropertyValueAssertion(description, instance.iri, propertyIri, value)
	}

	def addScalarPropertyValueAssertion(Description description, StructureInstance instance, String propertyIri, LiteralValue value) {
		val assertion = create(ScalarPropertyValueAssertion)
		defer.add [assertion.property = resolve(ScalarProperty, propertyIri)]
		assertion.value = value
		instance.propertyValues += assertion
		return assertion
	}
		
	// StructuredPropertyValueAssertion

	def addStructuredPropertyValueAssertion(Description description, String instanceIri, String propertyIri, StructureInstance value) {
		val assertion = create(StructuredPropertyValueAssertion)
		assertion.value = value
		defer.add [assertion.property = resolve(StructuredProperty, propertyIri)]
		defer.add [
			val instance = resolve(NamedInstance, instanceIri)
			if (instance.description == description) {
				instance.propertyValues += assertion
			} else {
				description.getOrCreateReference(instance, NamedInstanceReference).propertyValues += assertion 
			}
		]
		return assertion
	}

	def addStructuredPropertyValueAssertion(Description description, NamedInstance instance, String propertyIri, StructureInstance value) {
		addStructuredPropertyValueAssertion(description, instance.iri, propertyIri, value)
	}

	def addStructuredPropertyValueAssertion(StructureInstance instance, String propertyIri, StructureInstance value) {
		val assertion = create(StructuredPropertyValueAssertion)
		defer.add [assertion.property = resolve(StructuredProperty, propertyIri)]
		assertion.value = value
		instance.propertyValues += assertion
		return assertion
	}
	
	// TerminologyExtension
	
	def addTerminologyExtension(Terminology terminology, String uri, String alias) {
		val _extension = create(TerminologyExtension)
		_extension.importURI = uri
		_extension.importedNamespace = alias
		terminology.imports += _extension
		return _extension
	}

	// DescriptionUsage

	def addDescriptionUsage(Description description, String uri, String alias) {
		val usage = create(DescriptionUsage)
		usage.importURI = uri
		usage.importedNamespace = alias
		description.imports += usage
		return usage
	}
	
	// DescriptionRefinement	

	def addDescriptionRefinement(Description description, String uri, String alias) {
		val refinement = create(DescriptionRefinement)
		refinement.importURI = uri
		refinement.importedNamespace = alias
		description.imports += refinement
		return refinement
	}
	
	// StructureInstance

	def createStructureInstance(String structureIri) {
		val instance = create(StructureInstance)
		defer.add [instance.structure = resolve(Structure, structureIri)]
		return instance
	}
	
	// LiteralBoolean
	
	def createLiteralBoolean(boolean value, String typeIri) {
		val literal = create(LiteralBoolean)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}

	// LiteralDateTime

	def createLiteralDateTime(String value, String typeIri) {
		val literal = create(LiteralDateTime)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralString

	def createLiteralString(String value, String typeIri) {
		val literal = create(LiteralString)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralUUID

	def createLiteralUUID(String value, String typeIri) {
		val literal = create(LiteralUUID)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralURI

	def createLiteralURI(String value, String typeIri) {
		val literal = create(LiteralURI)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralReal

	def createLiteralReal(double value, String typeIri) {
		val literal = create(LiteralReal)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralRational

	def createLiteralRational(double value, String typeIri) {
		val literal = create(LiteralRational)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralFloat

	def createLiteralFloat(float value, String typeIri) {
		val literal = create(LiteralFloat)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// LiteralDecimal

	def createLiteralDecimal(BigDecimal value, String typeIri) {
		val literal = create(LiteralDecimal)
		literal.value = value
		defer.add [literal.valueType = resolve(ScalarRange, typeIri)]
		return literal
	}
	
	// EntityPredicate

	def createEntityPredicate(String entityIri, String variable) {
		val predicate = create(EntityPredicate)
		defer.add [predicate.entity = resolve(Entity, entityIri)]
		predicate.variable = variable
		return predicate
	}
	
	// UnidirectionalRelationshipPredicate

	def createUnidirectionalRelationshipPredicate(String relationshipIri, String variable1, String variable2) {
		val predicate = create(UnidirectionalRelationshipPredicate)
		defer.add [predicate.relationship = resolve(UnidirectionalRelationship, relationshipIri)]
		predicate.variable1 = variable1
		predicate.variable2 = variable2
		return predicate
	}
	
	// ReifiedRelationshipPredicate

	def createReifiedRelationshipPredicate(String relationshipIri, ReifiedRelationshipPredicateKind kind, String variable1, String variable2) {
		val predicate = create(ReifiedRelationshipPredicate)
		defer.add [predicate.relationship = resolve(ReifiedRelationship, relationshipIri)]
		predicate.kind = kind
		predicate.variable1 = variable1
		predicate.variable2 = variable2
		return predicate
	}

	// Built-in vocabularies

	def createBuiltInVocabularies() {
		val resourceSet = new ResourceSetImpl
		resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl())
		resourceSet.packageRegistry.put(OmlPackage.eNS_URI, OmlPackage.eINSTANCE);
		createBuiltInVocabulary(resourceSet, "www.w3.org/2001/XMLSchema")
		createBuiltInVocabulary(resourceSet, "www.w3.org/1999/02/22-rdf-syntax-ns")
		createBuiltInVocabulary(resourceSet, "www.w3.org/2000/01/rdf-schema")
		createBuiltInVocabulary(resourceSet, "www.w3.org/2002/07/owl")
		EcoreUtil.resolveAll(resourceSet)
	}
	
	def createBuiltInVocabulary(ResourceSet resourceSet, String relativePath) {
		val resourceURL = ClassLoader.getSystemClassLoader().getResource(relativePath+".oml.xmi")
		val resource = resourceSet.getResource(URI.createURI(resourceURL.toString), true)
		if (resource !== null) {
			val graph = resource.contents.filter(Graph).head
			roots.put(relativePath+pathExtension, graph)
			addGraph(graph)
		}
	}
}