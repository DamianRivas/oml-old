/*
 * generated by Xtext 2.14.0
 */
package io.opencaesar.oml.dsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import io.opencaesar.oml.Graph

@ExtendWith(InjectionExtension)
@InjectWith(OmlInjectorProvider)
class OmlParsingTest {
	@Inject
	ParseHelper<Graph> parseHelper
	
	@Test
	def void loadModel() {
		val result = parseHelper.parse('''
			open terminology <http://T#> as t {
				concept c
				aspect  a
				unreified relationship R {
					source c
					target a
					forward r
				}
			}
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
