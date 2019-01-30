package open.caesar.oml.diagram

import com.google.inject.Singleton
import io.typefox.sprotty.api.IDiagramServer
import io.typefox.sprotty.server.xtext.LanguageAwareDiagramServer
import io.typefox.sprotty.server.xtext.ide.IdeLanguageServerExtension

@Singleton
class OmlLanguageServerExtension extends IdeLanguageServerExtension {
	
	override protected initializeDiagramServer(IDiagramServer server) {
		super.initializeDiagramServer(server)
		val languageAware = server as LanguageAwareDiagramServer
		languageAware.needsServerLayout = true
		LOG.info("Created diagram server for " + server.clientId)
	}
	
	override didClose(String clientId) {
		super.didClose(clientId)
		LOG.info("Removed diagram server for " + clientId)
	}
}
