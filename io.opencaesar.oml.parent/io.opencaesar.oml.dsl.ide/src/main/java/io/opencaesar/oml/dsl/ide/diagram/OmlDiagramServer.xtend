package io.opencaesar.oml.dsl.ide.diagram

import org.eclipse.sprotty.xtext.LanguageAwareDiagramServer
import org.eclipse.sprotty.Action

class OmlDiagramServer extends LanguageAwareDiagramServer {
	
	override handleAction(Action action) {
		switch(action.getKind()) {
			case FilterAction.KIND: {
				handle(action as FilterAction)
			}
		}
		super.handleAction(action)
	}

	def protected handle(FilterAction action) {
		System.out.println("FilterAction.data = " + action.data)
		options.put("filterAction", action.data)
		diagramLanguageServer.diagramUpdater.updateDiagram(this)
	}
}
