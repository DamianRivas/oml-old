package io.opencaesar.oml.dsl.ide.diagram

import org.eclipse.sprotty.Action
import org.eclipse.sprotty.IDiagramExpansionListener
import org.eclipse.sprotty.IDiagramServer
import org.eclipse.sprotty.xtext.LanguageAwareDiagramServer

class OmlDiagramExpansionListener implements IDiagramExpansionListener {
	
	override expansionChanged(Action action, IDiagramServer server) {
		
		if (server instanceof LanguageAwareDiagramServer) {
			server.diagramLanguageServer.diagramUpdater.updateDiagram(server)
		}
	}
}