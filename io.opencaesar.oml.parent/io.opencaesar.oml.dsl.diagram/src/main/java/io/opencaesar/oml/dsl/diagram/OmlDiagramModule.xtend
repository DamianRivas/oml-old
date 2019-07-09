package io.opencaesar.oml.dsl.diagram

import org.eclipse.sprotty.xtext.IDiagramGenerator
//import io.typefox.sprotty.server.xtext.ide.IdeLanguageServerExtension
import org.eclipse.sprotty.xtext.DefaultDiagramModule

class OmlDiagramModule extends DefaultDiagramModule {
	
//	def Class<? extends IdeLanguageServerExtension> bindIdeLanguageServerExtension() {
//		OmlLanguageServerExtension
//	}
	
	override bindIDiagramServerFactory() {
		OmlDiagramServerFactory
	}
	
	override bindILayoutEngine() {
		OmlLayoutEngine
	}
	
	def Class<? extends IDiagramGenerator> bindIDiagramGenerator() {
		OmlDiagramGenerator
	}
	
//	override bindIPopupModelFactory() {
//		OmlPopupModelFactory
//	}
	
	override bindIDiagramExpansionListener() {
		OmlDiagramExpansionListener
	}
}
