package open.caesar.oml.ide.server

import java.util.Map
import open.caesar.oml.settings.JsonFileBasedPreferenceValues
import open.caesar.oml.settings.PreferenceValuesProvider
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.preferences.IPreferenceValues
import org.eclipse.xtext.preferences.PreferenceKey

class OmlExclusionProvider {
	
	static val EXCLUSION_PATHS = new PreferenceKey("excludePath", "")

	Map<URI, IPreferenceValues> preferences = newHashMap
	
	def isExcluded(URI uri, URI projectURI) {
		val uriAsString = uri.toString
		val excludedSegments = getPreferences(projectURI).getPreference(EXCLUSION_PATHS) 
		if (excludedSegments !== null && !excludedSegments.empty) {
			val truncatedProjectURI = if (projectURI.lastSegment.empty) projectURI.trimSegments(1) else projectURI 
			val excludedPaths = excludedSegments.split(':').map[ path |
				truncatedProjectURI
					.appendSegments(path.split('/').filter[!empty])
					.appendSegment('')
					.toString
			]
			return excludedPaths.exists[
				uriAsString.startsWith(it)
			]
		}
		return false
	}

	private def getPreferences(URI projectURI) {
		val prefs = preferences.get(projectURI) ?: {
			val newPrefs = PreferenceValuesProvider.createPreferenceValues(projectURI)
			preferences.put(projectURI, newPrefs)
			newPrefs
		}
		if (prefs instanceof JsonFileBasedPreferenceValues)
			prefs.checkIsUpToDate
		prefs
	}
}
