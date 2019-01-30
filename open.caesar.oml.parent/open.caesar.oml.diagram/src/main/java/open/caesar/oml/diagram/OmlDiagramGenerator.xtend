package open.caesar.oml.diagram

import com.google.inject.Inject
import io.typefox.sprotty.api.IDiagramState
import io.typefox.sprotty.api.LayoutOptions
import io.typefox.sprotty.api.SButton
import io.typefox.sprotty.api.SCompartment
import io.typefox.sprotty.api.SEdge
import io.typefox.sprotty.api.SGraph
import io.typefox.sprotty.api.SLabel
import io.typefox.sprotty.api.SModelElement
import io.typefox.sprotty.api.SModelRoot
import io.typefox.sprotty.api.SNode
import io.typefox.sprotty.server.xtext.IDiagramGenerator
import io.typefox.sprotty.server.xtext.tracing.ITraceProvider
import io.typefox.sprotty.server.xtext.tracing.Traceable
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import open.caesar.oml.Concept
import open.caesar.oml.Entity
import open.caesar.oml.Extent
import open.caesar.oml.Module
import open.caesar.oml.Terminology
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.util.CancelIndicator

import static extension open.caesar.oml.Oml.*
import open.caesar.oml.Aspect
import open.caesar.oml.Relation

class OmlDiagramGenerator implements IDiagramGenerator {
	static val LOG = Logger.getLogger(OmlDiagramGenerator)

	@Inject ITraceProvider traceProvider
	var Map<EObject, SModelElement> semantic2diagram
	val Map<String, OmlNode> id2moduleNode = newHashMap
	var List<()=>void> postProcesses
	var SGraph diagram
	var IDiagramState diagramState
	
	
	override generate(Resource resource, IDiagramState state, CancelIndicator cancelIndicator) {
		this.diagramState = state

		val content = resource.contents.head
		if (content instanceof Extent) {
			LOG.info("Generating diagram for input: '" + resource.URI.lastSegment + "'")
			return generateDiagram(content, cancelIndicator)
		}
		
		return null
	}

	protected def SModelRoot generateDiagram(Extent extent, CancelIndicator cancelIndicator) {
		semantic2diagram = new HashMap
		postProcesses = new ArrayList
		diagram = new SGraph => [
			type = 'graph'
			id = 'oml'
			layoutOptions = new LayoutOptions [
				HAlign = 'left'
				HGap = 10.0
				VGap = 0.0
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children = generateDiagramRoots(diagram, diagram, extent.modules)
		]
		postProcesses.forEach[process|process.apply]
		return diagram
	}

	protected def List<SModelElement> generateDiagramRoots(SModelElement viewParentElement, SModelElement modelParentElement, List<Module> modules) {
		val diagramRoots = new ArrayList
		for (module : modules) {
			val SModelElement diagramElement = module.generateDiagramElement()
			if (diagramElement !== null) {
				val eid = diagramElement.id
				LOG.info("CREATED ELEMENT FOR module:" + module.toString + " WITH ID " + eid)
				if (semantic2diagram.filter[k, v|v.id == eid].size > 0) {
					LOG.info(eid + " ALREADY EXISTS!!!")
				}
				semantic2diagram.put(module, diagramElement)
				if(!diagramRoots.contains(diagramElement)) {
					diagramRoots.add(diagramElement)
					diagramElement.trace(module)
				}
			}
		}
		return diagramRoots
	}
	
	protected dispatch def OmlNode generateDiagramElement(Module module) {
		val id = module.iri
		var moduleNode = id2moduleNode.get(id)
		if(moduleNode !== null) {
			return moduleNode
		}
		
		moduleNode = newSElement(OmlNode, id, 'module') => [
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingTop = 5.0
				paddingBottom = 5.0
				paddingLeft = 5.0
				paddingRight = 5.0
			]
			children.add(newSElement(SCompartment, id + '-heading', 'comp') => [
				layout = 'hbox'
				children.add(newSElement(SLabel, id + '-label', 'heading') => [
					text = id
				])
				children.add(newSElement(SButton, id + '-expand', 'expand'))
			])
			expanded = diagramState.currentModel.type == 'NONE' || diagramState.expandedElements.contains(id)
			if (expanded) {
				children.addAll(module.allStatements.filter(Concept).map[generateDiagramElement()])
				children.addAll(module.allStatements.filter(Aspect).map[generateDiagramElement()])
				children.addAll(module.allStatements.filter(Relation).map[generateDiagramElement()])
				diagramState.expandedElements.add(id)	
			}
		]

		id2moduleNode.put(id, moduleNode)
		return moduleNode
	}

	protected dispatch def OmlNode generateDiagramElement(Entity entity) {
		val id = entity.name
		val entityNode = newSElement(OmlNode, id, 'class') => [
			cssClass = 'moduleNode'
			layout = 'vbox'
			layoutOptions = new LayoutOptions [
				paddingLeft = 0.0
				paddingRight = 0.0
				paddingTop = 0.0
				paddingBottom = 0.0
			]
			children.add(newSElement(OmlHeaderNode, id + '-header', 'classHeader') => [
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
							paddingLeft = 0.0
							paddingRight = 0.0
							paddingTop = 0.0
							paddingBottom = 0.0
						] 
						t.children = #[	
							new SLabel [ l |
								l.type = "label:tag"
								l.id = id + '-tag-text'
								l.text = entity.findTag()
							]
						]
					],
					new SLabel [ l |
						l.type = "label:classHeader"
						l.id = id + '-header-label'
						l.text = id
					]
				]
				
			])
		]
		entityNode.trace(entity)
		semantic2diagram.put(entity, entityNode)
		return entityNode
	}

	protected dispatch def SEdge generateDiagramElement(Relation relation) {
		val source = semantic2diagram.get(relation.source)
		val target = semantic2diagram.get(relation.target)
		val edge = newEdge(source, target, "uses")
		edge.trace(relation)
		semantic2diagram.put(relation, edge)
		return edge
	}
	
	protected def String findTag(EObject object) {
		switch object {
			Terminology: 'T'
			Concept: 'C'
			Aspect: 'A'
			default: ''
		}
	}

	protected def <E extends SModelElement> E newSElement(Class<E> diagramElementClass, String idStr, String typeStr) {
		diagramElementClass.constructor.newInstance => [
			id = idStr
			type = findType(it) + ':' + typeStr
			children = new ArrayList<SModelElement>
		]
	}

	protected def SEdge newEdge(SModelElement fromElement, SModelElement toElement, String edgeType) {
		val SEdge edge = newSElement(SEdge, fromElement.id + '2' + toElement.id + '-edge', edgeType)
		edge.sourceId = fromElement.id
		edge.targetId = toElement.id
		return edge
	}

	protected def String findType(SModelElement element) {
		switch element {
			SNode: 'node'
			OmlLabel: 'ylabel'
			SLabel: 'label'
			SCompartment: 'comp'
			SEdge: 'edge'
			SButton: 'button'
			default: 'dontknow'
		}
	}

	protected def void trace(SModelElement element, EObject object) {
		if (element instanceof Traceable) {
			traceProvider.trace(element, object)
		}
	}

}
