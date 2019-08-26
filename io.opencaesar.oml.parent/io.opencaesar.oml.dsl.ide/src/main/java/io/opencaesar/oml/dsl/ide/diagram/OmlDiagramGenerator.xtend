package io.opencaesar.oml.dsl.ide.diagram

import com.google.inject.Inject
import io.opencaesar.oml.Aspect
import io.opencaesar.oml.AspectReference
import io.opencaesar.oml.Concept
import io.opencaesar.oml.ConceptReference
import io.opencaesar.oml.ReifiedRelationship
import io.opencaesar.oml.Scalar
import io.opencaesar.oml.ScalarRangeReference
import io.opencaesar.oml.Structure
import io.opencaesar.oml.StructureReference
import io.opencaesar.oml.TermSpecializationAxiom
import io.opencaesar.oml.Terminology
import io.opencaesar.oml.TerminologyExtension
import io.opencaesar.oml.UnreifiedRelationship
import org.eclipse.sprotty.IDiagramState
import org.eclipse.sprotty.LayoutOptions
import org.eclipse.sprotty.SButton
import org.eclipse.sprotty.SCompartment
import org.eclipse.sprotty.SEdge
import org.eclipse.sprotty.SGraph
import org.eclipse.sprotty.SLabel
import org.eclipse.sprotty.SModelElement
import org.eclipse.sprotty.SModelRoot
import org.eclipse.sprotty.xtext.IDiagramGenerator
import org.eclipse.sprotty.xtext.tracing.ITraceProvider
import org.eclipse.sprotty.xtext.SIssueMarkerDecorator
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource

import static extension io.opencaesar.oml.Oml.*
import io.opencaesar.oml.StructuredProperty
import io.opencaesar.oml.ScalarProperty
import io.opencaesar.oml.Rule
import io.opencaesar.oml.Predicate
import io.opencaesar.oml.DirectionalRelationshipPredicate
import io.opencaesar.oml.ReifiedRelationshipPredicate
import io.opencaesar.oml.EntityPredicate
import io.opencaesar.oml.EntityRestrictionAxiom
import io.opencaesar.oml.RelationshipRestrictionAxiom
import io.opencaesar.oml.NamedElementReference
import io.opencaesar.oml.UniversalRelationshipRestrictionAxiom
import io.opencaesar.oml.NamedElement

class OmlDiagramGenerator implements IDiagramGenerator {
	
	static val LOG = Logger.getLogger(OmlDiagramGenerator)

	@Inject extension ITraceProvider traceProvider
	@Inject extension SIssueMarkerDecorator

	var IDiagramState diagramState
	var Resource resource
	var Context context
	
	var Map<EObject, SModelElement> semantic2diagram
	var List<()=>void> postProcesses
	

	override SModelRoot generate(Context context) {
		LOG.info("Generating diagram for input: '" + context.resource.URI.lastSegment + "'")
		
		this.context = context
		this.diagramState = context.state
		this.resource = context.resource
				
		semantic2diagram = new HashMap
		postProcesses = new ArrayList
		
		val diagram = newSElement(OmlGraph, 'root', null) => [
			layoutOptions = new LayoutOptions [
				HAlign = 'left'
				HGap = 10.0
			]
		]
				
		resource.allContents.head.addToDiagram(diagram)
		
		val fQuery = context.state.options.get("filterAction")
		
		// If there is a searchbox query, attempt to filter out the queried element. Otherwise,
		// display the entire graph.
		if (fQuery !== null) {
			val term = resource.allContents.findFirst[ el |
				if (el instanceof NamedElement)
					return el.name == fQuery
				else
					false
			]
			
			if (term !== null) {
				term.addToDiagram(diagram)
				
			} else {
				resource.allContents.forEach[object|
					if (semantic2diagram.get(object) === null)
						object.addToDiagram(diagram)
				]
			}
		} else {
			resource.allContents.forEach[object|
				if (semantic2diagram.get(object) === null)
					object.addToDiagram(diagram)
			]
		}
		
		postProcesses.forEach[process|process.apply]

		return diagram
	}

