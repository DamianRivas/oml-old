package io.opencaesar.oml.dsl.ide.diagram

import com.google.inject.Inject
import org.eclipse.sprotty.IDiagramServer
import org.eclipse.sprotty.IPopupModelFactory
import org.eclipse.sprotty.RequestPopupModelAction
import org.eclipse.sprotty.SModelElement
import org.eclipse.sprotty.xtext.ILanguageAwareDiagramServer
import org.eclipse.sprotty.xtext.tracing.ITraceProvider
//import io.typefox.sprotty.server.xtext.tracing.Traceable

class OmlPopupModelFactory implements IPopupModelFactory {

	@Inject extension ITraceProvider

	override createPopupModel(SModelElement element, RequestPopupModelAction request, IDiagramServer server) {
		if (element.trace !== null) {
			val future = element.withSource(server as ILanguageAwareDiagramServer) [ statement, context |
				null
			]
			future.get
		} else {
			null
		}
	}

}
