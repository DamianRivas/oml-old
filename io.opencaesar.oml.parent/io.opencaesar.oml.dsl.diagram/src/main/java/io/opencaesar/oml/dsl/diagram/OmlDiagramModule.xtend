package io.opencaesar.oml.dsl.diagram

import org.eclipse.sprotty.xtext.IDiagramGenerator
//import org.eclipse.sprotty.xtext.ide.IdeDiagramModule
import org.eclipse.sprotty.xtext.DefaultDiagramModule
//import org.eclipse.sprotty.xtext.ide.IdeLanguageServerExtension

//class OmlDiagramModule extends IdeDiagramModule {
class OmlDiagramModule extends DefaultDiagramModule {
	
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
	
//	def Class<? extends IdeLanguageServerExtension> bindIdeLanguageServerExtension() {
//		OmlLanguageServerExtension
//	}
}