	protected dispatch def void addToDiagram(EObject eObject, SGraph diagram) {
	}
	
	protected dispatch def void addToDiagram(Terminology terminology, SGraph diagram) {
		val id = terminology.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'module') => [
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingTop = 5.0
				paddingBottom = 5.0
				paddingLeft = 5.0
				paddingRight = 5.0
			]
			children += newSElement(SCompartment, id + '-heading', 'comp') => [
				layout = 'hbox'
				children += newSElement(SLabel, id + '-label', 'heading') => [
					text = id
				]
				children.add(newSElement(SButton, id + '-expand', 'expand'))
			]
			expanded = diagramState.currentModel.type == 'NONE' || diagramState.expandedElements.contains(id)
		]
		diagram.children += node
		node.traceAndMark(terminology, this.context)
		
		if (node.expanded) {
			diagramState.expandedElements.add(id)
		}
	}

	protected dispatch def void addToDiagram(TerminologyExtension ext, SGraph diagram) {
		val importedTerminology = ext.importedGraph as Terminology
		if (importedTerminology === null) {
			return
		}
		
		val id = importedTerminology.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'module') => [
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingTop = 5.0
				paddingBottom = 5.0
				paddingLeft = 5.0
				paddingRight = 5.0
			]
			children.add(newSElement(SCompartment, id + '-heading', 'comp') => [
				layout = 'hbox'
				children += newSElement(SLabel, id + '-label', 'heading') => [
					text = id
				]
			])
			expanded = false
		]
		diagram.children += node
		node.traceAndMark(ext, context)
		
		val importingTerminology = ext.graph as Terminology
		if (semantic2diagram.get(importingTerminology) === null)
			importingTerminology.addToDiagram(diagram)
			
		val edge = newEdge(semantic2diagram.get(importingTerminology), node, "composition") => [
			children += newSElement(SLabel, id + '-extends-label', 'text') => [
				text = 'extends'
			]
		]
		diagram.children += edge
		trace(edge, ext)
	}

	protected dispatch def void addToDiagram(Aspect aspect, SGraph diagram) {
		val id = aspect.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'class') => [
			cssClass = 'moduleNode'
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children += newHeading(id, aspect)
		]
		semantic2diagram.get(resource.contents.head).children += node
		node.traceAndMark(aspect, context)
	}

	protected dispatch def void addToDiagram(AspectReference reference, SGraph diagram) {
		if (reference.aspect !== null) {
			reference.aspect.addToDiagram(diagram)
		}
	}
	
	protected dispatch def void addToDiagram(Concept concept, SGraph diagram) {
		val id = concept.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'class') => [
			cssClass = 'moduleNode'
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children += newHeading(id, concept)
		]
		semantic2diagram.get(resource.contents.head).children += node
		node.traceAndMark(concept, context)
	}

	protected dispatch def void addToDiagram(ConceptReference reference, SGraph diagram) {
		if (reference.concept !== null) {
			reference.concept.addToDiagram(diagram)
		}
	}

	protected dispatch def void addToDiagram(Structure structure, SGraph diagram) {
		val id = structure.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'class') => [
			cssClass = 'moduleNode'
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children += newHeading(id, structure)
		]
		semantic2diagram.get(resource.contents.head).children += node
		node.traceAndMark(structure, context)
	}

	protected dispatch def void addToDiagram(StructureReference reference, SGraph diagram) {
		if (reference.structure !== null) {
			reference.structure.addToDiagram(diagram)
		}
	}

	protected dispatch def void addToDiagram(Scalar scalar, SGraph diagram) {
		val id = scalar.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'class') => [
			cssClass = 'moduleNode'
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children += newHeading(id, scalar)
		]
		semantic2diagram.get(resource.contents.head).children += node
		node.traceAndMark(scalar, context)
	}

	protected dispatch def void addToDiagram(ScalarRangeReference reference, SGraph diagram) {
		if (reference.scalar !== null) {
			reference.scalar.addToDiagram(diagram)
		}
	}
	
	protected dispatch def void addToDiagram(ScalarProperty scalar, SGraph diagram) {
		val domain = scalar.domain
		val range = scalar.range
		val propertyName = scalar.name
		
		postProcesses.add([
			var propertyLabel = new SLabel([
				type = 'label:text'
				id = this.context.idCache.uniqueId(scalar, domain.name + '-' + scalar.name)
				text = propertyName + ': ' + range.name
			])
			
			var domainElement = semantic2diagram.get(domain)
			if (domainElement === null) {
				domain.addToDiagram(diagram)
				domainElement = semantic2diagram.get(domain)
			}
			
			var existingDomainCompartment = domainElement.children
				.stream()
				.filter(child | child instanceof SCompartment && child.type === 'comp:comp')
				.findFirst()
				
			var SCompartment compartment
			if (existingDomainCompartment.present) {
				compartment = existingDomainCompartment.get as SCompartment
				compartment.children += propertyLabel
			} else {
				compartment = newSCompartment(domain.getLocalName(resource) + '-compartment', 'comp:comp')
				compartment.children += propertyLabel
				domainElement.children += compartment
			}
		])
	}

	protected dispatch def void addToDiagram(ReifiedRelationship relationship, SGraph diagram) {
		if (relationship.source === null || relationship.target === null) {
			return
		}
		
		postProcesses.add([
			var source = semantic2diagram.get(relationship.source)
			if (source === null) {
				relationship.source.addToDiagram(diagram)
				source = semantic2diagram.get(relationship.source)
			}
			
			var target = semantic2diagram.get(relationship.target)
			if (target === null) {
				relationship.target.addToDiagram(diagram)
				target = semantic2diagram.get(relationship.target)
			}

			val id = relationship.getLocalName(resource)
			val edge = newEdge(source, target, id, "augments") => [
				children += newSElement(SLabel, id + '-label', 'relationship') => [
					text = id
				]
			]
			semantic2diagram.get(resource.contents.head).children += edge
			trace(edge, relationship)
		])
	}

	protected dispatch def void addToDiagram(UnreifiedRelationship relationship, SGraph diagram) {
		if (relationship.source === null || relationship.target === null) {
			return
		}
		
		postProcesses.add([
			var source = semantic2diagram.get(relationship.source)
			if (source === null) {
				relationship.source.addToDiagram(diagram)
				source = semantic2diagram.get(relationship.source)
			}
			
			var target = semantic2diagram.get(relationship.target)
			if (target === null) {
				relationship.target.addToDiagram(diagram)
				target = semantic2diagram.get(relationship.target)
			}

			val id = relationship.getLocalName(resource)
			val edge = newEdge(source, target, id, "augments") => [
				children += newSElement(SLabel, id + '-label', 'text') => [
					text = id
				]
			]
			semantic2diagram.get(resource.contents.head).children += edge
			trace(edge, relationship)
		])
	}

	protected dispatch def void addToDiagram(TermSpecializationAxiom axiom, SGraph diagram) {
		val specializingTerm = axiom.specializingTerm
		val specializedTerm = axiom.specializedTerm
		
		if (!(specializingTerm instanceof Concept || specializingTerm instanceof Aspect)) {
			return
		}
		
		postProcesses.add([
			var source = semantic2diagram.get(specializingTerm)
			if (source === null) {
				specializingTerm.addToDiagram(diagram)
				source = semantic2diagram.get(specializingTerm)
			}
			
			var target = semantic2diagram.get(specializedTerm)
			if (target === null) {
				specializedTerm.addToDiagram(diagram)
				target = semantic2diagram.get(specializedTerm)
			}

			val edge = newEdge(source, target, "uses")
			semantic2diagram.get(resource.contents.head).children += edge
			trace(edge, axiom)
		])
	}
	
	protected dispatch def void addToDiagram(StructuredProperty property, SGraph diagram) {
		val structure = property.range
		val domain = property.domain
		val propertyName = property.name
		val id = this.context.idCache.uniqueId(property, domain.name + '-' + property.name)
		
		postProcesses.add([
			var propertyLabel = new SLabel([ l |
				l.type = 'label:text'
				l.id = id + '-label'
				l.text = '(R) ' + structure.name + ': ' + propertyName
			])
			
			var domainElement = semantic2diagram.get(domain)
			if (domainElement === null) {
				domain.addToDiagram(diagram)
				domainElement = semantic2diagram.get(domain)
			}
			
			var existingDomainCompartment = domainElement.children
				.stream()
				.filter(child | child instanceof SCompartment && child.type === 'comp:comp')
				.findFirst()
				
			var SCompartment compartment
			if (existingDomainCompartment.present) {
				compartment = existingDomainCompartment.get as SCompartment
				compartment.children += propertyLabel
			} else {
				compartment = newSCompartment(domain.getLocalName(resource) + '-compartment', 'comp:comp')
				compartment.children += propertyLabel
				domainElement.children += compartment
			}
		])
	}
	
	protected dispatch def void addToDiagram(Rule rule, SGraph diagram) {
		val id = rule.getLocalName(resource)
		val node = newSElement(OmlNode, id, 'class') => [
			cssClass = 'moduleNode'
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children += newTaglessHeading(id, rule)
		]
		
		val antecedentCompartment = newSCompartment(id + '-antecedentCompartment', 'comp:comp')
		rule.antecedent.forEach[ a, index |
			antecedentCompartment.children += new SLabel([ l |
				l.type = 'label:text'
				l.id = rule.name + '-antecedent-label-' + index
				l.text = a.renderPredicate
			])
		]
		node.children += antecedentCompartment
		
		val consequent = rule.consequent
		val consequentCompartment = newSCompartment(id + '-consequentCompartment', 'comp:comp')
		consequentCompartment.children += new SLabel[
			type = 'label:text'
			it.id = rule.name + '-consequent-label'
			text = consequent.relationshipDirection.name + '(' + consequent.variable1 + ', ' + consequent.variable2 + ')'
		]
		node.children += consequentCompartment
		
		semantic2diagram.get(resource.contents.head).children += node
		node.traceAndMark(rule, context)
	}
	
	protected dispatch def void addToDiagram(EntityRestrictionAxiom restriction, SGraph diagram) {
		if (restriction instanceof RelationshipRestrictionAxiom) {
			val id = restriction.relationshipDirection.name + '-' + restriction.restrictedEntity.getLocalName(resource) + '-restriction'
			postProcesses.add([
				var source = findInDiagram(restriction.eContainer)
				if (source === null) {
					restriction.eContainer.addToDiagram(diagram)
					source = findInDiagram(restriction.eContainer)
				}
				
				var target = findInDiagram(restriction.restrictedTo)
				if (target === null) {
					restriction.restrictedTo.addToDiagram(diagram)
					target = findInDiagram(restriction.restrictedTo)
				}
				
				val notation = if (restriction instanceof UniversalRelationshipRestrictionAxiom) '\u2200' else '\u2203'
				
				val edge = newEdge(source, target, id + '-edge', 'restricts')
				edge.children += new SLabel[
					it.id = id + '-restriction-label'
					type = 'label:restricts'
					text = notation + restriction.relationshipDirection.name
				]
				
				semantic2diagram.get(resource.contents.head).children += edge
				edge.traceAndMark(restriction, context)
			])
		}
	}

