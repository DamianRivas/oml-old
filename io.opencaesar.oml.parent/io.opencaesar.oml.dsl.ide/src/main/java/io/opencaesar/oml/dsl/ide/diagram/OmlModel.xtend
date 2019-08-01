package io.opencaesar.oml.dsl.ide.diagram

import org.eclipse.sprotty.Layouting
import org.eclipse.sprotty.SCompartment
import org.eclipse.sprotty.SEdge
import org.eclipse.sprotty.SGraph
import org.eclipse.sprotty.SLabel
import org.eclipse.sprotty.SNode
import org.eclipse.sprotty.SShapeElement
//import io.typefox.sprotty.server.xtext.tracing.Traceable
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OmlGraph extends SGraph {
	
}

@Accessors
class OmlNode extends SNode {
	String cssClass
//	String trace
	Boolean expanded
}

@Accessors
class OmlEdge extends SEdge {
//	String trace
}

@Accessors
class OmlHeaderNode extends SCompartment {
	String cssClass
}

@Accessors
class OmlLabel extends SLabel {
//	String trace
}

@Accessors 
class OmlTag extends SShapeElement implements Layouting {
	String layout
	
	new() {}
	new((OmlTag)=>void initializer) {
		initializer.apply(this)
	}
}