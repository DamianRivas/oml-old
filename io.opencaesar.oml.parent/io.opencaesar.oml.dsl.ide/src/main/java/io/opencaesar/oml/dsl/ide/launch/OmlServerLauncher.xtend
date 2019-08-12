package io.opencaesar.oml.dsl.ide.launch

import org.eclipse.sprotty.xtext.launch.DiagramServerLauncher

class OmlServerLauncher extends DiagramServerLauncher {

	override createSetup() {
		new OmlLanguageServerSetup
	}

	def static void main(String[] args) {
		new OmlServerLauncher().run(args)
	}
}
