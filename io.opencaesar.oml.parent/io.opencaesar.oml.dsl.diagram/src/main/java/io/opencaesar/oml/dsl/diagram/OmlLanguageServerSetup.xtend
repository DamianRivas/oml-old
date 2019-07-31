package io.opencaesar.oml.dsl.diagram

import com.google.gson.GsonBuilder
import org.eclipse.sprotty.xtext.launch.DiagramLanguageServerSetup
import org.eclipse.sprotty.layout.ElkLayoutEngine
import org.eclipse.elk.alg.layered.options.LayeredMetaDataProvider
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.elk.core.util.persistence.ElkGraphResourceFactory
import org.eclipse.sprotty.server.json.ActionTypeAdapter
import org.eclipse.sprotty.server.json.EnumTypeAdapter
import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.sprotty.xtext.ls.SyncDiagramServerModule
import org.eclipse.xtext.util.Modules2
import io.opencaesar.oml.dsl.ide.OmlIdeSetup
import com.google.inject.Guice
import io.opencaesar.oml.dsl.OmlRuntimeModule
import io.opencaesar.oml.dsl.ide.OmlIdeModule

class OmlLanguageServerSetup extends DiagramLanguageServerSetup {
	override setupLanguages() {
		ElkLayoutEngine.initialize(new LayeredMetaDataProvider)
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put('elkg', new ElkGraphResourceFactory)
	}
	
	override configureGson(GsonBuilder gsonBuilder) {
		gsonBuilder
			.registerTypeAdapterFactory(new ActionTypeAdapter.Factory)
			.registerTypeAdapterFactory(new EnumTypeAdapter.Factory)
	}
	
	override getLanguageServerModule() {
		Modules2.mixin(
			new ServerModule,
			new SyncDiagramServerModule
		)
	}
}