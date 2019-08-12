package io.opencaesar.oml.dsl.ide.diagram

import org.eclipse.sprotty.xtext.IDiagramGenerator
import org.eclipse.sprotty.xtext.DefaultDiagramModule

class OmlDiagramModule extends DefaultDiagramModule {
	
	override bindIDiagramServer() {
		OmlDiagramServer
	}
	
	override bindIDiagramServerFactory() {
		OmlDiagramServerFactory
	}
	
	override bindILayoutEngine() {
		OmlLayoutEngine
	}
	
	def Class<? extends IDiagramGenerator> bindIDiagramGenerator() {
		OmlDiagramGenerator
	}
	
	override bindIPopupModelFactory() {
		OmlPopupModelFactory
	}
	
	override bindIDiagramExpansionListener() {
		OmlDiagramExpansionListener
	}
}
