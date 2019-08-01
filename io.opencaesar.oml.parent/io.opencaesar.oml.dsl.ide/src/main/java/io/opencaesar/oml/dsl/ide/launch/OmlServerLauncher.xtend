package io.opencaesar.oml.dsl.ide.launch

import com.google.gson.GsonBuilder
import com.google.inject.Guice
import com.google.inject.Inject
import org.eclipse.sprotty.layout.ElkLayoutEngine
import org.eclipse.sprotty.server.json.ActionTypeAdapter
import java.util.concurrent.Executors
import java.util.function.Consumer
import java.util.function.Function
import io.opencaesar.oml.dsl.OmlRuntimeModule
import io.opencaesar.oml.dsl.ide.OmlIdeModule
import io.opencaesar.oml.dsl.ide.OmlIdeSetup
import io.opencaesar.oml.dsl.ide.server.OmlProjectManager
import org.apache.log4j.AppenderSkeleton
import org.apache.log4j.AsyncAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.spi.LoggingEvent
import org.eclipse.elk.alg.layered.options.LayeredMetaDataProvider
import org.eclipse.lsp4j.MessageParams
import org.eclipse.lsp4j.MessageType
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.jsonrpc.MessageConsumer
import org.eclipse.lsp4j.jsonrpc.validation.ReflectiveMessageValidator
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.LaunchArgs
import org.eclipse.xtext.ide.server.ProjectManager
import org.eclipse.xtext.ide.server.ServerLauncher
import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.xtext.resource.IResourceServiceProvider
import org.eclipse.xtext.util.Modules2
import org.eclipse.sprotty.xtext.launch.DiagramServerLauncher

class OmlServerLauncher extends DiagramServerLauncher {
	
	override createSetup() {
		new OmlLanguageServerSetup
	}
	
	def static void main(String[] args) {
		new OmlServerLauncher().run(args)
		
		// Do a manual setup that includes the Oml diagram module
//		new OmlIdeSetup {
//			override createInjector() {
//				Guice.createInjector(Modules2.mixin(new OmlRuntimeModule, new OmlIdeModule, new OmlDiagramModule))
//			}
//		}.createInjectorAndDoEMFRegistration()
	}
	
//	def static void main(String[] args) {
//		
//		// Initialize ELK
//		ElkLayoutEngine.initialize(new LayeredMetaDataProvider)
//
//		// Do a manual setup that includes the Oml diagram module
//		new OmlIdeSetup {
//			override createInjector() {
//				Guice.createInjector(Modules2.mixin(new OmlRuntimeModule, new OmlIdeModule, new OmlDiagramModule))
//			}
//		}.createInjectorAndDoEMFRegistration()
//		
//		// Launch the server
//		launch(ServerLauncher.name, args, Modules2.mixin(new ServerModule, [
//			bind(ServerLauncher).to(OmlServerLauncher)
//			bind(IResourceServiceProvider.Registry).toProvider(IResourceServiceProvider.Registry.RegistryProvider)
//			bind(ProjectManager).to(OmlProjectManager)
//		]))
//	}
//
//	@Inject LanguageServerImpl languageServer
//	
//	override start(LaunchArgs args) {
//		val executorService = Executors.newCachedThreadPool
//		val Consumer<GsonBuilder> configureGson = [ gsonBuilder |
//			ActionTypeAdapter.configureGson(gsonBuilder)
//		]
//		val launcher = Launcher.createIoLauncher(languageServer, LanguageClient, args.in, args.out, executorService, args.wrapper, configureGson)
//		val client = launcher.remoteProxy
//		languageServer.connect(client)
//		// Redirect Log4J output to a file
//		Logger.rootLogger => [
//			removeAllAppenders()
//			addAppender(new AsyncAppender() => [
//				addAppender(new LanguageClientAppender(client))
//			])
//		]
//		val future = launcher.startListening
//		while (!future.done) {
//			Thread.sleep(10_000l)
//		}
//	}
//	
//	private def Function<MessageConsumer, MessageConsumer> getWrapper(LaunchArgs args) {
//		[ consumer |
//			var result = consumer
//			if (args.trace !== null) {
//				result = [ message |
//					args.trace.println(message)
//					args.trace.flush()
//					consumer.consume(message)
//				]
//			}
//			if (args.validate) {
//				result = new ReflectiveMessageValidator(result)
//			}
//			return result
//		]
//	}
//	
//	@Data static class LanguageClientAppender extends AppenderSkeleton {
//		LanguageClient client
//		
//		override protected append(LoggingEvent event) {
//			client.logMessage(new MessageParams => [
//				message = event.message.toString 
//					+ if(event.throwableStrRep !== null && event.throwableStrRep.length > 0) 
//						': ' + event.throwableStrRep?.join('\n')
//					  else 
//					    ''
//				type = switch event.getLevel {
//					case Level.ERROR: MessageType.Error
//					case Level.INFO : MessageType.Info
//					case Level.WARN : MessageType.Warning
//					default : MessageType.Log
//				}
//			])
//		}
//		
//		override close() {
//			
//		}
//		
//		override requiresLayout() {
//			return false
//		}
//		
//	}
}
