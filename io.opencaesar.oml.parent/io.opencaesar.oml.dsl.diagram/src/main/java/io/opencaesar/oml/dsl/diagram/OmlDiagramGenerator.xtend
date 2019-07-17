package io.opencaesar.oml.dsl.diagram

import com.google.inject.Inject
import io.opencaesar.oml.Graph
import io.opencaesar.oml.Aspect
import io.opencaesar.oml.AspectReference
import io.opencaesar.oml.Concept
import io.opencaesar.oml.ConceptReference
import io.opencaesar.oml.Description
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
//import io.typefox.sprotty.server.xtext.tracing.Traceable
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.util.CancelIndicator

import static extension io.opencaesar.oml.Oml.*

class OmlDiagramGenerator implements IDiagramGenerator {
	
	static val LOG = Logger.getLogger(OmlDiagramGenerator)

	@Inject extension ITraceProvider traceProvider
	@Inject extension SIssueMarkerDecorator

	var IDiagramState diagramState
	var Resource resource
	
	var Map<EObject, SModelElement> semantic2diagram
	var List<()=>void> postProcesses
	
	override generate(Context context) {
		LOG.info("Generating diagram for input: '" + resource.URI.lastSegment + "'")
		(context.resource.contents.head as Graph).toSGraph(context)
	}
	
	def toSGraph(Graph graph, extension Context context) {
		(new SGraph [
			id = idCache.uniqueId(graph, graph.name)
			children = (graph.members.map[toSNode(context)]).toList // TODO
			
		])
	}
	
	def toSNode(EObject e, Context context) {
		new SModelElement
	}
	
	def <T extends SModelElement> T traceAndMark(T sElement, EObject element, Context context) {
		sElement.trace(element).addIssueMarkers(element, context)
	}
	
	/*
	override SModelRoot generate(Resource resource, IDiagramState state, CancelIndicator cancelIndicator) {
		LOG.info("Generating diagram for input: '" + resource.URI.lastSegment + "'")
		
		this.diagramState = state
		this.resource = resource
		
		semantic2diagram = new HashMap
		postProcesses = new ArrayList
		
		val diagram = newSElement(OmlGraph, 'root', null) => [
			layoutOptions = new LayoutOptions [
				HAlign = 'left'
				HGap = 10.0
			]
		]
		
		resource.allContents.forEach[object|
			object.addToDiagram(diagram)
		]
		
		postProcesses.forEach[process|process.apply]

		return diagram
	}

	def dispatch toSGraph(Terminology terminology, extension Context context) {
		(new SGraph[
			id = idCache.uniqueId(terminology, terminology.name)
			
			// PAUL'S EXAMPLE
//			resource.allContents.forEach[object|
//				object.addToDiagram(it)
//			]
//			
			children = (terminology.members.map[toSNode(context)])
			
			children = (terminology.states.map[toSNode(context)] 
					  + terminology.states.map[transitions].flatten.map[toSEdge(context)]
			).toList
		]).traceAndMark(terminology, context)
	}
	
	def dispatch toSGraph(Description description, extension Context context) {
		(new SGraph[
			id = idCache.uniqueId(description, description.name)
			
			// PAUL'S EXAMPLE
//			resource.allContents.forEach[object|
//				object.addToDiagram(it)
//			]
//			
//			children = (graph.statements.map[toSNode(context)]).toList
			
			children = (description.states.map[toSNode(context)] 
					  + description.states.map[transitions].flatten.map[toSEdge(context)]
			).toList
		]).traceAndMark(description, context)
	}

//	def toSGraph(Graph graph, extension Context context) {
//		(new SGraph [
//			id = idCache.uniqueId(graph, graph.name)
//			
//			// PAUL'S EXAMPLE
//			resource.allContents.forEach[object|
//				object.addToDiagram(it)
//			]
//			
//			children = (graph.statements.map[toSNode(context)]).toList
//			
//			children = (graph.states.map[toSNode(context)] 
//					  + graph.states.map[transitions].flatten.map[toSEdge(context)]
//			).toList
//		]).traceAndMark(graph, context)
//	}

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
		trace(node, terminology)
		
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
		trace(node, importedTerminology)
		
		val importingTerminology = ext.graph as Terminology
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
		trace(node, aspect)
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
		trace(node, concept)
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
		trace(node, structure)
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
		trace(node, scalar)
	}

	protected dispatch def void addToDiagram(ScalarRangeReference reference, SGraph diagram) {
		if (reference.scalar !== null) {
			reference.scalar.addToDiagram(diagram)
		}
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
			val edge = newEdge(source, target, id, "augments") => [e|
				e.children += newSElement(SLabel, id + '-label', 'text') => [
					text = id
				]
				if (relationship.inverseFunctional) {
					e.children += newSElement(SLabel, id + '-invFunc', 'subtext') => [
						text = "[0,1]"
					]
				}
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
				if (relationship.inverseFunctional) {
					children += newSElement(SLabel, id + '-invFunc', 'subtext') => [
						text = "[0,1]"
					]
				}
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

//---------

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

//	protected def void trace(SModelElement element, EObject object) {
//		if (element instanceof Traceable) {
//			traceProvider.trace(element, object)
//		}
//		semantic2diagram.put(object, element)
//	}
	
	def <T extends SModelElement> T traceAndMark(T sElement, EObject element, Context context) {
		sElement.trace(element).addIssueMarkers(element, context) 
	}
	* 
	*/
}
