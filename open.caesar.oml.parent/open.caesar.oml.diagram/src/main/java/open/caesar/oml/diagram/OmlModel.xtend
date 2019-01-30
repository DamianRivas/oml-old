package open.caesar.oml.diagram

import io.typefox.sprotty.api.SCompartment
import io.typefox.sprotty.api.SLabel
import io.typefox.sprotty.api.SNode
import io.typefox.sprotty.server.xtext.tracing.Traceable
import org.eclipse.xtend.lib.annotations.Accessors
import io.typefox.sprotty.api.SShapeElement
import io.typefox.sprotty.api.Layouting

@Accessors
class OmlNodeClassified extends SNode implements Traceable {
	String cssClass
	String trace
}

@Accessors
class OmlNode extends OmlNodeClassified {
	Boolean expanded
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