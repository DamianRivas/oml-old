/*
 * Copyright (C) 2017 TypeFox and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 */
package io.opencaesar.oml.dsl.diagram

import com.google.gson.GsonBuilder
import com.google.inject.Guice
import io.typefox.sprotty.layout.ElkLayoutEngine
import io.typefox.sprotty.server.json.ActionTypeAdapter
import java.net.InetSocketAddress
import java.nio.channels.AsynchronousServerSocketChannel
import java.nio.channels.Channels
import java.util.concurrent.Executors
import java.util.function.Consumer
import io.opencaesar.oml.dsl.OmlRuntimeModule
import io.opencaesar.oml.dsl.ide.OmlIdeModule
import io.opencaesar.oml.dsl.ide.OmlIdeSetup
import io.opencaesar.oml.dsl.ide.server.OmlProjectManager
import org.apache.log4j.Logger
import org.eclipse.elk.alg.layered.options.LayeredMetaDataProvider
import org.eclipse.elk.core.util.persistence.ElkGraphResourceFactory
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.ProjectManager
import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.xtext.resource.IResourceServiceProvider
import org.eclipse.xtext.util.Modules2

class OmlRunSocketServer {
	
	static val LOG = Logger.getLogger(OmlRunSocketServer)

	def static void main(String[] args) throws Exception {
		// Initialize ELK
		ElkLayoutEngine.initialize(new LayeredMetaDataProvider)
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put('elkg', new ElkGraphResourceFactory)
		
		// Do a manual setup that includes the Oml diagram module
		new OmlIdeSetup {
			override createInjector() {
				Guice.createInjector(Modules2.mixin(new OmlRuntimeModule, new OmlIdeModule, new OmlDiagramModule))
			}
		}.createInjectorAndDoEMFRegistration()
		
		val injector = Guice.createInjector(Modules2.mixin(new ServerModule, [
			bind(IResourceServiceProvider.Registry).toProvider(IResourceServiceProvider.Registry.RegistryProvider)
			bind(ProjectManager).to(OmlProjectManager)
		]))
		val serverSocket = AsynchronousServerSocketChannel.open.bind(new InetSocketAddress("localhost", 5007))
		val threadPool = Executors.newCachedThreadPool()
		
		while (true) {
			val socketChannel = serverSocket.accept.get
			val in = Channels.newInputStream(socketChannel)
			val out = Channels.newOutputStream(socketChannel)
			val Consumer<GsonBuilder> configureGson = [ gsonBuilder |
				ActionTypeAdapter.configureGson(gsonBuilder)
			]
			val languageServer = injector.getInstance(LanguageServerImpl)
			val launcher = Launcher.createIoLauncher(languageServer, LanguageClient, in, out, threadPool, [it], configureGson)
			languageServer.connect(launcher.remoteProxy)
			launcher.startListening
			LOG.info("Started language server for client " + socketChannel.remoteAddress)
		}
	}
}