package io.opencaesar.oml.dsl.diagram

import io.typefox.sprotty.api.Layouting
import io.typefox.sprotty.api.SCompartment
import io.typefox.sprotty.api.SEdge
import io.typefox.sprotty.api.SGraph
import io.typefox.sprotty.api.SLabel
import io.typefox.sprotty.api.SNode
import io.typefox.sprotty.api.SShapeElement
import io.typefox.sprotty.server.xtext.tracing.Traceable
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OmlGraph extends SGraph {
	
}

@Accessors
class OmlNode extends SNode implements Traceable {
	String cssClass
	String trace
	Boolean expanded
}

@Accessors
class OmlEdge extends SEdge implements Traceable {
	String trace
}

@Accessors
class OmlHeaderNode extends SCompartment {
	String cssClass
}

@Accessors
class OmlLabel extends SLabel implements Traceable {
	String trace
}

@Accessors 
class OmlTag extends SShapeElement implements Layouting {
	String layout
	
	new() {}
	new((OmlTag)=>void initializer) {
		initializer.apply(this)
	}
}