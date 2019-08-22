package io.opencaesar.oml.dsl.ide.server.codeActions

import org.eclipse.xtext.ide.server.codeActions.ICodeActionService
import org.eclipse.xtext.ide.server.Document
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.lsp4j.CodeActionParams
import org.eclipse.xtext.util.CancelIndicator
import io.opencaesar.oml.Terminology
import java.util.List
import org.eclipse.lsp4j.jsonrpc.messages.Either
import org.eclipse.lsp4j.Command
import org.eclipse.lsp4j.CodeAction
import org.eclipse.emf.ecore.EObject
import io.opencaesar.oml.NamedElement
import org.eclipse.emf.common.util.URI
import org.eclipse.lsp4j.Position
import org.eclipse.lsp4j.WorkspaceEdit
import org.eclipse.lsp4j.TextEdit
import org.eclipse.lsp4j.Range

class OmlCodeActionService implements ICodeActionService {
	static val CREATE_CONCEPT_KIND = 'sprotty.create.concept'
	
	override getCodeActions(Document document, XtextResource resource, CodeActionParams params, CancelIndicator indicator) {
		var root = resource.contents.head
		if (root instanceof Terminology)
			createCodeActions(root, params, document)
		else
			emptyList
	}
	
	private def dispatch List<Either<Command, CodeAction>> createCodeActions(EObject element, CodeActionParams params, Document document) {
		return emptyList
	}
	
	private def dispatch List<Either<Command, CodeAction>> createCodeActions(Terminology terminology, CodeActionParams params, Document document) {
		val result = <Either<Command, CodeAction>>newArrayList
		val position = params.range.end
		position.character = 0
		if (CREATE_CONCEPT_KIND.matchesContext(params)) {
			result.add(Either.forRight(new CodeAction => [
				kind = CREATE_CONCEPT_KIND
				title = 'new Concept'
				edit = createInsertWorkspaceEdit(
					terminology.eResource.URI,
					position,
					'''    concept «getNewName('concept', terminology.statements.map[ el |
						if (el instanceof NamedElement)
							el.name
						else
							''
					])»«'\n'»'''
				)
			]
			))
		}
		return result
	}
	
	private def matchesContext(String kind, CodeActionParams params) {
		if (params.context?.only === null) {
			return true
		} else {
			return params.context.only.exists[kind.startsWith(it)]
		}
	}
	
	private def createInsertWorkspaceEdit(URI uri, Position position, String text) {
		new WorkspaceEdit => [
			changes = #{uri.toString -> #[ new TextEdit(new Range(position, position), text) ]}
		]
	}
	
	private def String getNewName(String prefix, List<? extends String> siblings) {
		for (var i = 0;; i++) {
			val currentName = prefix + i
			if (!siblings.exists[it == currentName])
				return currentName
		}
	}
}