//------------------- HELPERS

	protected def String renderPredicate(Predicate predicate) {
		switch predicate {
			DirectionalRelationshipPredicate: predicate.relationshipDirection.name + '(' + predicate.variable1 + ', ' + predicate.variable2 + ')'
			ReifiedRelationshipPredicate: predicate.relationship.name + '(' + predicate.kind.toString + ', ' + predicate.variable1 + ', ' + predicate.variable2 + ')'
			EntityPredicate: predicate.entity.name + '(' + predicate.variable + ')'
			default: ''
		}
	}

	protected def OmlHeaderNode newHeading(String id, EObject object) {
		newSElement(OmlHeaderNode, id + '-header', 'classHeader') => [
			layout = 'hbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 8.0
				paddingRight = 8.0
				paddingTop = 8.0
				paddingBottom = 8.0
			]
			children = #[
				new OmlTag [ t |
					t.id = id + '-header-tag'
					t.type = 'tag'
					t.layout = 'stack'
					t.layoutOptions = new LayoutOptions [
						resizeContainer = false
						HAlign = 'center'
						VAlign = 'center'
					] 
					t.children = #[	
						new SLabel [ l |
							l.type = "label:tag"
							l.id = id + '-tag-text'
							l.text = object.findTag()
						]
					]
				],
				(new SLabel [ l |
					l.type = "label:editable"
					l.id = id + '-header-label'
					l.text = id
				]).trace(object)
			]
		]
	}

	protected def OmlHeaderNode newTaglessHeading(String id, EObject object) {
		newSElement(OmlHeaderNode, id + '-header', 'classHeader') => [
			layout = 'hbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 8.0
				paddingRight = 8.0
				paddingTop = 8.0
				paddingBottom = 8.0
			]
			children = #[
				new SLabel [ l |
					l.type = "label:classHeader"
					l.id = id + '-header-label'
					l.text = id
				]
			]
		]
	}

	protected def SEdge newEdge(SModelElement fromElement, SModelElement toElement, String edgeType) {
		val SEdge edge = newSElement(SEdge, fromElement.id + '2' + toElement.id, edgeType)
		edge.sourceId = fromElement.id
		edge.targetId = toElement.id
		return edge
	}

	protected def SEdge newEdge(SModelElement fromElement, SModelElement toElement, String edgeId, String edgeType) {
		val SEdge edge = newSElement(SEdge, edgeId, edgeType)
		edge.sourceId = fromElement.id
		edge.targetId = toElement.id
		return edge
	}

	protected def <E extends SModelElement> E newSElement(Class<E> diagramElementClass, String idStr, String typeStr) {
		diagramElementClass.constructor.newInstance => [
			id = idStr
			type = findType(it) + if (typeStr !== null) ':' + typeStr else ''
			children = new ArrayList<SModelElement>
		]
	}
	
	protected def SCompartment newSCompartment(String id, String type) {
		new SCompartment([
			it.id = id
			layout = 'vbox'
			it.type = type
			layoutOptions = new LayoutOptions([
				paddingLeft = 12.0
				paddingRight = 12.0
				paddingTop = 12.0
				paddingBottom = 12.0
				VGap = 2.0
			])
			children = new ArrayList<SModelElement>
		])
	}

	protected def String findType(SModelElement element) {
		switch element {
			OmlGraph: 'graph'
			SEdge: 'edge'
			OmlNode: 'node'
			OmlLabel: 'ylabel'
			SLabel: 'label'
			SCompartment: 'comp'
			SButton: 'button'
			default: 'dontknow'
		}
	}

	protected def String findTag(EObject object) {
		switch object {
			Terminology: 'T'
			Concept: 'C'
			Aspect: 'A'
			Structure: 'R'
			Scalar: 'S'
			default: ''
		}
	}
	
	def <T extends SModelElement> T traceAndMark(T sElement, EObject element, Context context) {
		semantic2diagram.put(element, sElement)
		sElement.trace(element).addIssueMarkers(element, context)
	}

	protected def findInDiagram(EObject object) {
		if (object instanceof NamedElementReference) {
			switch object {
				AspectReference: semantic2diagram.get(object.aspect)
				ConceptReference: semantic2diagram.get(object.concept)
				default: {
					LOG.error('ERROR: findInDiagram failed to find instance of object in the diagram.')
					null
				}
			}
		} else {
			semantic2diagram.get(object)
		}
	}
}
