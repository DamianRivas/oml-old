/*
 * generated by Xtext 2.14.0
 */
package io.opencaesar.oml.dsl.formatting2

import com.google.inject.Inject
import io.opencaesar.oml.Annotation
import io.opencaesar.oml.AnnotationProperty
import io.opencaesar.oml.Aspect
import io.opencaesar.oml.AspectReference
import io.opencaesar.oml.BinaryScalar
import io.opencaesar.oml.Concept
import io.opencaesar.oml.ConceptInstance
import io.opencaesar.oml.ConceptInstanceReference
import io.opencaesar.oml.ConceptInstanceTypeAssertion
import io.opencaesar.oml.ConceptReference
import io.opencaesar.oml.Description
import io.opencaesar.oml.DescriptionRefinement
import io.opencaesar.oml.DescriptionUsage
import io.opencaesar.oml.EntityPredicate
import io.opencaesar.oml.EnumerationScalar
import io.opencaesar.oml.ExistentialRelationshipRestrictionAxiom
import io.opencaesar.oml.ExistentialScalarPropertyRestrictionAxiom
import io.opencaesar.oml.ForwardRelationship
import io.opencaesar.oml.IRIScalar
import io.opencaesar.oml.InverseRelationship
import io.opencaesar.oml.LiteralValue
import io.opencaesar.oml.NumericScalar
import io.opencaesar.oml.ParticularScalarPropertyRestrictionAxiom
import io.opencaesar.oml.PlainLiteralScalar
import io.opencaesar.oml.ReifiedRelationship
import io.opencaesar.oml.ReifiedRelationshipInstance
import io.opencaesar.oml.ReifiedRelationshipInstanceReference
import io.opencaesar.oml.ReifiedRelationshipInstanceTypeAssertion
import io.opencaesar.oml.ReifiedRelationshipPredicate
import io.opencaesar.oml.ReifiedRelationshipReference
import io.opencaesar.oml.ReifiedUnidirectionalRelationshipReference
import io.opencaesar.oml.Rule
import io.opencaesar.oml.Scalar
import io.opencaesar.oml.ScalarProperty
import io.opencaesar.oml.ScalarPropertyReference
import io.opencaesar.oml.ScalarPropertyValueAssertion
import io.opencaesar.oml.ScalarRangeReference
import io.opencaesar.oml.StringScalar
import io.opencaesar.oml.Structure
import io.opencaesar.oml.StructureInstance
import io.opencaesar.oml.StructureReference
import io.opencaesar.oml.StructuredProperty
import io.opencaesar.oml.StructuredPropertyReference
import io.opencaesar.oml.StructuredPropertyRestrictionAxiom
import io.opencaesar.oml.StructuredPropertyValueAssertion
import io.opencaesar.oml.TermSpecializationAxiom
import io.opencaesar.oml.Terminology
import io.opencaesar.oml.TerminologyExtension
import io.opencaesar.oml.TimeScalar
import io.opencaesar.oml.UnidirectionalRelationshipPredicate
import io.opencaesar.oml.UniversalRelationshipRestrictionAxiom
import io.opencaesar.oml.UniversalScalarPropertyRestrictionAxiom
import io.opencaesar.oml.UnreifiedRelationship
import io.opencaesar.oml.UnreifiedRelationshipReference
import io.opencaesar.oml.dsl.services.OmlGrammarAccess
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.formatting.IIndentationInformation
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.FormatterPreferenceKeys
import org.eclipse.xtext.formatting2.FormatterRequest
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.preferences.MapBasedPreferenceValues

class OmlFormatter extends AbstractFormatter2 {
	
	@Inject extension OmlGrammarAccess
    @Inject IIndentationInformation indentationInformation


	override protected initialize(FormatterRequest request) {
        val preferences = request.preferences
        if (preferences instanceof MapBasedPreferenceValues) {
            preferences.put(FormatterPreferenceKeys.indentation, indentationInformation.indentString)
        }
        super.initialize(request)
    }

