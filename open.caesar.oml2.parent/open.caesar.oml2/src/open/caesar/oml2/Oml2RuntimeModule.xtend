/*
 * generated by Xtext 2.14.0
 */
package open.caesar.oml2

import com.google.inject.Binder
import org.eclipse.xtext.formatting2.FormatterPreferenceValuesProvider
import org.eclipse.xtext.formatting2.FormatterPreferences
import org.eclipse.xtext.preferences.IPreferenceValuesProvider

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class Oml2RuntimeModule extends AbstractOml2RuntimeModule {
	// workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=495851
	def void configureIPreferenceValuesProvider(Binder binder) {
		binder.bind(IPreferenceValuesProvider).annotatedWith(FormatterPreferences).to(FormatterPreferenceValuesProvider)
	}
}
