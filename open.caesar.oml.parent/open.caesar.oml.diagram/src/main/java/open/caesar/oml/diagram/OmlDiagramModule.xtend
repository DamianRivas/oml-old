package open.caesar.oml.diagram

import io.typefox.sprotty.server.xtext.IDiagramGenerator
import io.typefox.sprotty.server.xtext.ide.IdeDiagramModule
import io.typefox.sprotty.server.xtext.ide.IdeLanguageServerExtension

class OmlDiagramModule extends IdeDiagramModule {
	
	def Class<? extends IdeLanguageServerExtension> bindIdeLanguageServerExtension() {
		OmlLanguageServerExtension
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