	def dispatch void format(Annotation _annotation, extension IFormattableDocument document) {
		_annotation.regionFor.keyword(annotationAccess.commercialAtKeyword_0).append[noSpace]
		_annotation.regionFor.keyword(annotationAccess.equalsSignKeyword_2).surround[noSpace]
		_annotation.value?.format
	}

	def dispatch void format(Terminology terminology, extension IFormattableDocument document) {
		terminology.annotations.forEach[format.append[newLine]]
        terminology.regionFor.assignment(terminologyAccess.kindAssignment_1).append[oneSpace]
        terminology.regionFor.keyword(terminologyAccess.terminologyKeyword_2).surround[oneSpace]
        terminology.regionFor.keyword(terminologyAccess.asKeyword_4).surround[oneSpace]
		terminology.formatBraces(document)
		terminology.imports.forEach[format.prepend[setNewLines(2)]]
		terminology.statements.forEach[format.prepend[setNewLines(2)]]
	}

	def dispatch void format(Description description, extension IFormattableDocument document) {
		description.annotations.forEach[format.append[newLine]]
        description.regionFor.assignment(descriptionAccess.kindAssignment_1).append[oneSpace]
        description.regionFor.keyword(descriptionAccess.descriptionKeyword_2).surround[oneSpace]
        description.regionFor.keyword(descriptionAccess.asKeyword_4).surround[oneSpace]
		description.formatBraces(document)
		description.imports.forEach[format.prepend[setNewLines(2)]]
		description.statements.forEach[format.prepend[setNewLines(2)]]
	}

	def dispatch void format(Aspect aspect, extension IFormattableDocument document) {
		aspect.annotations.forEach[format.append[newLine]]
		aspect.regionFor.keyword(aspectAccess.aspectKeyword_1).append[oneSpace]
		aspect.regionFor.keyword(aspectAccess.specializesKeyword_3_0).surround[oneSpace]
		aspect.formatCommas(document)
		aspect.formatBraces(document)
		aspect.restrictions.forEach[format.prepend[newLine]]
	}

	def dispatch void format(Concept concept, extension IFormattableDocument document) {
		concept.annotations.forEach[format.append[newLine]]
		concept.regionFor.keyword(conceptAccess.conceptKeyword_1).append[oneSpace]
		concept.regionFor.keyword(conceptAccess.specializesKeyword_3_0).surround[oneSpace]
		concept.formatCommas(document)
		concept.formatBraces(document)
		concept.restrictions.forEach[format.prepend[newLine]]
	}

