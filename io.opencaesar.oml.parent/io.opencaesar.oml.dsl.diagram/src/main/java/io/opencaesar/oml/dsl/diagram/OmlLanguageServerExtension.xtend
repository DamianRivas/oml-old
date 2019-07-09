//package io.opencaesar.oml.dsl.diagram
//
//import com.google.inject.Singleton
//import org.eclipse.sprotty.IDiagramServer
//import org.eclipse.sprotty.xtext.LanguageAwareDiagramServer
//import org.eclipse.sprotty.xtext.ide.IdeLanguageServerExtension
//
//@Singleton
//class OmlLanguageServerExtension extends IdeLanguageServerExtension {
//	
//	override protected initializeDiagramServer(IDiagramServer server) {
//		super.initializeDiagramServer(server)
//		val languageAware = server as LanguageAwareDiagramServer
//		languageAware.needsServerLayout = true
//		LOG.info("Created diagram server for " + server.clientId)
//	}
//	
//	override didClose(String clientId) {
//		super.didClose(clientId)
//		LOG.info("Removed diagram server for " + clientId)
//	}
//}
