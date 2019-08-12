package io.opencaesar.oml.dsl.ide.diagram

import org.eclipse.sprotty.Action
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString(skipNulls = true)
class FilterAction implements Action {
	public static val KIND = 'filter'
	String kind = KIND

	String data

	new() {	}
	
	new(String data) {
		this.data = data
	}
}