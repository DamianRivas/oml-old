package io.opencaesar.oml

class OmlFactory2 {
	
	static val factory = OmlFactory.eINSTANCE
	
	public static val INSTANCE = new OmlFactory2
	
	private new() {}
	
	def <T> T create(Class<T> type) {
		switch(type) {
			case Annotation: factory.createAnnotation
			case Terminology: factory.createTerminology
			case Description: factory.createDescription
			case Aspect: factory.createAspect
			case Concept: factory.createConcept
			case ReifiedRelationship: factory.createReifiedRelationship
			case Structure: factory.createStructure
			case UnreifiedRelationship: factory.createUnreifiedRelationship
			case Scalar: factory.createScalar
			case BinaryScalar: factory.createBinaryScalar
			case IRIScalar: factory.createIRIScalar
			case PlainLiteralScalar: factory.createPlainLiteralScalar
			case StringScalar: factory.createStringScalar
			case NumericScalar: factory.createNumericScalar
			case TimeScalar: factory.createTimeScalar
			case EnumerationScalar: factory.createEnumerationScalar
			case StructuredProperty: factory.createStructuredProperty
			case ScalarProperty: factory.createScalarProperty
			case AnnotationProperty: factory.createAnnotationProperty
			case Rule: factory.createRule
			case ForwardRelationship: factory.createForwardRelationship
			case InverseRelationship: factory.createInverseRelationship
			case ConceptInstance: factory.createConceptInstance
			case ReifiedRelationshipInstance: factory.createReifiedRelationshipInstance
			case AspectReference: factory.createAspectReference
			case ConceptReference: factory.createConceptReference
			case ReifiedRelationshipReference: factory.createReifiedRelationshipReference
			case UnreifiedRelationshipReference: factory.createUnreifiedRelationshipReference
			case StructureReference: factory.createStructureReference
			case ScalarRangeReference: factory.createScalarRangeReference
			case StructuredPropertyReference: factory.createStructuredPropertyReference
			case ScalarPropertyReference: factory.createScalarPropertyReference
			case ReifiedUnidirectionalRelationshipReference: factory.createReifiedUnidirectionalRelationshipReference
			case RuleReference: factory.createRuleReference
			case ConceptInstanceReference: factory.createConceptInstanceReference
			case ReifiedRelationshipInstanceReference: factory.createReifiedRelationshipInstanceReference
			case TermSpecializationAxiom: factory.createTermSpecializationAxiom
			case ExistentialRelationshipRestrictionAxiom: factory.createExistentialRelationshipRestrictionAxiom
			case UniversalRelationshipRestrictionAxiom: factory.createUniversalRelationshipRestrictionAxiom
			case ExistentialScalarPropertyRestrictionAxiom: factory.createExistentialScalarPropertyRestrictionAxiom
			case UniversalScalarPropertyRestrictionAxiom: factory.createUniversalScalarPropertyRestrictionAxiom
			case ParticularScalarPropertyRestrictionAxiom: factory.createParticularScalarPropertyRestrictionAxiom
			case StructuredPropertyRestrictionAxiom: factory.createStructuredPropertyRestrictionAxiom
			case ConceptInstanceTypeAssertion: factory.createConceptInstanceTypeAssertion
			case ReifiedRelationshipInstanceTypeAssertion: factory.createReifiedRelationshipInstanceTypeAssertion
			case ScalarPropertyValueAssertion: factory.createScalarPropertyValueAssertion
			case StructuredPropertyValueAssertion: factory.createStructuredPropertyValueAssertion
			case TerminologyExtension: factory.createTerminologyExtension
			case DescriptionUsage: factory.createDescriptionUsage
			case DescriptionRefinement: factory.createDescriptionRefinement
			case StructureInstance: factory.createStructureInstance
			case LiteralBoolean: factory.createLiteralBoolean
			case LiteralDateTime: factory.createLiteralDateTime
			case LiteralString: factory.createLiteralString
			case LiteralUUID: factory.createLiteralUUID
			case LiteralURI: factory.createLiteralURI
			case LiteralReal: factory.createLiteralReal
			case LiteralRational: factory.createLiteralRational
			case LiteralFloat: factory.createLiteralFloat
			case LiteralDecimal: factory.createLiteralDecimal
			case EntityPredicate: factory.createEntityPredicate
			case UnidirectionalRelationshipPredicate: factory.createUnidirectionalRelationshipPredicate
			case ReifiedRelationshipPredicate: factory.createReifiedRelationshipPredicate
		} as T
	}
}