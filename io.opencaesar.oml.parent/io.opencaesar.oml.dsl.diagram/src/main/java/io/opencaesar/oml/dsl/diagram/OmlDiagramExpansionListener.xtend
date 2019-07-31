package io.opencaesar.oml.dsl.diagram

import org.eclipse.sprotty.Action
import org.eclipse.sprotty.IDiagramExpansionListener
import org.eclipse.sprotty.IDiagramServer
import org.eclipse.sprotty.xtext.LanguageAwareDiagramServer

class OmlDiagramExpansionListener implements IDiagramExpansionListener {
	
	override expansionChanged(Action action, IDiagramServer server) {
		
		if (server instanceof LanguageAwareDiagramServer) {
//			val languageServerExtension = server.languageServerExtension
//			languageServerExtension.updateDiagram(server)
			server.diagramLanguageServer.diagramUpdater.updateDiagram(server)
		}
	}
}