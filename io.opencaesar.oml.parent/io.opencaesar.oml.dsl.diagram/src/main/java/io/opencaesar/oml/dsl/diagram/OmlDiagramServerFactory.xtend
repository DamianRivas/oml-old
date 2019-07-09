package io.opencaesar.oml.dsl.diagram

import org.eclipse.sprotty.ServerLayoutKind
import org.eclipse.sprotty.xtext.DiagramServerFactory
import org.eclipse.sprotty.xtext.LanguageAwareDiagramServer
import org.eclipse.sprotty.ServerLayoutKind

class OmlDiagramServerFactory extends DiagramServerFactory {

	override getDiagramTypes() {
		#['oml-diagram']
	}
	
	override createDiagramServer(String diagramType, String clientId) {
		val server = super.createDiagramServer(diagramType, clientId)
		if (server instanceof LanguageAwareDiagramServer)
			server.serverLayoutKind = ServerLayoutKind.AUTOMATIC
		server
	}
}