	def dispatch void format(ReifiedRelationship relationship, extension IFormattableDocument document) {
		relationship.annotations.forEach[format.append[newLine]]
		relationship.regionFor.keyword(reifiedRelationshipAccess.reifiedKeyword_1).append[oneSpace]
		relationship.regionFor.keyword(reifiedRelationshipAccess.relationshipKeyword_2).surround[oneSpace]
		relationship.formatCommas(document)
		relationship.formatBraces(document)
		relationship.regionFor.keyword(reifiedRelationshipAccess.sourceKeyword_6).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.targetKeyword_8).prepend[newLine]
		relationship.forward?.format.prepend[newLine]
		relationship.inverse?.format.prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.functionalFunctionalKeyword_12_0_0).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.inverseFunctionalInverseFunctionalKeyword_12_1_0).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.symmetricSymmetricKeyword_12_2_0).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.asymmetricAsymmetricKeyword_12_3_0).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.reflexiveReflexiveKeyword_12_4_0).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.irreflexiveIrreflexiveKeyword_12_5_0).prepend[newLine]
		relationship.regionFor.keyword(reifiedRelationshipAccess.transitiveTransitiveKeyword_12_6_0).prepend[newLine]
		relationship.restrictions.forEach[format.prepend[newLine]]
	}
	
	def dispatch void format(Structure structure, extension IFormattableDocument document) {
		structure.annotations.forEach[format.append[newLine]]
		structure.regionFor.keyword(structureAccess.structureKeyword_1).append[oneSpace]
		structure.formatCommas(document)
		structure.formatBraces(document)
	}

	def dispatch void format(UnreifiedRelationship relationship, extension IFormattableDocument document) {
		relationship.annotations.forEach[format.append[newLine]]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.unreifiedKeyword_1).append[oneSpace]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.relationshipKeyword_2).surround[oneSpace]
		relationship.formatCommas(document)
		relationship.formatBraces(document)
		relationship.regionFor.keyword(unreifiedRelationshipAccess.sourceKeyword_6).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.targetKeyword_8).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.functionalFunctionalKeyword_10_0_0).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.inverseFunctionalInverseFunctionalKeyword_10_1_0).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.symmetricSymmetricKeyword_10_2_0).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.asymmetricAsymmetricKeyword_10_3_0).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.reflexiveReflexiveKeyword_10_4_0).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.irreflexiveIrreflexiveKeyword_10_5_0).prepend[newLine]
		relationship.regionFor.keyword(unreifiedRelationshipAccess.transitiveTransitiveKeyword_10_6_0).prepend[newLine]
	}

	def dispatch void format(Scalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(scalarAccess.scalarKeyword_1).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
	}

	def dispatch void format(BinaryScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(binaryScalarAccess.binaryKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(binaryScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.regionFor.keyword(binaryScalarAccess.lengthKeyword_5_1_0_0).prepend[newLine]
		scalar.regionFor.keyword(binaryScalarAccess.minLengthKeyword_5_1_1_0).prepend[newLine]
		scalar.regionFor.keyword(binaryScalarAccess.maxLengthKeyword_5_1_2_0).prepend[newLine]
	}

	def dispatch void format(IRIScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(IRIScalarAccess.iriKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(IRIScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.regionFor.keyword(IRIScalarAccess.lengthKeyword_5_1_0_0).prepend[newLine]
		scalar.regionFor.keyword(IRIScalarAccess.minLengthKeyword_5_1_1_0).prepend[newLine]
		scalar.regionFor.keyword(IRIScalarAccess.maxLengthKeyword_5_1_2_0).prepend[newLine]
		scalar.regionFor.keyword(IRIScalarAccess.patternKeyword_5_1_3_0).prepend[newLine]
	}

	def dispatch void format(PlainLiteralScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(plainLiteralScalarAccess.literalKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(plainLiteralScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.regionFor.keyword(plainLiteralScalarAccess.lengthKeyword_5_1_0_0).prepend[newLine]
		scalar.regionFor.keyword(plainLiteralScalarAccess.minLengthKeyword_5_1_1_0).prepend[newLine]
		scalar.regionFor.keyword(plainLiteralScalarAccess.maxLengthKeyword_5_1_2_0).prepend[newLine]
		scalar.regionFor.keyword(plainLiteralScalarAccess.patternKeyword_5_1_3_0).prepend[newLine]
		scalar.regionFor.keyword(plainLiteralScalarAccess.languageKeyword_5_1_4_0).prepend[newLine]
	}

	def dispatch void format(StringScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(stringScalarAccess.stringKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(stringScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.regionFor.keyword(stringScalarAccess.lengthKeyword_5_1_0_0).prepend[newLine]
		scalar.regionFor.keyword(stringScalarAccess.minLengthKeyword_5_1_1_0).prepend[newLine]
		scalar.regionFor.keyword(stringScalarAccess.maxLengthKeyword_5_1_2_0).prepend[newLine]
		scalar.regionFor.keyword(stringScalarAccess.patternKeyword_5_1_3_0).prepend[newLine]
	}

	def dispatch void format(NumericScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(numericScalarAccess.numericKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(numericScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.regionFor.keyword(numericScalarAccess.minInclusiveKeyword_5_1_0_0).prepend[newLine]
		scalar.regionFor.keyword(numericScalarAccess.maxInclusiveKeyword_5_1_2_0).prepend[newLine]
		scalar.regionFor.keyword(numericScalarAccess.minExclusiveKeyword_5_1_1_0).prepend[newLine]
		scalar.regionFor.keyword(numericScalarAccess.maxExclusiveKeyword_5_1_3_0).prepend[newLine]
	}

	def dispatch void format(TimeScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(timeScalarAccess.timeKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(timeScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.regionFor.keyword(timeScalarAccess.minInclusiveKeyword_5_1_0_0).prepend[newLine]
		scalar.regionFor.keyword(timeScalarAccess.maxInclusiveKeyword_5_1_2_0).prepend[newLine]
		scalar.regionFor.keyword(timeScalarAccess.minExclusiveKeyword_5_1_1_0).prepend[newLine]
		scalar.regionFor.keyword(timeScalarAccess.maxExclusiveKeyword_5_1_3_0).prepend[newLine]
	}

	def dispatch void format(EnumerationScalar scalar, extension IFormattableDocument document) {
		scalar.annotations.forEach[format.append[newLine]]
		scalar.regionFor.keyword(enumerationScalarAccess.enumKeyword_1).append[oneSpace]
		scalar.regionFor.keyword(enumerationScalarAccess.scalarKeyword_2).surround[oneSpace]
		scalar.formatCommas(document)
		scalar.formatBraces(document)
		scalar.literals.forEach[format.prepend[newLine]]
	}

	def dispatch void format(StructuredProperty property, extension IFormattableDocument document) {
		property.annotations.forEach[format.append[newLine]]
		property.regionFor.keyword(structuredPropertyAccess.structuredKeyword_1).append[oneSpace]
		property.regionFor.keyword(structuredPropertyAccess.propertyKeyword_2).surround[oneSpace]
		property.formatCommas(document)
		property.formatBraces(document)
		property.regionFor.keyword(structuredPropertyAccess.domainKeyword_6).prepend[newLine]
		property.regionFor.keyword(structuredPropertyAccess.rangeKeyword_8).prepend[newLine]
		property.regionFor.keyword(structuredPropertyAccess.functionalFunctionalKeyword_10_0).prepend[newLine]
	}

	def dispatch void format(ScalarProperty property, extension IFormattableDocument document) {
		property.annotations.forEach[format.append[newLine]]
		property.regionFor.keyword(scalarPropertyAccess.scalarKeyword_1).append[oneSpace]
		property.regionFor.keyword(scalarPropertyAccess.propertyKeyword_2).surround[oneSpace]
		property.formatCommas(document)
		property.formatBraces(document)
		property.regionFor.keyword(scalarPropertyAccess.domainKeyword_6).prepend[newLine]
		property.regionFor.keyword(scalarPropertyAccess.rangeKeyword_8).prepend[newLine]
		property.regionFor.keyword(scalarPropertyAccess.functionalFunctionalKeyword_10_0).prepend[newLine]
	}

	def dispatch void format(AnnotationProperty property, extension IFormattableDocument document) {
		property.annotations.forEach[format.append[newLine]]
		property.regionFor.keyword(annotationPropertyAccess.annotationKeyword_1).append[oneSpace]
		property.regionFor.keyword(annotationPropertyAccess.propertyKeyword_2).surround[oneSpace]
		property.formatCommas(document)
		property.formatBraces(document)
	}

	def dispatch void format(ForwardRelationship relationship, extension IFormattableDocument document) {
		relationship.annotations.forEach[format.append[newLine]]
		relationship.regionFor.keyword(forwardRelationshipAccess.forwardKeyword_1).append[oneSpace]
	}

	def dispatch void format(InverseRelationship relationship, extension IFormattableDocument document) {
		relationship.annotations.forEach[format.append[newLine]]
		relationship.regionFor.keyword(inverseRelationshipAccess.inverseKeyword_1).append[oneSpace]
	}

	def dispatch void format(ConceptInstance instance, extension IFormattableDocument document) {
		instance.annotations.forEach[format.append[newLine]]
		instance.regionFor.keyword(conceptInstanceAccess.conceptKeyword_1).append[oneSpace]
		instance.regionFor.keyword(conceptInstanceAccess.instanceKeyword_2).surround[oneSpace]
		instance.regionFor.keyword(conceptInstanceAccess.colonKeyword_4).surround[oneSpace]
		instance.formatCommas(document)
		instance.formatBraces(document)
		instance.propertyValues.forEach[format.prepend[newLine]]
	}

	def dispatch void format(ReifiedRelationshipInstance instance, extension IFormattableDocument document) {
		instance.annotations.forEach[format.append[newLine]]
		instance.regionFor.keyword(reifiedRelationshipInstanceAccess.relationshipKeyword_1).append[oneSpace]
		instance.regionFor.keyword(reifiedRelationshipInstanceAccess.instanceKeyword_2).surround[oneSpace]
		instance.regionFor.keyword(reifiedRelationshipInstanceAccess.colonKeyword_4).surround[oneSpace]
		instance.formatCommas(document)
		instance.formatBraces(document)
		instance.regionFor.keyword(reifiedRelationshipInstanceAccess.sourceKeyword_7_1).prepend[newLine]
		instance.regionFor.keyword(reifiedRelationshipInstanceAccess.targetKeyword_7_3).prepend[newLine]
		instance.propertyValues.forEach[format.prepend[newLine]]
	}

	def dispatch void format(AspectReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(aspectReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(aspectReferenceAccess.aspectKeyword_2).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
		reference.restrictions.forEach[format.prepend[newLine]]
	}

	def dispatch void format(ConceptReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(conceptReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(conceptReferenceAccess.conceptKeyword_2).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
		reference.restrictions.forEach[format.prepend[newLine]]
	}

	def dispatch void format(ReifiedRelationshipReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(reifiedRelationshipReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(reifiedRelationshipReferenceAccess.reifiedKeyword_2).surround[oneSpace]
		reference.regionFor.keyword(reifiedRelationshipReferenceAccess.relationshipKeyword_3).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
		reference.restrictions.forEach[format.prepend[newLine]]
	}

	def dispatch void format(UnreifiedRelationshipReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(unreifiedRelationshipReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(unreifiedRelationshipReferenceAccess.unreifiedKeyword_2).surround[oneSpace]
		reference.regionFor.keyword(unreifiedRelationshipReferenceAccess.relationshipKeyword_3).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
	}

	def dispatch void format(StructureReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(structureReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(structureReferenceAccess.structureKeyword_2).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
	}

	def dispatch void format(ScalarRangeReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(scalarRangeReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(scalarRangeReferenceAccess.scalarKeyword_2).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
	}

	def dispatch void format(StructuredPropertyReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(structuredPropertyReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(structuredPropertyReferenceAccess.structuredKeyword_2).surround[oneSpace]
		reference.regionFor.keyword(structuredPropertyReferenceAccess.propertyKeyword_3).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
	}

	def dispatch void format(ScalarPropertyReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(scalarPropertyReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(scalarPropertyReferenceAccess.scalarKeyword_2).surround[oneSpace]
		reference.regionFor.keyword(scalarPropertyReferenceAccess.propertyKeyword_3).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
	}

	def dispatch void format(ReifiedUnidirectionalRelationshipReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(reifiedUnidirectionalRelationshipReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(reifiedUnidirectionalRelationshipReferenceAccess.relationshipKeyword_2).surround[oneSpace]
		reference.formatBraces(document)
	}

	def dispatch void format(ConceptInstanceReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(conceptInstanceReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(conceptInstanceReferenceAccess.conceptKeyword_2).surround[oneSpace]
		reference.regionFor.keyword(conceptInstanceReferenceAccess.instanceKeyword_3).surround[oneSpace]
		reference.formatCommas(document)
		reference.formatBraces(document)
		reference.propertyValues.forEach[format.prepend[newLine]]
	}

	def dispatch void format(ReifiedRelationshipInstanceReference reference, extension IFormattableDocument document) {
		reference.annotations.forEach[format.append[newLine]]
		reference.regionFor.keyword(reifiedRelationshipInstanceReferenceAccess.refKeyword_1).append[oneSpace]
		reference.regionFor.keyword(reifiedRelationshipInstanceReferenceAccess.relationshipKeyword_2).surround[oneSpace]
		reference.regionFor.keyword(reifiedRelationshipInstanceReferenceAccess.instanceKeyword_3).surround[oneSpace]
		reference.formatBraces(document)
		reference.propertyValues.forEach[format.prepend[newLine]]
	}

	def dispatch void format(TerminologyExtension ext, extension IFormattableDocument document) {
		ext.regionFor.keyword(terminologyExtensionAccess.extendsKeyword_0).append[oneSpace]
		ext.regionFor.keyword(terminologyExtensionAccess.asKeyword_2_0).surround[oneSpace]
	}

	def dispatch void format(DescriptionUsage usage, extension IFormattableDocument document) {
		usage.regionFor.keyword(descriptionUsageAccess.usesKeyword_0).append[oneSpace]
		usage.regionFor.keyword(descriptionUsageAccess.asKeyword_2_0).surround[oneSpace]
	}

	def dispatch void format(DescriptionRefinement refinement, extension IFormattableDocument document) {
		refinement.regionFor.keyword(descriptionRefinementAccess.refinesKeyword_0).append[oneSpace]
		refinement.regionFor.keyword(descriptionRefinementAccess.asKeyword_2_0).surround[oneSpace]
	}

	def dispatch void format(TermSpecializationAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
	}

	def dispatch void format(ExistentialRelationshipRestrictionAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
		axiom.regionFor.keyword(existentialRelationshipRestrictionAxiomAccess.restrictsKeyword_1).append[oneSpace]
		axiom.regionFor.keyword(existentialRelationshipRestrictionAxiomAccess.someKeyword_2).surround[oneSpace]
		axiom.regionFor.keyword(existentialRelationshipRestrictionAxiomAccess.toKeyword_4).surround[oneSpace]
	}

	def dispatch void format(UniversalRelationshipRestrictionAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
		axiom.regionFor.keyword(universalRelationshipRestrictionAxiomAccess.restrictsKeyword_1).append[oneSpace]
		axiom.regionFor.keyword(universalRelationshipRestrictionAxiomAccess.everyKeyword_2).surround[oneSpace]
		axiom.regionFor.keyword(universalRelationshipRestrictionAxiomAccess.toKeyword_4).surround[oneSpace]
	}

	def dispatch void format(ExistentialScalarPropertyRestrictionAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
		axiom.regionFor.keyword(existentialScalarPropertyRestrictionAxiomAccess.restrictsKeyword_1).append[oneSpace]
		axiom.regionFor.keyword(existentialScalarPropertyRestrictionAxiomAccess.someKeyword_2).surround[oneSpace]
		axiom.regionFor.keyword(existentialScalarPropertyRestrictionAxiomAccess.toTypeKeyword_4).surround[oneSpace]
	}

	def dispatch void format(UniversalScalarPropertyRestrictionAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
		axiom.regionFor.keyword(universalScalarPropertyRestrictionAxiomAccess.restrictsKeyword_1).append[oneSpace]
		axiom.regionFor.keyword(universalScalarPropertyRestrictionAxiomAccess.everyKeyword_2).surround[oneSpace]
		axiom.regionFor.keyword(universalScalarPropertyRestrictionAxiomAccess.toTypeKeyword_4).surround[oneSpace]
	}

	def dispatch void format(ParticularScalarPropertyRestrictionAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
		axiom.regionFor.keyword(particularScalarPropertyRestrictionAxiomAccess.restrictsKeyword_1).append[oneSpace]
		axiom.regionFor.keyword(particularScalarPropertyRestrictionAxiomAccess.toKeyword_3).surround[oneSpace]
		axiom.value?.format
	}

	def dispatch void format(StructuredPropertyRestrictionAxiom axiom, extension IFormattableDocument document) {
		axiom.annotations.forEach[format.append[newLine]]
		axiom.regionFor.keyword(structuredPropertyRestrictionAxiomAccess.restrictsKeyword_1).append[oneSpace]
		axiom.regionFor.keyword(structuredPropertyRestrictionAxiomAccess.toKeyword_3).surround[oneSpace]
		axiom.value?.format
	}

	def dispatch void format(Rule rule, extension IFormattableDocument document) {
		rule.annotations.forEach[format.append[newLine]]
		rule.regionFor.keyword(ruleAccess.ruleKeyword_1).append[oneSpace]
		rule.formatBraces(document)
		if (!rule.antecedent.isEmpty) {
			rule.antecedent.get(0).format.prepend[newLine]
		}
		rule.antecedent.forEach[format]
		rule.regionFor.keywords(ruleAccess.ampersandKeyword_5_0).forEach[surround[oneSpace]]
		rule.regionFor.keyword(ruleAccess.equalsSignGreaterThanSignKeyword_6).surround[oneSpace]
		rule.consequent?.format
	}

	def dispatch void format(EntityPredicate predicate, extension IFormattableDocument document) {
		predicate.regionFor.keyword(entityPredicateAccess.leftParenthesisKeyword_1).surround[noSpace]
		predicate.regionFor.keyword(entityPredicateAccess.rightParenthesisKeyword_3).prepend[noSpace]
	}

	def dispatch void format(UnidirectionalRelationshipPredicate predicate, extension IFormattableDocument document) {
		predicate.regionFor.keyword(unidirectionalRelationshipPredicateAccess.leftParenthesisKeyword_1).surround[noSpace]
		predicate.regionFor.keyword(unidirectionalRelationshipPredicateAccess.rightParenthesisKeyword_5).prepend[noSpace]
		predicate.formatCommas(document)
	}

	def dispatch void format(ReifiedRelationshipPredicate predicate, extension IFormattableDocument document) {
		predicate.regionFor.keyword(reifiedRelationshipPredicateAccess.leftParenthesisKeyword_1).surround[noSpace]
		predicate.regionFor.keyword(reifiedRelationshipPredicateAccess.rightParenthesisKeyword_7).prepend[noSpace]
		predicate.formatCommas(document)
	}

	def dispatch void format(ConceptInstanceTypeAssertion assertion, extension IFormattableDocument document) {
		assertion.annotations.forEach[format.append[newLine]]
	}

	def dispatch void format(ReifiedRelationshipInstanceTypeAssertion assertion, extension IFormattableDocument document) {
		assertion.annotations.forEach[format.append[newLine]]
	}

	def dispatch void format(ScalarPropertyValueAssertion assertion, extension IFormattableDocument document) {
		assertion.annotations.forEach[format.append[newLine]]
		assertion.regionFor.keyword(scalarPropertyValueAssertionAccess.equalsSignKeyword_2).surround[oneSpace]
		assertion.value?.format
	}

	def dispatch void format(StructuredPropertyValueAssertion assertion, extension IFormattableDocument document) {
		assertion.annotations.forEach[format.append[newLine]]
		assertion.regionFor.keyword(structuredPropertyValueAssertionAccess.equalsSignKeyword_2).surround[oneSpace]
		assertion.value?.format
	}

	def dispatch void format(StructureInstance instance, extension IFormattableDocument document) {
		instance.formatBraces(document)
		instance.propertyValues.forEach[format.prepend[newLine]]
	}

	def dispatch void format(LiteralValue value, extension IFormattableDocument document) {
		value.regionFor.keyword("^^").surround[noSpace]
	}
	
	def formatBraces(EObject e, extension IFormattableDocument document) {
		val open = e.regionFor.keyword("{")
		open.prepend[oneSpace]
		val close = e.regionFor.keyword("}")
		close.prepend[newLine]
		interior(open, close)[indent]
	}
	
	def formatCommas(EObject e, extension IFormattableDocument document) {
		e.regionFor.keywords(',').forEach[prepend[noSpace].append[oneSpace]]
	}

}