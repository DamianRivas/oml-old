package io.opencaesar.oml.dsl.ide.launch

import org.eclipse.sprotty.xtext.launch.DiagramServerSocketLauncher

class OmlRunSocketServer extends DiagramServerSocketLauncher {

	override createSetup() {
		new OmlLanguageServerSetup
	}

	def static void main(String... args) {
		new OmlRunSocketServer().run(args)
	}
}